import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/screen/transaction/controller/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import '../../../../DB/functions/transaction/transaction_db.dart';
import '../../../category/model/category_typemodel.dart';
import '../../model/transaction_modal.dart';

class ViewTransactionProvider with ChangeNotifier {
  final List<TransactionModel> allData = TransactionDb.instence.transactionList;
  String dropdownvalueCategory = 'All';
  String dropdownvalueDay = 'All';
  bool search = false;
  TransactionModel? model;

  List<TransactionModel> foundData = [];
  checkFilter() {
    List<TransactionModel> results = [];
    final String todaydate = DateFormat('yMMMMd').format(DateTime.now());
    final DateTime todaySort = DateFormat('yMMMMd').parse(todaydate);
    final DateTime weekDate = DateTime.now().subtract(const Duration(days: 7));
    final DateTime monthDate =
        DateTime.now().subtract(const Duration(days: 30));
    final DateTime yearDate =
        DateTime.now().subtract(const Duration(days: 365));

    if (dropdownvalueCategory == 'All' && dropdownvalueDay == 'All') {
      results = allData;
    } else if (dropdownvalueCategory == 'Income' && dropdownvalueDay == 'All') {
      results = allData
          .where((element) =>
              element.category.type == CategoryType.income &&
              dropdownvalueDay == 'All')
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'All') {
      results = allData
          .where((element) =>
              element.category.type == CategoryType.expense &&
              dropdownvalueDay == 'All')
          .toList();
    } else if (dropdownvalueCategory == 'All' && dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) => element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) => element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) => element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) => element.date.isAfter(yearDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(yearDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(yearDate),
          )
          .toList();
    }

    foundData = results;
    notifyListeners();
  }

  void searchFilter(String enteredKeyword) {
    List<TransactionModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where(
            (user) => user.category.name.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    foundData = results;
    notifyListeners();
  }

  void visibilitysearch() {
    if (search == true) {
      search = false;
    } else {
      search = true;
    }
    notifyListeners();
  }

  void initialDataSetting() {
    final data = allData;
    foundData = data;
    notifyListeners();
  }

  Future<void> deleteItem(TransactionModel modal, BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly delete your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                TransactionDb.instence
                    .deleteTransactoin(modal.id)
                    .whenComplete(() => checkFilter());
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    checkFilter();
                    TransactionDb.instence.refreshUI();
                    Provider.of<TransactionProvider>(context, listen: false)
                        .addTotalTransaction();
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 20,
                  content: Text(
                    'Transaction successfully deleted',
                  ),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    notifyListeners();
  }
}
