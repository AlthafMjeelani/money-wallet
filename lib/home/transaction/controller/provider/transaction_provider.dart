import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../DB/functions/category/category_db.dart';
import '../../../category/model/category_modal.dart';
import '../../../category/model/category_typemodel.dart';
import '../../../category/view/screen_category.dart';

class TransactionProvider with ChangeNotifier {
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
}
