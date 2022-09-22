import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/transaction/view/screen_add_transaction.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:sizer/sizer.dart';

import '../../category/model/category_typemodel.dart';
import '../model/transaction_modal.dart';

class ScreenViewTransaction extends StatefulWidget {
  const ScreenViewTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenViewTransaction> createState() => _ScreenViewTransactionState();
}

String? drodownValue;
late String dropdownvalueDay;
late String dropdownvalueCategory;

class _ScreenViewTransactionState extends State<ScreenViewTransaction>
    with TickerProviderStateMixin {
  final List<TransactionModel> allData =
      TransactionDb.instence.transactionListNotifire.value;

  List<TransactionModel> foundData = [];
  bool search = false;
  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    dropdownvalueCategory = 'All';
    dropdownvalueDay = 'All';
    foundData = allData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' All Transactions'),
        centerTitle: true,
        actions: [
          search == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      search = false;
                      dropdownvalueCategory = 'All';
                      dropdownvalueDay = 'All';
                      checkFilter();
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      search = true;
                      dropdownvalueCategory = 'All';
                      dropdownvalueDay = 'All';
                      checkFilter();
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 248, 245, 245),
            child: SizedBox(
              height: 100,
              child: search == true
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) => searchFilter(value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text(dropdownvalueDay),
                                      items: <String>[
                                        'All',
                                        'Today',
                                        'Last 7days',
                                        'Last 30days',
                                        'This year',
                                        // 'custom'
                                      ].map(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalueDay = newValue!;
                                          checkFilter();
                                          TransactionDb.instence.refreshUI();
                                        });
                                      },
                                    ),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text(dropdownvalueCategory),
                                      items: <String>[
                                        'All',
                                        'Income',
                                        'Expense',
                                      ].map(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalueCategory = newValue!;
                                          checkFilter();
                                          TransactionDb.instence.refreshUI();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: foundData.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Center(
                            child: Column(
                              children: [
                                ListTile(
                                  textColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      side: foundData[index].type ==
                                              CategoryType.income
                                          ? const BorderSide(
                                              color: Colors.green, width: 1)
                                          : const BorderSide(
                                              color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  onLongPress: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 50,
                                          color: Colors.white,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              ScreenAddTransaction(
                                                            index: index,
                                                            type: ActionType
                                                                .editscreen,
                                                            modal: foundData[
                                                                index],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit)),
                                                IconButton(
                                                  onPressed: () {
                                                    deleteItem(foundData[index],
                                                        context);
                                                    setState(
                                                      () {
                                                        checkFilter();
                                                        TransactionDb.instence
                                                            .refreshUI();
                                                      },
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  leading: foundData[index].type ==
                                          CategoryType.income
                                      ? const Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.green,
                                          size: 40,
                                        )
                                      : const Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                  title: Text(
                                    foundData[index]
                                        .category
                                        .name
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('yMMMMd')
                                        .format(foundData[index].date),
                                  ),
                                  trailing: foundData[index].type ==
                                          CategoryType.income
                                      ? Text(
                                          '+ ₹${foundData[index].amount}',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        )
                                      : Text(
                                          '- ₹${foundData[index].amount}',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: foundData.length,
                      ),
                    )
                  : Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/assets/images/no-data-unscreen.gif'),
                          ),
                        ),
                        width: 300,
                        height: 300,
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'No Transactions',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteItem(TransactionModel modal, BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly delete your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                TransactionDb.instence
                    .deleteTransactoin(modal.id!)
                    .whenComplete(() => checkFilter());
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => setState(
                    () {
                      checkFilter();
                      TransactionDb.instence.refreshUI();
                      TransactionDb.instence.addTotalTransaction();
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 20,
                  content: Text(
                    'Transaction successfully deleted',
                  ),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  checkFilter() {
    List<TransactionModel> results = [];
    final String todaydate = DateFormat('yMMMMd').format(DateTime.now());
    final DateTime todaySort = DateFormat('yMMMMd').parse(todaydate);
    final DateTime weekDate = DateTime.now().subtract(const Duration(days: 7));
    final DateTime monthDate =
        DateTime.now().subtract(const Duration(days: 30));
    final DateTime yearDate =
        DateTime.now().subtract(const Duration(days: 365));

    if (dropdownvalueCategory == 'All' && dropdownvalueDay == 'All') {
      results = allData;
    } else if (dropdownvalueCategory == 'Income' && dropdownvalueDay == 'All') {
      results = allData
          .where((element) =>
              element.category.type == CategoryType.income &&
              dropdownvalueDay == 'All')
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'All') {
      results = allData
          .where((element) =>
              element.category.type == CategoryType.expense &&
              dropdownvalueDay == 'All')
          .toList();
    } else if (dropdownvalueCategory == 'All' && dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) => element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Today') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date == todaySort,
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) => element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Last 7days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(weekDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) => element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'Last 30days') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(monthDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'All' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) => element.date.isAfter(yearDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Income' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.income &&
                element.date.isAfter(yearDate),
          )
          .toList();
    } else if (dropdownvalueCategory == 'Expense' &&
        dropdownvalueDay == 'This year') {
      results = allData
          .where(
            (element) =>
                element.category.type == CategoryType.expense &&
                element.date.isAfter(yearDate),
          )
          .toList();
    }
    setState(() {
      foundData = results;
    });
  }

  void searchFilter(String enteredKeyword) {
    List<TransactionModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allData;
    } else {
      results = allData
          .where((user) => user.category.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundData = results;
    });
  }
}
