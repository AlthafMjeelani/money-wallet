// ignore_for_file: must_be_immutable, must_call_super
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/Homescreen/controller/provider/home_screen_provider.dart';
import 'package:moneywallet/home/transaction/controller/provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Homescreen/view/screen_bottomvavigation.dart';
import '../../category/model/category_modal.dart';
import '../../category/model/category_typemodel.dart';
import '../../category/view/screen_category.dart';
import '../model/transaction_modal.dart';

enum ActionType {
  addscreen,
  editscreen,
}

class ScreenAddTransaction extends StatelessWidget {
  ScreenAddTransaction({
    Key? key,
    this.index,
    this.modal,
    this.type,
  }) : super(key: key);

  int? index;
  ActionType? type;
  TransactionModel? modal;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TransactionProvider>(context, listen: false);
    if (type == ActionType.editscreen) {
      data.dateController.text = DateFormat('yMMMMd').format(modal!.date);
      data.amountController.text = modal!.amount.toString();
      data.selectedCategoryType = modal!.type;
    } else {
      data.selectedCategoryType = CategoryType.income;
      data.dateController.clear();
      data.amountController.clear();
      TransactionDb.instence.refreshUI();
      CategoryDb.instence.refreshUI();
    }
    return Scaffold(
      appBar: AppBar(
        title: type == ActionType.addscreen
            ? const Text('ADD TRANSACTION')
            : const Text('EDIT TRANSACTION'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w),
          child: Form(
            key: data.formKeyAlert,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Select your category",
                  style: TextStyle(fontSize: 10.sp),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Consumer(
                    builder: (BuildContext context, TransactionProvider value,
                        Widget? child) {
                      return Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              horizontalTitleGap: 0,
                              title: const Text("Income"),
                              leading: Radio(
                                value: CategoryType.income,
                                groupValue: value.selectedCategoryType,
                                onChanged: (value) => data.incomeRadioButton(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text("Expense"),
                              leading: Radio(
                                value: CategoryType.expense,
                                groupValue: value.selectedCategoryType,
                                onChanged: (value) => data.expenseRadioButton(),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Consumer(
                  builder: (BuildContext context, TransactionProvider values,
                      Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DropdownButtonFormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'select category name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.category),
                          ),
                          hint: const Text('select cetegory'),
                          value: values.dropdownvalueCategory,
                          onChanged: (newValue) {
                            values.dropDownValues(newValue);
                          },
                          items: (values.selectedCategoryType ==
                                      CategoryType.income
                                  ? CategoryDb().incomeCategoryList
                                  : CategoryDb().expenseCategoryList)
                              .value
                              .map((e) {
                            return DropdownMenuItem(
                                value: e.id,
                                child: Text(e.name),
                                onTap: () {
                                  values.selectedCategoryModel = e;
                                });
                          }).toList(),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            addcategory(context);
                          },
                          label: const Text('New Category'),
                          icon: const Icon(Icons.add),
                        )
                      ],
                    );
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+(?:-\d+)?$'),
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter amount';
                    }
                    return null;
                  },
                  controller: data.amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.money),
                    label: Text('Enter Amount'),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'select date';
                    }
                    return null;
                  },
                  controller: data.dateController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.calendar_today),
                      labelText: "Select Date"),
                  readOnly: true,
                  onTap: () async {
                    data.pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    // ignore: use_build_context_synchronously
                    data.pickDate(
                      context,
                      modal?.date,
                    );
                  },
                ),
                SizedBox(
                  height: 4.h,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (data.formKeyAlert.currentState!.validate()) {
                        addTransaction(context);
                        data.textFeildClear();
                        data.dropdownvalueCategory = null;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          elevation: 20,
                          content: Text(
                            'Transaction successfully added',
                          ),
                          backgroundColor: Colors.green,
                        ));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScreenBottomNavbar(),
                            ),
                            (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text('ADD'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction(context) async {
    final data = Provider.of<TransactionProvider>(context, listen: false);
    final amount = data.amountController.text;

    if (amount.isEmpty) {
      return;
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return;
    }

    if (data.selectedCategoryModel == null) {
      return;
    }
    final modal = TransactionModel(
      amount: parsedAmount,
      date: data.pickedDate!,
      type: data.selectedCategoryType,
      category: data.selectedCategoryModel!,
    );
    if (type == ActionType.editscreen) {
      modal.updateTransaction(modal);
    } else {
      TransactionDb.instence.addTransaction(modal);
    }
  }

  Future<void> addcategory(BuildContext context) async {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }

                    if (data.selectedCategoryType == CategoryType.income) {
                      final income = CategoryDb
                          .instence.incomeCategoryList.value
                          .map((e) => e.name.trim().toLowerCase())
                          .toList();
                      if (income.contains(
                          categoryNameController.text.trim().toLowerCase())) {
                        return 'Category already exists';
                      }
                    }
                    if (data.selectedCategoryType == CategoryType.expense) {
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
                      Provider.of<HomeScreenProvider>(context, listen: false)
                          .navigatorPop(context);

                      data.categoryClear();
                    },
                    child: const Text('CANCEL'),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        if (data.formKey.currentState!.validate()) {
                          final categoryName =
                              categoryNameController.text.trim();
                          if (categoryName.isEmpty) {
                            return;
                          }
                          final category = CategoryModel(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            name: categoryName,
                            type:
                                data.selectedCategoryType == CategoryType.income
                                    ? CategoryType.income
                                    : CategoryType.expense,
                          );
                          CategoryDb().insertCategory(category);
                          data.categoryClear();

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
                      child: const Text('ADD')),
                ],
              )
            ],
          );
        });
  }
}
