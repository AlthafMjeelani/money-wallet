import 'package:hive_flutter/hive_flutter.dart';
import '../../../home/category/model/category_modal.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'CATEGORY-DB';

class CategoryDb {
  CategoryDb._internal();
  static CategoryDb instence = CategoryDb._internal();
  factory CategoryDb() {
    return instence;
  }
  List<CategoryModel> allCategoryList = [];
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.put(value.id, value);
    refreshUI();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> deleteCategory(index) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(index);
    await refreshUI();
  }

  Future<List<CategoryModel>> refreshUI() async {
    final allCategory = await getAllCategories();
    allCategoryList.addAll(allCategory);
    return allCategory;
  }
}
