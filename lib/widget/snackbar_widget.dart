import 'package:flutter/material.dart';

class SnackBarWidget {
  void show(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      elevation: 20,
      content: Text(text),
      backgroundColor: Colors.green,
    ));
  }
}
