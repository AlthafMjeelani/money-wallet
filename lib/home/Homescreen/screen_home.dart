import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/db/functions/category/category_db.dart';
import 'package:moneywallet/db/functions/transaction/transaction_db.dart';
import 'package:moneywallet/widget/home_card_widget.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../category/model/category_typemodel.dart';
import '../transaction/model/transaction_modal.dart';
import '../transaction/view/screen_add_transaction.dart';
import '../transaction/view/screen_view_transaction.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

String name = '';

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    CategoryDb.instence.refreshUI();
    TransactionDb.instence.refreshUI();
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ScreenAddTransaction(
                  type: ActionType.addscreen,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding:
              EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h, top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting(),
              ),
              Text(
                name.toUpperCase(),
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              const HomeCardWidget(),
              SizedBox(height: 2.h),
              Row(
                children: [
                  const Text('RECENT TRANSACTIONS'),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScreenViewTransaction(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.remove_red_eye_rounded,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      'View All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ValueListenableBuilder(
                    valueListenable:
                        TransactionDb.instence.transactionListNotifire,
                    builder: (BuildContext context,
                        List<TransactionModel> newList, Widget? _) {
                      if (newList.isEmpty) {
                        return Center(
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
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 246, 238, 238),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final value = newList[index];
                              return Center(
                                child: Column(
                                  children: [
                                    ListTile(
                                      textColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                      ),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                                                              modal: value,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        deleteItem(index, value,
                                                            context);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      leading: value.type == CategoryType.income
                                          ? Icon(
                                              Icons.arrow_circle_up,
                                              color: Colors.green,
                                              size: 30.sp,
                                            )
                                          : Icon(
                                              Icons.arrow_circle_down,
                                              color: Colors.red,
                                              size: 30.sp,
                                            ),
                                      title: Text(
                                        value.category.name.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.sp),
                                      ),
                                      subtitle: Text(
                                        DateFormat('yMMMMd').format(value.date),
                                      ),
                                      trailing: value.type ==
                                              CategoryType.income
                                          ? Text(
                                              '+ ₹${value.amount}',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            )
                                          : Text(
                                              '- ₹${value.amount}',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      height: .5.h,
                                    )
                                  ],
                                ),
                              );
                            },
                            itemCount: newList.length >= 4 ? 4 : newList.length,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteItem(
      int index, TransactionModel modal, BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: const Text('Permenantly delete your data continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                TransactionDb.instence.deleteTransactoin(modal.id!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  elevation: 20,
                  content: Text(
                    'Transaction successfully deleted',
                  ),
                  backgroundColor: Colors.green,
                ));
                Navigator.pop(context);
                Navigator.pop(context);
                setState(
                  () {
                    TransactionDb.instence.refreshUI();
                    TransactionDb.instence.addTotalTransaction();
                  },
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 16) {
      return 'Good Afternoon';
    }
    if (hour < 22) {
      return 'Good Evening';
    }
    return 'Good Night';
  }

  Future<void> getName() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    final userName = prefer.getString('enterName');
    setState(() {
      name = userName.toString();
    });
  }
}
