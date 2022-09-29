import 'package:flutter/material.dart';
import 'package:moneywallet/screen/statistics/controller/statistics_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../transaction/controller/provider/transaction_provider.dart';
import 'widgets/sorted_statistics_items.dart';

class ScreenExpenseStatistics extends StatelessWidget {
  const ScreenExpenseStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statistcsProvider =
        Provider.of<StatisticsProvider>(context, listen: false);
    final values = Provider.of<TransactionProvider>(context, listen: false);
    return SfCircularChart(
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        PieSeries<ChartedData, String>(
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          dataSource:
              statistcsProvider.chartedCategory(values.expenseTransaction),
          xValueMapper: (ChartedData data, _) => data.categoryName,
          yValueMapper: (ChartedData data, _) => data.amount,
          explode: true,
          legendIconType: LegendIconType.diamond,
        ),
      ],
    );
  }
}
