import 'package:flutter/material.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/statistics/sorted_statistics_items.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenExpenseStatistics extends StatelessWidget {
  const ScreenExpenseStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartedData, String>(
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataSource:
              chartedCategory(TransactionDb.instence.expenseTransaction),
          xValueMapper: (ChartedData data, _) => data.categoryName,
          yValueMapper: (ChartedData data, _) => data.amount,
          explode: true,
          legendIconType: LegendIconType.diamond,
        ),
      ],
    );
  }
}
