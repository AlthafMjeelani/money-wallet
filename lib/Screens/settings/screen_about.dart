import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri urlcall = Uri.parse('tel:+91-8086689184');

class About {
  Future<void> aboutApp(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('About App'),
          actions: [
            ListTile(
              leading: Image.asset('lib/assets/images/app logo.png'),
              title: const Text('Money Wallet'),
              subtitle: const Text('v.1.0.1'),
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
                  launchCall();
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

  Future<void> launchCall() async {
    try {
      await launchUrl(urlcall);
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }
}
