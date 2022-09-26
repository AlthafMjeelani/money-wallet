import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../transaction/controller/provider/transaction_provider.dart';
import '../../transaction/controller/provider/view_transaction_provider.dart';
import '../widgets/sorted_statistics_items.dart';

class ScreenIncomeStatistics extends StatelessWidget {
  const ScreenIncomeStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ViewTransactionProvider>(context, listen: false);
    final values = Provider.of<TransactionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      values.transactionRefresh();
      data.dropdownvalueCategory;
    });
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
