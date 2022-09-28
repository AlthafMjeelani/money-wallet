import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:provider/provider.dart';
import '../../../../DB/functions/category/category_db.dart';
import '../../../../widget/snackbar_widget.dart';
import '../../../../screen/Homescreen/controller/provider/home_screen_provider.dart';
import '../../../Homescreen/view/screen_bottomvavigation.dart';
import '../../../category/controller/provider/category_provider.dart';
import '../../../category/model/category_modal.dart';
import '../../../category/model/category_typemodel.dart';
import '../../model/enum.dart';
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

  void pickDate(context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        useRootNavigator: false);
    if (pickedDate == null) {
      return;
    }
    dateController.text = DateFormat('yMMMMd').format(pickedDate!);
    notifyListeners();
  }

  void textFeildClear() {
    amountController.clear();
    dateController.clear();
    notifyListeners();
  }

  void categoryClear(context) {
    Provider.of<CategoryProvider>(context, listen: false)
        .categoryNameController
        .clear();
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
        totalBalence = totalBalence + data.amount.toDouble();

        if (data.type == CategoryType.income) {
          incomeTransaction.add(data);
          totalIncome = totalIncome + data.amount.toDouble();
        } else if (data.type == CategoryType.expense) {
          expenseTransaction.add(data);
          totalExpense = totalExpense + data.amount.toDouble();
        }
      },
    );
    totalBalence = totalIncome - totalExpense;
    notifyListeners();
  }

  String? addCategory(value, context) {
    if (value == null || value.isEmpty) {
      return 'Please enter category name';
    }

    if (selectedCategoryType == CategoryType.income) {
      final income = Provider.of<CategoryProvider>(context, listen: false)
          .incomeCategoryList
          .map((e) => e.name.trim().toLowerCase())
          .toList();
      if (income.contains(Provider.of<CategoryProvider>(context, listen: false)
          .categoryNameController
          .text
          .trim()
          .toLowerCase())) {
        return 'Category already exists';
      }
    }
    if (selectedCategoryType == CategoryType.expense) {
      final expense = Provider.of<CategoryProvider>(context, listen: false)
          .expenseCategoryList
          .map((e) => e.name.trim().toLowerCase())
          .toList();
      if (expense.contains(Provider.of<CategoryProvider>(context, listen: false)
          .categoryNameController
          .text
          .trim()
          .toLowerCase())) {
        return 'Category already exists';
      }
    }
    return null;
  }

  Future<void> addTransaction(TransactionModel transactionModal) async {
    await TransactionDb.instence.addTransaction(transactionModal);
  }

  Future<void> updateTransaction(TransactionModel value, String id) async {
    await TransactionDb.instence.updateList(id, value);
    await transactionRefresh();
    notifyListeners();
  }

  void show(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      elevation: 20,
      content: Text(text),
      backgroundColor: Colors.green,
    ));
    notifyListeners();
  }

  void submitCategory(context) {
    if (formKey.currentState!.validate()) {
      final categoryName = Provider.of<CategoryProvider>(context, listen: false)
          .categoryNameController
          .text
          .trim();
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
      categoryClear(context);
      Provider.of<HomeScreenProvider>(context, listen: false)
          .navigatorPop(context);
      Provider.of<CategoryProvider>(context, listen: false).refreshUI();
    }
    notifyListeners();
  }

  String? validator(value, String? text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  void navigatorToBottom(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreenBottomNavbar(),
        ),
        (route) => false);
    notifyListeners();
  }

  void addOrEdit(TransactionModel? modal, ActionType? type) {
    if (type == ActionType.editscreen) {
      dateController.text = DateFormat('yMMMMd').format(modal!.date);
      amountController.text = modal.amount.toString();
      selectedCategoryType = modal.type;
    } else {
      selectedCategoryType = CategoryType.income;
      dateController.clear();
      amountController.clear();
      transactionRefresh();
    }
    notifyListeners();
  }
}
