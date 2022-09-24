import 'package:flutter/material.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/statistics/sorted_statistics_items.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../transaction/controller/provider/transaction_provider.dart';
import '../transaction/controller/provider/view_transaction_provider.dart';
import '../transaction/model/transaction_modal.dart';
import '../transaction/view/screen_view_transaction.dart';

class ScreenIncomeStatistics extends StatefulWidget {
  const ScreenIncomeStatistics({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenIncomeStatistics> createState() => _ScreenIncomeStatisticsState();
}

class _ScreenIncomeStatisticsState extends State<ScreenIncomeStatistics> {
  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<TransactionModel> values =
        Provider.of<TransactionProvider>(context, listen: false)
            .incomeTransaction;
    final data = Provider.of<ViewTransactionProvider>(context, listen: false);
    data.dropdownvalueCategory;
    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartedData, String>(
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataSource: chartedCategory(
              Provider.of<TransactionProvider>(context, listen: false)
                  .incomeTransaction),
          xValueMapper: (ChartedData data, _) => data.categoryName,
          yValueMapper: (ChartedData data, _) => data.amount,
          explode: true,
          legendIconType: LegendIconType.diamond,
        ),
      ],
    );
  }
}
