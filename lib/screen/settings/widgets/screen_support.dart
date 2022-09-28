import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../fonts/reminder/reminder_local_notification.dart';
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

  static Future<void> addReminder(context) async {
    final data = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Form(
          key: data.formKey,
          child: SimpleDialog(
            contentPadding: const EdgeInsets.all(10),
            children: [
              TextFormField(
                  validator: (value) => data.validation(value, 'select Time'),
                  controller: data.timePicker,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer), labelText: "select Time"),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickTime = await showTimePicker(
                      context: context,
                      initialTime: data.dateTime,
                    );

                    if (pickTime != null) {
                      String formattedDate = pickTime.format(context);

                      data.timePicker.text = formattedDate;

                      data.pickedTime = Time(
                        pickTime.hour,
                        pickTime.minute,
                        0,
                      );

                      data.dateTime = pickTime;
                    }
                  }),
              TextFormField(
                validator: (value) => data.validation(value, 'Enter Some Text'),
                controller: data.labalText,
                decoration: const InputDecoration(
                  icon: Icon(Icons.edit),
                  labelText: "add Text",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        data.reminderClear();
                      },
                      child: const Text('CANCEL'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => data.remiderSubmit(context),
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
}
