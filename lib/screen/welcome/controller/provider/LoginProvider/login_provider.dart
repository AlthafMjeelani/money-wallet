import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Homescreen/view/screen_bottomvavigation.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final String text;

  Future<void> getName() async {
    final SharedPreferences name = await SharedPreferences.getInstance();
    name.setString('enterName', nameController.text);
  }

  void validateName(context) {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ScreenBottomNavbar(),
        ),
      );
      nameController.clear();
      notifyListeners();
    }
  }

  String? checkValidate(String? value) {
    log(value.toString());
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    } else if (value.startsWith(
      RegExp(r'[0-9]'),
    )) {
      log(value.toString());
      return "name can't start with numbers";
    } else if (value.startsWith(
      RegExp(
        r'[ !@#$%^&*(),.?":{}|<>]',
      ),
    )) {
      return "name can't start with special cheracters";
    }
    return null;
  }
}
