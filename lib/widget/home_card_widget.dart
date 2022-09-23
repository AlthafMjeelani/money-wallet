import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:sizer/sizer.dart';

class HomeCardWidget extends StatefulWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeCardWidget> createState() => _HomeCardWidgetState();
}

class _HomeCardWidgetState extends State<HomeCardWidget> {
  @override
  void initState() {
    TransactionDb.instence.refreshUI();
    TransactionDb.instence.addTotalTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(237, 2, 120, 85),
              Color.fromARGB(255, 5, 41, 96),
              Color.fromARGB(255, 7, 95, 105)
            ],
          )),
      height: 25.h,
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          ValueListenableBuilder(
            builder: (BuildContext context, num value, Widget? child) {
              return Column(
                children: [
                  value < 0
                      ? Text(
                          'TOTAL LOSS',
                          style: TextStyle(fontSize: 11.sp, color: Colors.red),
                        )
                      : Text(
                          'TOTAL BALANCE',
                          style:
                              TextStyle(fontSize: 11.sp, color: Colors.white),
                        ),
                  FittedBox(
                    child: Text(
                      '₹$value',
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 25.5.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
            valueListenable: TransactionDb.instence.totalBalence,
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_circle_up,
                  color: Colors.green,
                  size: 28.sp,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income',
                        style: TextStyle(color: Colors.white, fontSize: 11.sp),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? _) {
                          return FittedBox(
                            child: Text(
                              '₹$value',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 25.5.sp, color: Colors.white),
                              ),
                            ),
                          );
                        },
                        valueListenable: TransactionDb.instence.totalIncome,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_circle_down,
                  color: Colors.red,
                  size: 28.sp,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense',
                        style: TextStyle(color: Colors.white, fontSize: 11.sp),
                      ),
                      ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? _) {
                          return FittedBox(
                            child: Text(
                              '₹$value',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 25.5.sp, color: Colors.white),
                              ),
                            ),
                          );
                        },
                        valueListenable: TransactionDb.instence.totalExpense,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
