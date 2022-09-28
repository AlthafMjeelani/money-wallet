import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:moneywallet/screen/settings/widgets/screen_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../fonts/reminder/reminder_local_notification.dart';
import '../../../category/model/category_modal.dart';
import '../../../transaction/model/transaction_modal.dart';
import '../../../welcome/view/screen_splash.dart';

class SettingsProvider with ChangeNotifier {
  final Uri url = Uri.parse('mailto:althafjeelani159@gmail.com');
  final Uri urlcall = Uri.parse('tel:+91-8086689184');
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
      Support.addReminder(context);
    } else {
      NotificationApi.cancelNotification();
      final share = await SharedPreferences.getInstance();
      share.remove('switch');
    }
    notifyListeners();
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

  Future<void> launchCall() async {
    try {
      await launchUrl(urlcall);
    } catch (e) {
      log(
        e.toString(),
      );
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
    notifyListeners();
  }

  void navigatorSettings(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const ScreenSplash()),
        (route) => false);
    notifyListeners();
  }

  void reminderClear() {
    getBool();
    isSwitched = false;
    timePicker.clear();
    labalText.clear();
    notifyListeners();
  }

  String? validation(value, text) {
    if (value == null || value.isEmpty) {
      return text;
    }
    return null;
  }

  void remiderSubmit(context) async {
    if (formKey.currentState!.validate()) {
      final sharefprefs = await SharedPreferences.getInstance();
      sharefprefs.setBool('switch', true);

      NotificationApi().showScheduledNotification(
        title: 'Notification',
        body: labalText.text,
        payload: '',
        sheduleddatetime: pickedTime,
      );

      timePicker.clear();
      labalText.clear();

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        elevation: 20,
        content: Text(
          'successfully added to reminder',
        ),
        backgroundColor: Colors.green,
      ));
    }
    notifyListeners();
  }
}
