import 'package:flutter/material.dart';
import 'package:moneywallet/Screens/statistics/sorted_statistics_items.dart';
import 'package:moneywallet/Screens/transaction/screen_view_transaction.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:moneywallet/models/transactionmodal/transaction_modal.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenIncomeStatistics extends StatefulWidget {
  const ScreenIncomeStatistics({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenIncomeStatistics> createState() => _ScreenIncomeStatisticsState();
}

class _ScreenIncomeStatisticsState extends State<ScreenIncomeStatistics> {
  final List<TransactionModel> values =
      TransactionDb.instence.incomeTransactionNotifire.value;
  @override
  void initState() {
    dropdownvalueCategory = 'All';

    TransactionDb.instence.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartedData, String>(
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataSource: chartedCategory(
              TransactionDb.instence.incomeTransactionNotifire.value),
          xValueMapper: (ChartedData data, _) => data.categoryName,
          yValueMapper: (ChartedData data, _) => data.amount,
          explode: true,
          legendIconType: LegendIconType.diamond,
        ),
      ],
    );
  }
}
