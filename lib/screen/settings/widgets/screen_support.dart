import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Homescreen/controller/provider/home_screen_provider.dart';
import '../controller/provider/settings_provider.dart';

class Support {
  Future<void> aboutApp(BuildContext context) async {
    final data = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('About App'),
          actions: [
            ListTile(
              leading: Image.asset('lib/assets/images/app logo.png'),
              title: const Text('Money Wallet'),
              subtitle: const Text('v.1.0.2'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text('developed by ALTHAF M'),
            ),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  data.launchCall();
                },
                label: const Text('Contact: +91-8086689184'),
                icon: const Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> resetApp(context) async {
    final data = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly reset your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<HomeScreenProvider>(context, listen: false)
                    .navigatorPop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                data.resetALLData();
                data.navigatorSettings(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
