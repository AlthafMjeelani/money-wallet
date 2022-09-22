import 'package:hive_flutter/adapters.dart';

import '../../category/model/category_modal.dart';
import '../../category/model/category_typemodel.dart';
part 'transaction_modal.g.dart';

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  double amount;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  CategoryType type;
  @HiveField(3)
  CategoryModel category;
  @HiveField(4)
  String? id;
  TransactionModel(
      {required this.amount,
      required this.date,
      required this.type,
      required this.category}) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }

  updateTransaction(TransactionModel update) {
    amount = update.amount;
    date = update.date;
    type = update.type;
    category = update.category;
    save();
  }
}
