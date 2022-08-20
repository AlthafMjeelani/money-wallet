import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneywallet/Screens/reminder/reminder_local_notification.dart';
import 'package:moneywallet/Screens/welcome/screen_splash.dart';
import 'package:moneywallet/models/categorytypemodal/category_modal.dart';
import 'package:moneywallet/models/categorytypemodal/category_typemodel.dart';
import 'package:moneywallet/models/transactionmodal/transaction_modal.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  await NotificationApi.init();
  NotificationApi.notificationDetails();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'fontsPoppins',
          primarySwatch: Colors.indigo,
        ),
        home: const ScreenSplash(),
      );
    });
  }
}
