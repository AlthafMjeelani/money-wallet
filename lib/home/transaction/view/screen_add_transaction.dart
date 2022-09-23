// ignore_for_file: must_be_immutable, must_call_super
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/category/category_db.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:sizer/sizer.dart';

import '../../Homescreen/view/screen_bottomvavigation.dart';
import '../../category/model/category_modal.dart';
import '../../category/model/category_typemodel.dart';
import '../../category/view/screen_category.dart';
import '../model/transaction_modal.dart';

enum ActionType { addscreen, editscreen }

class ScreenAddTransaction extends StatefulWidget {
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
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

TextEditingController dateController = TextEditingController();
TextEditingController amountController = TextEditingController();
final _formKeyAlert = GlobalKey<FormState>();

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  CategoryType _selectedCategoryType = CategoryType.income;
  CategoryModel? _selectedCategoryModel;
  String? dropdownvalueCategory;
  DateTime? pickedDate;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.type == ActionType.editscreen) {
      dateController.text = DateFormat('yMMMMd').format(widget.modal!.date);
      amountController.text = widget.modal!.amount.toString();
      _selectedCategoryType = widget.modal!.type;
    } else {
      CategoryDb.instence.refreshUI();
      _selectedCategoryType = CategoryType.income;
      dateController.clear();
      amountController.clear();
      TransactionDb.instence.refreshUI();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.type == ActionType.addscreen
            ? const Text('ADD TRANSACTION')
            : const Text('EDIT TRANSACTION'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w),
          child: Form(
            key: _formKeyAlert,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          horizontalTitleGap: 0,
                          title: const Text("Income"),
                          leading: Radio(
                              value: CategoryType.income,
                              groupValue: _selectedCategoryType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryType = CategoryType.income;
                                  dropdownvalueCategory = null;
                                });
                              }),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          horizontalTitleGap: 0,
                          title: const Text("Expense"),
                          leading: Radio(
                              value: CategoryType.expense,
                              groupValue: _selectedCategoryType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategoryType = CategoryType.expense;
                                  dropdownvalueCategory = null;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
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
                      value: dropdownvalueCategory,
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalueCategory = newValue;
                        });
                      },
                      items: (_selectedCategoryType == CategoryType.income
                              ? CategoryDb().incomeCategoryList
                              : CategoryDb().expenseCategoryList)
                          .value
                          .map((e) {
                        return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                            onTap: () {
                              _selectedCategoryModel = e;
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
                  controller: amountController,
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
                    controller: dateController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.calendar_today),
                        labelText: "Select Date"),
                    readOnly: true,
                    onTap: () async {
                      pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      setState(() {
                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat('yMMMMd').format(pickedDate!);
                        } else {
                          dateController.text =
                              DateFormat('yMMMMd').format(widget.modal!.date);
                        }
                      });
                    }),
                SizedBox(
                  height: 4.h,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKeyAlert.currentState!.validate()) {
                        addTransaction();
                        setState(() {
                          amountController.clear();
                          dateController.clear();
                        });
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

  Future<void> addTransaction() async {
    final amount = amountController.text;

    if (amount.isEmpty) {
      return;
    }

    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return;
    }
    pickedDate ??= widget.modal!.date;

    if (_selectedCategoryModel == null) {
      return;
    }
    final modal = TransactionModel(
      amount: parsedAmount,
      date: pickedDate!,
      type: _selectedCategoryType,
      category: _selectedCategoryModel!,
    );
    if (widget.type == ActionType.editscreen) {
      widget.modal!.updateTransaction(modal);
    } else {
      TransactionDb.instence.addTransaction(modal);
    }
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

                    if (_selectedCategoryType == CategoryType.income) {
                      final income = CategoryDb
                          .instence.incomeCategoryList.value
                          .map((e) => e.name.trim().toLowerCase())
                          .toList();
                      if (income.contains(
                          categoryNameController.text.trim().toLowerCase())) {
                        return 'Category already exists';
                      }
                    }
                    if (_selectedCategoryType == CategoryType.expense) {
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
                            type: _selectedCategoryType == CategoryType.income
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
                      child: const Text('ADD')),
                ],
              )
            ],
          );
        });
  }
}
