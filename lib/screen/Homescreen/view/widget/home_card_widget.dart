import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../transaction/controller/provider/transaction_provider.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionProvider>(context, listen: false)
        .addTotalTransaction();

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
      child: Consumer(
        builder:
            (BuildContext context, TransactionProvider value, Widget? child) {
          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Column(
                children: [
                  // ignore: unrelated_type_equality_checks
                  value.totalBalence < 0
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
                      '₹${value.totalBalence}',
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 25.5.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 11.sp),
                          ),
                          FittedBox(
                            child: Text(
                              '₹${value.totalIncome}',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 25.5.sp, color: Colors.white),
                              ),
                            ),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 11.sp),
                          ),
                          FittedBox(
                            child: Text(
                              '₹${value.totalExpense}',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 25.5.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
