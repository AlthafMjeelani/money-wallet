import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:moneywallet/fonts/reminder/reminder_local_notification.dart';
import 'package:moneywallet/screen/settings/controller/provider/settings_provider.dart';
import 'package:moneywallet/screen/settings/widgets/screen_support.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:share/share.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('build called');
    final data = Provider.of<SettingsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data.getBool();
      NotificationApi.init(initSheduled: true);
    });
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w, bottom: 5.h),
        child: Column(
          children: [
            ListTile(
              onTap: () => data.addReminder(context),
              leading: const Icon(Icons.alarm_rounded),
              title: const Text('Reminder'),
              trailing: Consumer(
                builder: (BuildContext context, SettingsProvider switchdata,
                    Widget? child) {
                  return Switch(
                    value: switchdata.isSwitched,
                    onChanged: (value) => switchdata.switchWork(value, context),
                    inactiveThumbColor: const Color.fromARGB(255, 6, 78, 137),
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Invite a friend'),
              onTap: () {
                Share.share(
                    'Money Wallet\n, https://play.google.com/store/apps/details?id=in.althaf.money_wallet');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_rounded),
              title: const Text('Feedback'),
              onTap: (() {
                data.launchEmail();
              }),
            ),
            ListTile(
              onTap: () {
                Support().aboutApp(context);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: const Text('Reset app'),
              onTap: () {
                Support().resetApp(context);
              },
            ),
            const Spacer(),
            const Center(
              child: Text('v.1.0.2'),
            ),
          ],
        ),
      )),
    );
  }
}
