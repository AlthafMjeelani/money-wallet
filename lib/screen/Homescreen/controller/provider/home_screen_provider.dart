import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../DB/functions/transaction/transaction_db.dart';
import '../../../transaction/controller/provider/transaction_provider.dart';
import '../../../transaction/model/enum.dart';
import '../../../transaction/model/transaction_modal.dart';
import '../../../transaction/view/screen_add_transaction.dart';
import '../../../transaction/view/screen_view_transaction.dart';

class HomeScreenProvider with ChangeNotifier {
  String name = '';
  TransactionModel? model;
  Future<void> getName() async {
    final SharedPreferences prefer = await SharedPreferences.getInstance();
    final userName = prefer.getString('enterName');
    name = userName.toString();
    notifyListeners();
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

  void refresh(context) {
    TransactionDb.instence.refreshUI();
    Provider.of<TransactionProvider>(context, listen: false)
        .transactionRefresh();
    notifyListeners();
  }

  void naviagtorPushEdit(context, index, TransactionModel value, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ScreenAddTransaction(
          type: ActionType.editscreen,
          modal: value,
          id: id,
        ),
      ),
    );
  }

  void navigatorPop(context) {
    Navigator.of(context).pop();
    notifyListeners();
  }

  void naviagtorPushView(
    context,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScreenViewTransaction(),
      ),
    );
  }

  void naviagtorPushAdd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenAddTransaction(
          type: ActionType.addscreen,
        ),
      ),
    );
  }

  void show(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      elevation: 20,
      content: Text(text),
      backgroundColor: Colors.green,
    ));
    notifyListeners();
  }
}
