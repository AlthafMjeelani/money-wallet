import 'package:flutter/material.dart';
import 'package:moneywallet/Screens/Homescreen/screen_home.dart';
import 'package:moneywallet/Screens/category/screen_category.dart';
import 'package:moneywallet/Screens/settings/screen_settings.dart';
import 'package:moneywallet/Screens/statistics/screen_satistics.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';

import '../../db/functions/category/category_db.dart';

class ScreenBottomNavbar extends StatefulWidget {
  const ScreenBottomNavbar({Key? key}) : super(key: key);

  @override
  State<ScreenBottomNavbar> createState() => _ScreenBottomNavbarState();
}

class _ScreenBottomNavbarState extends State<ScreenBottomNavbar> {
  int currentPageIndex = 0;

  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    CategoryDb.instence.refreshUI();

    super.initState();
  }

  List screens = [
    const ScreenHome(),
    const ScreenCategory(),
    const ScreenStatistics(),
    const ScreenSettings()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex != 0) {
          setState(() {
            currentPageIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: screens[currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromARGB(255, 12, 133, 255),
            unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            currentIndex: currentPageIndex,
            onTap: (newIndex) {
              setState(() {
                currentPageIndex = newIndex;
              });
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
            ]),
      ),
    );
  }
}
