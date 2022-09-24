import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../DB/functions/transaction/transaction_db.dart';
import '../../../../widget/snackbar_widget.dart';
import '../../../category/view/screen_category.dart';
import '../../../settings/screen_settings.dart';
import '../../../statistics/screen_satistics.dart';
import '../../../transaction/controller/provider/transaction_provider.dart';
import '../../../transaction/model/transaction_modal.dart';
import '../../view/screen_home.dart';

class HomeScreenSupport {
  static List screens = [
    const ScreenHome(),
    const ScreenCategory(),
    const ScreenStatistics(),
    const ScreenSettings()
  ];

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
                SnackBarWidget()
                    .show(context, 'Transaction successfully deleted');
                Navigator.pop(context);
                Navigator.pop(context);
                Provider.of<TransactionProvider>(context, listen: false)
                    .transactionRefresh();
                Provider.of<TransactionProvider>(context, listen: false)
                    .addTotalTransaction();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
