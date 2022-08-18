import 'package:flutter/material.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/models/categorytypemodal/category_modal.dart';

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
