import 'package:hive_flutter/adapters.dart';

import 'category_typemodel.dart';
part 'category_modal.g.dart';

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isdeleted;
  @HiveField(3)
  final CategoryType type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.isdeleted = false,
  });
}
