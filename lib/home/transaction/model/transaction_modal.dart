import 'package:hive_flutter/adapters.dart';

import '../../category/model/category_modal.dart';
import '../../category/model/category_typemodel.dart';
part 'transaction_modal.g.dart';

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final double amount;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final CategoryType type;
  @HiveField(3)
  final CategoryModel category;
  @HiveField(4)
  late final String id;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.id,
  });
}
