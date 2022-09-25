import 'package:flutter/material.dart';
import 'package:moneywallet/screen/Homescreen/view/screen_bottomvavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../view/screen_login.dart';

class WelcomeProvidfer with ChangeNotifier {
  Future<void> gotoHome(context) async {
    await Future.delayed(
      const Duration(seconds: 5),
    );
    final SharedPreferences userName = await SharedPreferences.getInstance();
    final name = userName.getString('enterName');
    if (name == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const ScreenLogin(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ScreenBottomNavbar(),
        ),
      );
    }
  }
}
