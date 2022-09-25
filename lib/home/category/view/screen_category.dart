import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moneywallet/home/category/controller/provider/category_provider.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:moneywallet/widget/tabbar_widget.dart';
import 'package:provider/provider.dart';
import 'expense_categorylist_widget.dart';
import 'income_categorylist_widget.dart';

class ScreenCategory extends StatelessWidget {
  const ScreenCategory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('build called');
    final data = Provider.of<CategoryProvider>(context, listen: false);
    data.refreshUI();
    data.tabController = TabController(length: 2, vsync: Scaffold.of(context));
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            data.addcategory(
              context,
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TabbarWidget(
                tabController: data.tabController,
                tabs: const [
                  Tab(
                    text: 'Income',
                  ),
                  Tab(
                    text: 'Expense',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: TabBarView(
                    controller: data.tabController,
                    children: const [
                      IncomeCategoryList(),
                      ExpenseCategoryList(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
