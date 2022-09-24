import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/home/Homescreen/controller/provider/home_screen_provider.dart';
import 'package:moneywallet/home/transaction/controller/provider/transaction_provider.dart';
import 'package:moneywallet/home/transaction/controller/provider/view_transaction_provider.dart';
import 'package:moneywallet/home/transaction/view/screen_add_transaction.dart';
import 'package:moneywallet/widget/scrool_dissable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../category/model/category_typemodel.dart';
import '../model/enum.dart';

class ScreenViewTransaction extends StatelessWidget {
  const ScreenViewTransaction({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ViewTransactionProvider>(context, listen: false);
    final dbdata = Provider.of<TransactionProvider>(context, listen: false);
    dbdata.transactionRefresh();
    data.dropdownvalueCategory = 'All';
    data.dropdownvalueDay = 'All';
    data.foundData = data.allData;
    return Scaffold(
      appBar: AppBar(
        title: const Text(' All Transactions'),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (BuildContext context, ViewTransactionProvider value,
                Widget? child) {
              return data.search == true
                  ? IconButton(
                      onPressed: () {
                        value.visibilitysearch();
                        value.dropdownvalueCategory;
                        value.dropdownvalueDay;
                        value.checkFilter();
                      },
                      icon: const Icon(Icons.close),
                    )
                  : IconButton(
                      onPressed: () {
                        value.visibilitysearch();
                        value.dropdownvalueCategory;
                        value.dropdownvalueDay;
                        value.checkFilter();
                      },
                      icon: const Icon(Icons.search),
                    );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (BuildContext context, ViewTransactionProvider values,
                Widget? child) {
              return Container(
                color: const Color.fromARGB(255, 248, 245, 245),
                child: SizedBox(
                  height: 100,
                  child: values.search == true
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            autofocus: true,
                            onChanged: (value) => values.searchFilter(value),
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
                                  child: Consumer(
                                    builder: (BuildContext context,
                                        ViewTransactionProvider value,
                                        Widget? child) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint:
                                                  Text(value.dropdownvalueDay),
                                              items: <String>[
                                                'All',
                                                'Today',
                                                'Last 7days',
                                                'Last 30days',
                                                'This year',
                                                // 'custom'
                                              ].map(
                                                (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (newValue) {
                                                value.dropdownvalueDay =
                                                    newValue.toString();
                                                newValue!;
                                                values.checkFilter();
                                                TransactionDb.instence
                                                    .refreshUI();
                                              },
                                            ),
                                          ),
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              hint: Text(
                                                value.dropdownvalueCategory,
                                              ),
                                              items: <String>[
                                                'All',
                                                'Income',
                                                'Expense',
                                              ].map(
                                                (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                value.dropdownvalueCategory =
                                                    newValue!;
                                                value.checkFilter();
                                                TransactionDb.instence
                                                    .refreshUI();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
          Expanded(
            child: Consumer(
              builder: (BuildContext context, ViewTransactionProvider value,
                  Widget? child) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: data.foundData.isNotEmpty
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
                                          side: value.foundData[index].type ==
                                                  CategoryType.income
                                              ? const BorderSide(
                                                  color: Colors.green, width: 1)
                                              : const BorderSide(
                                                  color: Colors.red, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                                        final value = dbdata
                                                                .allTransactionList[
                                                            index];
                                                        Provider.of<HomeScreenProvider>(
                                                                context,
                                                                listen: false)
                                                            .navigatorPop(
                                                                context);

                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                ScreenAddTransaction(
                                                              index: index,
                                                              type: ActionType
                                                                  .editscreen,
                                                              modal: value,
                                                              id: data
                                                                  .model?.id,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                    ),
                                                    Consumer(
                                                      builder: (BuildContext
                                                              context,
                                                          ViewTransactionProvider
                                                              value,
                                                          Widget? child) {
                                                        return IconButton(
                                                          onPressed: () {
                                                            value.deleteItem(
                                                                value.foundData[
                                                                    index],
                                                                context);

                                                            value.checkFilter();
                                                            TransactionDb
                                                                .instence
                                                                .refreshUI();
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      leading: value.foundData[index].type ==
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
                                        value.foundData[index].category.name
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat('yMMMMd').format(
                                            value.foundData[index].date),
                                      ),
                                      trailing: value.foundData[index].type ==
                                              CategoryType.income
                                          ? Text(
                                              '+ ₹${value.foundData[index].amount}',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                            )
                                          : Text(
                                              '- ₹${value.foundData[index].amount}',
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
                            itemCount: value.foundData.length,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
