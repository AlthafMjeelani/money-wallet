import '../transaction/model/transaction_modal.dart';

class ChartedData {
  final num amount;
  final String categoryName;

  ChartedData(this.amount, this.categoryName);
}

chartedCategory(List<TransactionModel> list) {
  int value;
  String categoryname;
  List visited = [];
  List<ChartedData> finalList = [];

  for (var i = 0; i < list.length; i++) {
    visited.add(0);
  }

  for (var i = 0; i < list.length; i++) {
    value = list[i].amount.toInt();
    categoryname = list[i].category.name;
    for (var j = i + 1; j < list.length; j++) {
      if (categoryname == list[j].category.name) {
        value += list[j].amount.toInt();
        visited[j] = -1;
      }
    }

    if (visited[i] != -1) {
      finalList.add(ChartedData(value, categoryname));
    }
  }
  return finalList;
}
