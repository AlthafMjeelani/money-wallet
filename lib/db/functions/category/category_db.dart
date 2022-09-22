import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../home/category/model/category_modal.dart';
import '../../../home/category/model/category_typemodel.dart';


// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'CATEGORY-DB';

class CategoryDb {
  CategoryDb._internal();
  static CategoryDb instence = CategoryDb._internal();
  factory CategoryDb() {
    return instence;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);

  ValueNotifier<List<CategoryModel>> allCategoryList = ValueNotifier([]);

  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.put(value.id, value);
    refreshUI();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> deleteCategory(String index) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(index);
    await refreshUI();
  }

  Future<void> refreshUI() async {
    final allCategories = await getAllCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    await Future.forEach(
      allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.value.add(category);
          allCategoryList.value.add(category);
        } else {
          expenseCategoryList.value.add(category);
          allCategoryList.value.add(category);
        }
      },
    );
    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
    allCategoryList.notifyListeners();
  }
}
