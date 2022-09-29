import 'package:flutter/material.dart';
import 'package:moneywallet/screen/category/view/widget/add_category.dart';
import '../../../../DB/functions/category/category_db.dart';
import '../../model/category_modal.dart';
import '../../model/category_typemodel.dart';

class CategoryProvider with ChangeNotifier {
  TextEditingController categoryNameController = TextEditingController();
  late TabController tabController;
  final formKey = GlobalKey<FormState>();

  List<CategoryModel> incomeCategoryList = [];
  List<CategoryModel> expenseCategoryList = [];

  List<CategoryModel> allCategoryList = [];

  Future<void> refreshUI() async {
    final allCategories = await CategoryDb.instence.refreshUI();
    incomeCategoryList.clear();
    expenseCategoryList.clear();
    await Future.forEach(
      allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.add(category);
          allCategoryList.add(category);
        } else {
          expenseCategoryList.add(category);
          allCategoryList.add(category);
        }
      },
    );
    notifyListeners();
  }

  void deleteCategory(index) async {
    await CategoryDb.instence.deleteCategory(index);
    notifyListeners();
  }

  void insertCategory(CategoryModel value) async {
    await CategoryDb.instence.insertCategory(value);
    notifyListeners();
  }

  String? validateCategory(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter category name';
    }

    if (tabController.index == 0) {
      final income =
          incomeCategoryList.map((e) => e.name.trim().toLowerCase()).toList();
      if (income.contains(
        categoryNameController.text.trim().toLowerCase(),
      )) {
        return 'Category already exists';
      }
    }
    if (tabController.index == 1) {
      final expense =
          expenseCategoryList.map((e) => e.name.trim().toLowerCase()).toList();
      if (expense.contains(categoryNameController.text.trim().toLowerCase())) {
        return 'Category already exists';
      }
    }
    notifyListeners();
    return null;
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

  void addCategory(context) {
    if (formKey.currentState!.validate()) {
      final categoryName = categoryNameController.text.trim();
      if (categoryName.isEmpty) {
        return;
      }
      final category = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: categoryName,
        type: tabController.index == 0
            ? CategoryType.income
            : CategoryType.expense,
      );
      insertCategory(category);

      categoryNameController.clear();
      refreshUI();
      show(context, 'successfully added to categorylist');
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  void categorySubmit(context) {
    AddCategoryFunction.addcategory(context, formKey, tabController,
        incomeCategoryList, categoryNameController, expenseCategoryList);
    notifyListeners();
  }
}
