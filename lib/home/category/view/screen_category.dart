import 'package:flutter/material.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:moneywallet/widget/tabbar_widget.dart';
import '../model/category_modal.dart';
import '../model/category_typemodel.dart';
import 'expense_categorylist_widget.dart';
import 'income_categorylist_widget.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({Key? key}) : super(key: key);

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

TextEditingController categoryNameController = TextEditingController();
late TabController tabController;
final _formKey = GlobalKey<FormState>();

class _ScreenCategoryState extends State<ScreenCategory>
    with TickerProviderStateMixin {
  @override
  void initState() {
    CategoryDb.instence.refreshUI();
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addcategory(
              context,
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TabbarWidget(
                tabController: tabController,
                tabs: const [
                  Tab(
                    text: 'Income',
                  ),
                  Tab(
                    text: 'Expense',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      IncomeCategoryList(),
                      ExpenseCategoryList(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addcategory(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(10),
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }

                    if (tabController.index == 0) {
                      final income = CategoryDb
                          .instence.incomeCategoryList.value
                          .map((e) => e.name.trim().toLowerCase())
                          .toList();
                      if (income.contains(
                          categoryNameController.text.trim().toLowerCase())) {
                        return 'Category already exists';
                      }
                    }
                    if (tabController.index == 1) {
                      final expense = CategoryDb
                          .instence.expenseCategoryList.value
                          .map((e) => e.name.trim().toLowerCase())
                          .toList();
                      if (expense.contains(
                          categoryNameController.text.trim().toLowerCase())) {
                        return 'Category already exists';
                      }
                    }
                    return null;
                  },
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
                      Navigator.of(ctx).pop();
                      setState(() {
                        categoryNameController.clear();
                      });
                    },
                    child: const Text('CANCEL'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final categoryName = categoryNameController.text.trim();
                        if (categoryName.isEmpty) {
                          return;
                        }
                        final category = CategoryModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: categoryName,
                          type: tabController.index == 0
                              ? CategoryType.income
                              : CategoryType.expense,
                        );
                        CategoryDb().insertCategory(category);
                        setState(
                          () {
                            categoryNameController.clear();
                            CategoryDb.instence.refreshUI();
                          },
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          elevation: 20,
                          content: Text(
                            'successfully added to categorylist',
                          ),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: const Text('ADD'),
                  ),
                ],
              )
            ],
          );
        });
  }
}
