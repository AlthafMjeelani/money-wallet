import 'package:flutter/material.dart';
import 'package:moneywallet/widget/screen_delete_items.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../statistics/widgets/screen_nodatafound.dart';
import '../controller/provider/category_provider.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (BuildContext context, newList, Widget? _) {
        if (newList.incomeCategoryList.isEmpty) {
          return const NoDataFound(
            text: 'No Categories',
          );
        } else {
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (1.2 / .4),
            shrinkWrap: true,
            children: List.generate(
              newList.incomeCategoryList.length,
              (index) {
                final category = newList.incomeCategoryList[index];
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
                            DeleteCategory()
                                .deleteItem(category.id, category, context);
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
              },
            ),
          );
        }
      },
    );
  }
}
