import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneywallet/Screens/reminder/reminder_local_notification.dart';
import 'package:moneywallet/Screens/settings/screen_about.dart';
import 'package:moneywallet/Screens/welcome/screen_splash.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:moneywallet/models/categorytypemodal/category_modal.dart';
import 'package:moneywallet/models/transactionmodal/transaction_modal.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool isSwitched = false;
final Uri url = Uri.parse('mailto:althafjeelani159@gmail.com');

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

late Time pickedTime;
final _formKey = GlobalKey<FormState>();
TextEditingController timePicker = TextEditingController();
TextEditingController labalText = TextEditingController();

class _ScreenSettingsState extends State<ScreenSettings> {
  TimeOfDay dateTime = TimeOfDay.now();

  @override
  void initState() {
    NotificationApi.init(initSheduled: true);
    getBool();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w, bottom: 5.h),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                addReminder();
              },
              leading: const Icon(Icons.alarm_rounded),
              title: const Text('Reminder'),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) async {
                  setState(() {
                    isSwitched = value;
                  });
                  if (isSwitched == true) {
                    addReminder();
                  } else {
                    NotificationApi.cancelNotification();
                    final share = await SharedPreferences.getInstance();
                    share.remove('switch');
                    setState(() {});
                  }
                },
                inactiveThumbColor: const Color.fromARGB(255, 6, 78, 137),
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
                launchEmail();
              }),
            ),
            ListTile(
              onTap: () {
                About().aboutApp(context);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: const Text('Reset app'),
              onTap: () {
                resetApp();
              },
            ),
            const Spacer(),
            const Center(
              child: Text('v.1.0.1'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> addReminder() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Form(
            key: _formKey,
            child: SimpleDialog(
              contentPadding: const EdgeInsets.all(10),
              children: [
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'select time';
                      }
                      return null;
                    },
                    controller: timePicker,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.timer), labelText: "select Time"),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickTime = await showTimePicker(
                          context: context, initialTime: dateTime);

                      if (pickTime != null) {
                        if (!mounted) {}
                        String formattedDate = pickTime.format(context);
                        setState(() {
                          timePicker.text = formattedDate;

                          pickedTime = Time(
                            pickTime.hour,
                            pickTime.minute,
                            0,
                          );

                          dateTime = pickTime;
                        });
                      }
                    }),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter some text';
                    }
                    return null;
                  },
                  controller: labalText,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.edit), labelText: "add Text"),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            isSwitched = false;
                            timePicker.clear();
                            labalText.clear();
                          });
                        },
                        child: const Text('CANCEL'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final sharefprefs =
                                await SharedPreferences.getInstance();
                            sharefprefs.setBool('switch', true);
                            setState(() {
                              NotificationApi().showScheduledNotification(
                                title: 'Notification',
                                body: 'hy.${labalText.text}',
                                payload: '',
                                sheduleddatetime: pickedTime,
                              );

                              timePicker.clear();
                              labalText.clear();
                            });
                            if (!mounted) {}
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              elevation: 20,
                              content: Text(
                                'successfully added to reminder',
                              ),
                              backgroundColor: Colors.green,
                            ));
                          }
                        },
                        child: const Text('SAVE'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> launchEmail() async {
    try {
      await launchUrl(url);
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  Future getBool() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    final value = sharedprefs.getBool('switch');
    if (value != null) {
      setState(() {
        isSwitched = value;
      });
    } else {
      isSwitched = false;
    }
  }

  Future<void> resetALLData() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.clear();
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionDB.clear();
    final prefer = await SharedPreferences.getInstance();
    await prefer.clear();
  }

  Future<void> resetApp() async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly reset your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                resetALLData();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const ScreenSplash()),
                    (route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
