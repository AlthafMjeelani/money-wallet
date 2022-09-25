import 'package:hive_flutter/hive_flutter.dart';
import '../../../screen/transaction/model/transaction_modal.dart';

// ignore: constant_identifier_names
const TRANSACTION_DB_NAME = 'TRANSACTION-DB';

class TransactionDb {
  TransactionDb._internal();
  static TransactionDb instence = TransactionDb._internal();
  factory TransactionDb() {
    return instence;
  }
  List<TransactionModel> transactionList = [];

  Future<void> addTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionDB.put(value.id, value);
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionDB.values.toList();
  }

  Future<void> deleteTransactoin(String index) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionDB.delete(index);
    await refreshUI();
  }

  Future<void> updateList(String id, TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionDB.put(id, value);
    await refreshUI();
  }

  Future<List<TransactionModel>> refreshUI() async {
    final allTransaction = await getAllTransaction();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    transactionList.clear();
    transactionList.addAll(allTransaction);
    return allTransaction;
  }
}
