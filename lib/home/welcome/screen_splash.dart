import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:moneywallet/home/welcome/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Homescreen/screen_bottomvavigation.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    gotoHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/images/2gif.gif',
                    width: 150,
                    height: 150,
                  ),
                  AnimatedTextKit(animatedTexts: [
                    ColorizeAnimatedText(
                      'Money Wallet',
                      textStyle: const TextStyle(
                        fontSize: 30,
                      ),
                      colors: [
                        Colors.black,
                        Colors.white,
                      ],
                      speed: const Duration(
                        milliseconds: 20,
                      ),
                    ),
                  ], isRepeatingAnimation: true)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future gotoHome() async {
    await Future.delayed(const Duration(seconds: 5));
    final SharedPreferences userName = await SharedPreferences.getInstance();
    final name = userName.getString('enterName');
    if (name == null) {
      if (!mounted) {}
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => ScreenLogin(),
        ),
      );
    } else {
      if (!mounted) {}
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const ScreenBottomNavbar(),
        ),
      );
    }
  }
}
