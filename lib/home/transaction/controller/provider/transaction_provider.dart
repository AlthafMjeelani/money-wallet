import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/transaction/model/enum.dart';
import 'package:provider/provider.dart';

import '../../../../DB/functions/category/category_db.dart';
import '../../../../widget/snackbar_widget.dart';
import '../../../Homescreen/controller/provider/home_screen_provider.dart';
import '../../../Homescreen/view/screen_bottomvavigation.dart';
import '../../../category/model/category_modal.dart';
import '../../../category/model/category_typemodel.dart';
import '../../../category/view/screen_category.dart';
import '../../model/transaction_modal.dart';

class TransactionProvider with ChangeNotifier {
  num totalIncome = 0;
  num totalExpense = 0;
  num totalBalence = 0;
  List<TransactionModel> allTransactionList = [];
  List<TransactionModel> incomeTransaction = [];
  List<TransactionModel> expenseTransaction = [];
  List<TransactionModel> totelTransaction = [];
  final formKey = GlobalKey<FormState>();
  final formKeyAlert = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime? pickedDate;
  CategoryType selectedCategoryType = CategoryType.income;
  CategoryModel? selectedCategoryModel;
  String? dropdownvalueCategory;
  ActionType? type;
  TransactionModel? modal;

  void incomeRadioButton() {
    selectedCategoryType = CategoryType.income;
    dropdownvalueCategory = null;
    notifyListeners();
  }

  void expenseRadioButton() {
    selectedCategoryType = CategoryType.expense;
    dropdownvalueCategory = null;
    notifyListeners();
  }

  void dropDownValues(newValue) {
    dropdownvalueCategory = null;
    dropdownvalueCategory = newValue;

    notifyListeners();
  }

  void pickDate(context, date) {
    if (pickedDate != null) {
      dateController.text = DateFormat('yMMMMd').format(pickedDate!);
    } else {
      dateController.text = DateFormat('yMMMMd').format(date);
    }
    notifyListeners();
  }

  void textFeildClear() {
    amountController.clear();
    dateController.clear();
    notifyListeners();
  }

  void categoryClear() {
    categoryNameController.clear();
    CategoryDb.instence.refreshUI();
    notifyListeners();
  }

  Future<void> transactionRefresh() async {
    final allTransaction = await TransactionDb.instence.refreshUI();
    allTransactionList.clear();
    allTransactionList.addAll(allTransaction);
    notifyListeners();
  }

  Future<void> addTotalTransaction() async {
    final allTransaction = await TransactionDb.instence.refreshUI();
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
  }

  String? addCategory(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter category name';
    }

    if (selectedCategoryType == CategoryType.income) {
      final income = CategoryDb.instence.incomeCategoryList.value
          .map((e) => e.name.trim().toLowerCase())
          .toList();
      if (income.contains(categoryNameController.text.trim().toLowerCase())) {
        return 'Category already exists';
      }
    }
    if (selectedCategoryType == CategoryType.expense) {
      final expense = CategoryDb.instence.expenseCategoryList.value
          .map((e) => e.name.trim().toLowerCase())
          .toList();
      if (expense.contains(categoryNameController.text.trim().toLowerCase())) {
        return 'Category already exists';
      }
    }
    return null;
  }

  void submitCategory(context) {
    if (formKey.currentState!.validate()) {
      final categoryName = categoryNameController.text.trim();
      if (categoryName.isEmpty) {
        return;
      }
      final category = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: categoryName,
        type: selectedCategoryType == CategoryType.income
            ? CategoryType.income
            : CategoryType.expense,
      );
      CategoryDb().insertCategory(category);
      categoryClear();
      Provider.of<HomeScreenProvider>(context, listen: false)
          .navigatorPop(context);

      SnackBarWidget().show(context, 'successfully added to categorylist');
    }
    notifyListeners();
  }

  String? validator(value, String? text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  void transactionSubmit(context) {
    if (formKeyAlert.currentState!.validate()) {
      final amount = amountController.text;

      if (amount.isEmpty) {
        return;
      }

      final parsedAmount = double.tryParse(amount);
      if (parsedAmount == null) {
        return;
      }

      pickedDate ??= modal!.date;
      if (selectedCategoryModel == null) {
        return;
      }
      TransactionModel dbModel = TransactionModel(
        amount: parsedAmount,
        date: pickedDate!,
        type: selectedCategoryType,
        category: selectedCategoryModel!,
        id: type == ActionType.addscreen
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : modal!.id,
      );
      if (type == ActionType.editscreen) {
        updateTransaction(dbModel);
      } else {
        addTransaction(dbModel);
      }
      textFeildClear();
      dropdownvalueCategory = null;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        elevation: 20,
        content: Text(
          'Transaction successfully added',
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ScreenBottomNavbar(),
          ),
          (route) => false);
    }
  }

  Future<void> addTransaction(TransactionModel transactionModal) async {
    await TransactionDb.instence.addTransaction(transactionModal);
  }

  Future<void> updateTransaction(TransactionModel value) async {
    await TransactionDb.instence.updateList(value);
  }
}
