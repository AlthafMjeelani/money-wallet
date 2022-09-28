import 'package:flutter/material.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/screen/Homescreen/controller/provider/home_screen_provider.dart';
import 'package:moneywallet/screen/category/controller/provider/category_provider.dart';
import 'package:moneywallet/screen/transaction/controller/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddTranCategoryFunction {
  static Future<void> addcategory(BuildContext context) async {
    final data = Provider.of<TransactionProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(10),
          children: [
            Form(
              key: data.formKey,
              child: TextFormField(
                maxLength: 12,
                validator: (value) => data.addCategory(value, context),
                controller:
                    Provider.of<CategoryProvider>(context, listen: false)
                        .categoryNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                  labelText: 'Enter category name',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Provider.of<HomeScreenProvider>(context, listen: false)
                        .navigatorPop(context);
                    data.categoryClear(context);
                  },
                  child: const Text('CANCEL'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    data.submitCategory(context);
                    data.show(context, 'successfully added to categorylist');
                  },
                  child: const Text('ADD'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
