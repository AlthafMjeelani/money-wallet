import 'package:flutter/material.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';

import '../home/category/model/category_modal.dart';

class DeleteCategory {
  Future<void> deleteItem(
      int index, CategoryModel modal, BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly delete your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                CategoryDb.instence.deleteCategory(modal.id);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 20,
                  content: Text(
                    'successfully deleted to category',
                  ),
                  backgroundColor: Colors.green,
                ));

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
