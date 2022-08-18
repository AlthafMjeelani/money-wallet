import 'package:hive_flutter/hive_flutter.dart';
part 'category_typemodel.g.dart';

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}
