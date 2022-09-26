import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../category/model/category_typemodel.dart';
import '../controller/provider/transaction_provider.dart';

class RadioButtonWidget extends StatelessWidget {
  const RadioButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Consumer(
        builder:
            (BuildContext context, TransactionProvider data, Widget? child) {
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  title: const Text("Income"),
                  leading: Radio(
                    value: CategoryType.income,
                    groupValue: data.selectedCategoryType,
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
                    groupValue: data.selectedCategoryType,
                    onChanged: (value) => data.expenseRadioButton(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
