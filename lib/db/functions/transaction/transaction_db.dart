import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../home/category/model/category_typemodel.dart';
import '../../../home/transaction/model/transaction_modal.dart';

// ignore: constant_identifier_names
const TRANSACTION_DB_NAME = 'TRANSACTION-DB';

class TransactionDb {
  TransactionDb._internal();
  static TransactionDb instence = TransactionDb._internal();
  factory TransactionDb() {
    return instence;
  }

  ValueNotifier<num> totalIncome = ValueNotifier(0);
  ValueNotifier<num> totalExpense = ValueNotifier(0);
  ValueNotifier<num> totalBalence = ValueNotifier(0);

  final ValueNotifier<List<TransactionModel>> transactionListNotifire =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> incomeTransactionNotifire =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionNotifire =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> totelTransactionNotifire =
      ValueNotifier([]);

  Future<void> addTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionDB.put(value.id, value);
    await refreshUI();
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionDB.values.toList();
  }

  Future<void> deleteTransactoin(String index) async {
    final transactionyDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionyDB.delete(index);
    await refreshUI();
  }

  Future<void> refreshUI() async {
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifire.value.clear();
    transactionListNotifire.value.addAll(allTransaction);
    transactionListNotifire.notifyListeners();
  }

  Future<void> addTotalTransaction() async {
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    incomeTransactionNotifire.value.clear();
    expenseTransactionNotifire.value.clear();
    totalIncome.value = 0;
    totalExpense.value = 0;
    totalBalence.value = 0;
    Future.forEach(
      allTransaction,
      (TransactionModel data) {
        totalBalence.value = totalBalence.value + data.amount;

        if (data.type == CategoryType.income) {
          incomeTransactionNotifire.value.add(data);
          totalIncome.value = totalIncome.value + data.amount;
        } else if (data.type == CategoryType.expense) {
          expenseTransactionNotifire.value.add(data);
          totalExpense.value = totalExpense.value + data.amount;
        }
      },
    );
    totalBalence.value = totalIncome.value - totalExpense.value;
    incomeTransactionNotifire.notifyListeners();
    expenseTransactionNotifire.notifyListeners();
    totalIncome.notifyListeners();
    totalExpense.notifyListeners();
    totalBalence.notifyListeners();
    await refreshUI();
  }
}
