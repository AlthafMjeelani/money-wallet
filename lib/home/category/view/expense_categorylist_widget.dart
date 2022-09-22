import 'package:flutter/material.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/widget/screen_delete_items.dart';
import 'package:sizer/sizer.dart';

import '../../statistics/screen_nodatafound.dart';
import '../model/category_modal.dart';

class ExpenseCategoryList extends StatefulWidget {
  const ExpenseCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseCategoryList> createState() => _ExpenseCategoryListState();
}

class _ExpenseCategoryListState extends State<ExpenseCategoryList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDb().expenseCategoryList,
        builder:
            (BuildContext context, List<CategoryModel> newList, Widget? _) {
          if (newList.isEmpty) {
            return const NoDataFound(
              text: 'No Categories',
            );
          } else {
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (1.2 / .4),
              shrinkWrap: true,
              children: List.generate(newList.length, (index) {
                final category = newList[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor: const Color.fromARGB(255, 208, 113, 113),
                      leading: Text(
                        category.name,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          DeleteCategory().deleteItem(index, category, context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }
        });
  }
}