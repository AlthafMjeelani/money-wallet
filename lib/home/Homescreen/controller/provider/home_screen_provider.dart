import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../DB/functions/transaction/transaction_db.dart';
import '../../../transaction/view/screen_add_transaction.dart';
import '../../../transaction/view/screen_view_transaction.dart';

class HomeScreenProvider with ChangeNotifier {
  String name = '';
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

  void refresh() {
    TransactionDb.instence.refreshUI();
    TransactionDb.instence.addTotalTransaction();
    notifyListeners();
  }

  void naviagtorPushEdit(context, index, value) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ScreenAddTransaction(
          index: index,
          type: ActionType.editscreen,
          modal: value,
        ),
      ),
    );
  }

  void navigatorPop(context) {
    Navigator.of(context).pop();
  }

  void naviagtorPushView(context) {
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
}
