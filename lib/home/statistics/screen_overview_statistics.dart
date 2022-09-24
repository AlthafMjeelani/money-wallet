import 'package:flutter/material.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../transaction/controller/provider/transaction_provider.dart';

// ignore: must_be_immutable
class ScreenOverviewStatistics extends StatefulWidget {
  const ScreenOverviewStatistics({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenOverviewStatistics> createState() =>
      _ScreenOverviewStatisticsState();
}

class _ScreenOverviewStatisticsState extends State<ScreenOverviewStatistics> {
  final colorList = <Color>[
    const Color.fromRGBO(116, 180, 155, 1),
    const Color.fromRGBO(246, 114, 128, 1),
    const Color.fromRGBO(75, 135, 185, 1),
  ];

  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> statistics = {
      "Income": Provider.of<TransactionProvider>(context, listen: false)
          .totalIncome
          .toDouble(),
      "Expense": Provider.of<TransactionProvider>(context, listen: false)
          .totalExpense
          .toDouble(),
      "Total Balance": Provider.of<TransactionProvider>(context, listen: false)
          .totalBalence
          .toDouble(),
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
          colorList: colorList,
        ),
      ],
    );
  }
}
