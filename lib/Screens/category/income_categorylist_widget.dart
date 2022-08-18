import 'package:flutter/material.dart';
import 'package:moneywallet/Screens/statistics/screen_nodatafound.dart';
import 'package:moneywallet/widget/screen_delete_items.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/models/categorytypemodal/category_modal.dart';
import 'package:sizer/sizer.dart';

class IncomeCategoryList extends StatefulWidget {
  const IncomeCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  State<IncomeCategoryList> createState() => _IncomeCategoryListState();
}

class _IncomeCategoryListState extends State<IncomeCategoryList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().incomeCategoryList,
      builder: (BuildContext context, List<CategoryModel> newList, Widget? _) {
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
                child: Center(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: const Color.fromARGB(255, 120, 157, 122),
                    leading: FittedBox(
                      child: Text(
                        category.name,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                    trailing: FittedBox(
                      child: IconButton(
                        onPressed: () {
                          DeleteCategory().deleteItem(index, category, context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 58, 4, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
