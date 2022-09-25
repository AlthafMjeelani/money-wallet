import 'package:flutter/material.dart';
import 'package:moneywallet/home/category/controller/provider/category_provider.dart';
import 'package:moneywallet/home/statistics/view/screen_expense_statistics.dart';
import 'package:moneywallet/home/statistics/view/screen_income_statistics.dart';
import 'package:moneywallet/home/statistics/view/screen_overview_statistics.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:moneywallet/widget/tabbar_widget.dart';
import 'package:provider/provider.dart';
import '../../transaction/controller/provider/transaction_provider.dart';
import '../widgets/screen_nodatafound.dart';

class ScreenStatistics extends StatelessWidget {
  const ScreenStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataT = Provider.of<TransactionProvider>(context, listen: false);
    final dataC = Provider.of<CategoryProvider>(context, listen: false);
    final tabController = TabController(length: 3, vsync: Scaffold.of(context));
    dataT.transactionRefresh();
    dataC.refreshUI();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TabbarWidget(
              tabController: tabController,
              tabs: const [
                Tab(text: 'Income'),
                Tab(text: 'Expense'),
                Tab(text: 'OverView'),
              ],
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Provider.of<TransactionProvider>(context, listen: false)
                            .incomeTransaction
                            .isNotEmpty
                        ? const ScreenIncomeStatistics()
                        : const NoDataFound(
                            text: 'No Transactions',
                          ),
                    Provider.of<TransactionProvider>(context, listen: false)
                            .expenseTransaction
                            .isNotEmpty
                        ? const ScreenExpenseStatistics()
                        : const NoDataFound(
                            text: 'No Transactions',
                          ),
                    Provider.of<TransactionProvider>(context, listen: false)
                            .allTransactionList
                            .isNotEmpty
                        ? const ScreenOverviewStatistics()
                        : const NoDataFound(
                            text: 'No Transactions',
                          ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
