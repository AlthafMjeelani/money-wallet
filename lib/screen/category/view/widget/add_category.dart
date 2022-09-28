import 'package:flutter/material.dart';
import 'package:moneywallet/screen/Homescreen/controller/provider/home_screen_provider.dart';
import 'package:moneywallet/screen/category/controller/provider/category_provider.dart';
import 'package:provider/provider.dart';

class AddCategoryFunction {
  static Future<void> addcategory(BuildContext context, formKey, tabController,
      incomeCategoryList, categoryNameController, expenseCategoryList) async {
    final data = Provider.of<CategoryProvider>(context, listen: false);
    final pop = Provider.of<HomeScreenProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(10),
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                maxLength: 12,
                validator: (value) => data.validateCategory(value),
                controller: categoryNameController,
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
                    pop.navigatorPop(context);

                    categoryNameController.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    data.addCategory(context);
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
