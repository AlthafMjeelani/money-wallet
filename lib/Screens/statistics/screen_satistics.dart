import 'package:flutter/material.dart';
import 'package:moneywallet/Screens/statistics/screen_expense_statistics.dart';
import 'package:moneywallet/Screens/statistics/screen_income_statistics.dart';
import 'package:moneywallet/Screens/statistics/screen_nodatafound.dart';
import 'package:moneywallet/Screens/statistics/screen_overview_statistics.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:moneywallet/widget/tabbar_widget.dart';

class ScreenStatistics extends StatefulWidget {
  const ScreenStatistics({Key? key}) : super(key: key);

  @override
  State<ScreenStatistics> createState() => _ScreenStatisticsState();
}

class _ScreenStatisticsState extends State<ScreenStatistics>
    with TickerProviderStateMixin {
  String? category;
  late String dropdownvalueDay;
  late String dropdownvalueCategory;
  late TabController tabController;

  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    CategoryDb.instence.refreshUI();
    tabController = TabController(length: 3, vsync: this);
    dropdownvalueCategory = 'All';
    dropdownvalueDay = 'All';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    TransactionDb
                            .instence.incomeTransactionNotifire.value.isNotEmpty
                        ? const ScreenIncomeStatistics()
                        : const NoDataFound(
                            text: 'No Transactions',
                          ),
                    TransactionDb.instence.expenseTransactionNotifire.value
                            .isNotEmpty
                        ? const ScreenExpenseStatistics()
                        : const NoDataFound(
                            text: 'No Transactions',
                          ),
                    TransactionDb
                            .instence.transactionListNotifire.value.isNotEmpty
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
