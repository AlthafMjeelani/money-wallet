import 'package:flutter/material.dart';
import 'package:moneywallet/home/category/controller/provider/category_provider.dart';
import 'package:moneywallet/widget/screen_delete_items.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../statistics/screen_nodatafound.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, CategoryProvider newList, Widget? _) {
      if (newList.expenseCategoryList.isEmpty) {
        return const NoDataFound(
          text: 'No Categories',
        );
      } else {
        return GridView.count(
          crossAxisCount: 2,
          childAspectRatio: (1.2 / .4),
          shrinkWrap: true,
          children: List.generate(newList.expenseCategoryList.length, (index) {
            final category = newList.expenseCategoryList[index];
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
                      DeleteCategory()
                          .deleteItem(category.id, category, context);
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
