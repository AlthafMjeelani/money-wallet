import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:moneywallet/screen/Homescreen/controller/provider/bottom_navbar_provider.dart';
import 'package:moneywallet/screen/Homescreen/controller/support/list_of_pages.dart';
import 'package:moneywallet/screen/category/controller/provider/category_provider.dart';
import 'package:moneywallet/screen/transaction/controller/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class ScreenBottomNavbar extends StatelessWidget {
  const ScreenBottomNavbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('build called');
    final transactionData =
        Provider.of<TransactionProvider>(context, listen: false);
    final categoryData = Provider.of<CategoryProvider>(context, listen: false);
    transactionData.transactionRefresh();
    categoryData.refreshUI();
    return Consumer<BottomNavbarProvider>(
      builder:
          (BuildContext context, BottomNavbarProvider value, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            await value.bottomNavbar();
            return true;
          },
          child: Scaffold(
            body: HomeScreenSupport.screens[value.currentPageIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: const Color.fromARGB(255, 12, 133, 255),
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              currentIndex: value.currentPageIndex,
              onTap: (newIndex) {
                value.bottomShift(newIndex);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category,
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.query_stats,
                  ),
                  label: 'Statistics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
