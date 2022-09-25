import 'package:flutter/material.dart';
import 'package:moneywallet/screen/statistics/widgets/statistics_const.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../transaction/controller/provider/transaction_provider.dart';

class ScreenOverviewStatistics extends StatelessWidget {
  const ScreenOverviewStatistics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TransactionProvider>(context, listen: false);
    data.transactionRefresh();
    Map<String, double> statistics = {
      "Income": data.totalIncome.toDouble(),
      "Expense": data.totalExpense.toDouble(),
      "Total Balance": data.totalBalence.toDouble(),
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5.h,
        ),
        PieChart(
          legendOptions: const LegendOptions(
              legendShape: BoxShape.rectangle,
              legendPosition: LegendPosition.bottom,
              showLegendsInRow: true),
          chartRadius: 200.sp,
          dataMap: statistics,
          chartType: ChartType.disc,
          chartValuesOptions: const ChartValuesOptions(
              showChartValuesOutside: true,
              showChartValuesInPercentage: true,
              showChartValueBackground: false),
          colorList: StatisticsCost.colorList,
        ),
      ],
    );
  }
}
