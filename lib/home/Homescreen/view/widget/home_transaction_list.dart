import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../category/model/category_typemodel.dart';
import '../../../transaction/model/transaction_modal.dart';
import '../../controller/provider/home_screen_provider.dart';
import '../../controller/support/list_of_pages.dart';

class HomeTransactionList extends StatelessWidget {
  const HomeTransactionList({
    Key? key,
    required this.value,
    required this.index,
  }) : super(key: key);

  final TransactionModel value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<HomeScreenProvider>(context, listen: false);
    return Column(
      children: [
        ListTile(
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            data.navigatorPop(context);
                            data.naviagtorPushEdit(context, index, value);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            HomeScreenSupport()
                                .deleteItem(index, value, context);
                          },
                          icon: const Icon(Icons.delete),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
          ),
          subtitle: Text(
            DateFormat('yMMMMd').format(value.date),
          ),
          trailing: value.type == CategoryType.income
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
    );
  }
}
