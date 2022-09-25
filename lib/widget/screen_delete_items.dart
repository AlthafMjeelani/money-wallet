import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/category/controller/provider/category_provider.dart';
import '../screen/category/model/category_modal.dart';

class DeleteCategory {
  Future<void> deleteItem(
      index, CategoryModel modal, BuildContext context) async {
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
                Provider.of<CategoryProvider>(context, listen: false)
                    .deleteCategory(index.toString());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 20,
                  content: Text(
                    'successfully deleted to category',
                  ),
                  backgroundColor: Colors.green,
                ));
                Provider.of<CategoryProvider>(context, listen: false)
                    .refreshUI();

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
