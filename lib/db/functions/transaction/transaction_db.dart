import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../home/category/model/category_typemodel.dart';
import '../../../home/transaction/model/transaction_modal.dart';

// ignore: constant_identifier_names
const TRANSACTION_DB_NAME = 'TRANSACTION-DB';

class TransactionDb with ChangeNotifier {
  TransactionDb._internal();
  static TransactionDb instence = TransactionDb._internal();
  factory TransactionDb() {
    return instence;
  }

  num totalIncome = 0;
  num totalExpense = 0;
  num totalBalence = 0;
  List<TransactionModel> transactionList = [];

  List<TransactionModel> incomeTransaction = [];
  List<TransactionModel> expenseTransaction = [];
  List<TransactionModel> totelTransaction = [];

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
    transactionList.clear();
    transactionList.addAll(allTransaction);
    notifyListeners();
  }

  Future<void> addTotalTransaction() async {
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    incomeTransaction.clear();
    expenseTransaction.clear();
    totalIncome = 0;
    totalExpense = 0;
    totalBalence = 0;
    Future.forEach(
      allTransaction,
      (TransactionModel data) {
        totalBalence = totalBalence + data.amount;

        if (data.type == CategoryType.income) {
          incomeTransaction.add(data);
          totalIncome = totalIncome + data.amount;
        } else if (data.type == CategoryType.expense) {
          expenseTransaction.add(data);
          totalExpense = totalExpense + data.amount;
        }
      },
    );
    totalBalence = totalIncome - totalExpense;
    notifyListeners();
    await refreshUI();
  }
}
