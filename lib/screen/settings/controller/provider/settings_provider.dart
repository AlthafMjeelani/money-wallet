import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../fonts/reminder/reminder_local_notification.dart';
import '../../../category/model/category_modal.dart';
import '../../../transaction/model/transaction_modal.dart';
import '../../../welcome/view/screen_splash.dart';

class SettingsProvider with ChangeNotifier {
  final Uri url = Uri.parse('mailto:althafjeelani159@gmail.com');
  late Time pickedTime;
  final formKey = GlobalKey<FormState>();
  TextEditingController timePicker = TextEditingController();
  TextEditingController labalText = TextEditingController();
  bool isSwitched = false;
  TimeOfDay dateTime = TimeOfDay.now();

  Future getBool() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    final value = sharedprefs.getBool('switch');
    if (value != null) {
      isSwitched = value;
    } else {
      isSwitched = false;
    }
    notifyListeners();
  }

  void switchWork(value, context) async {
    isSwitched = value;
    if (isSwitched == true) {
      addReminder(context);
    } else {
      NotificationApi.cancelNotification();
      final share = await SharedPreferences.getInstance();
      share.remove('switch');
    }
    notifyListeners();
  }

  Future<void> addReminder(context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Form(
          key: formKey,
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
                      String formattedDate = pickTime.format(context);

                      timePicker.text = formattedDate;

                      pickedTime = Time(
                        pickTime.hour,
                        pickTime.minute,
                        0,
                      );

                      dateTime = pickTime;
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

                        isSwitched = false;
                        timePicker.clear();
                        labalText.clear();
                      },
                      child: const Text('CANCEL'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final sharefprefs =
                              await SharedPreferences.getInstance();
                          sharefprefs.setBool('switch', true);

                          NotificationApi().showScheduledNotification(
                            title: 'Notification',
                            body: 'hy.${labalText.text}',
                            payload: '',
                            sheduleddatetime: pickedTime,
                          );

                          timePicker.clear();
                          labalText.clear();

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
      },
    );
  }

  Future<void> launchEmail() async {
    try {
      await launchUrl(url);
    } catch (e) {
      log(
        e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> resetALLData() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.clear();
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionDB.clear();
    final prefer = await SharedPreferences.getInstance();
    await prefer.clear();
    notifyListeners();
  }

  void navigatorSettings(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const ScreenSplash()),
        (route) => false);
    notifyListeners();
  }
}
