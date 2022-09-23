import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneywallet/DB/functions/transaction/transaction_db.dart';
import 'package:moneywallet/fonts/reminder/reminder_local_notification.dart';
import 'package:moneywallet/home/Homescreen/controller/provider/bottom_navbar_provider.dart';
import 'package:moneywallet/home/Homescreen/controller/provider/home_screen_provider.dart';
import 'package:moneywallet/home/welcome/controller/provider/LoginProvider/login_provider.dart';
import 'package:moneywallet/home/welcome/controller/provider/spalshProvider/welcome_provider.dart';
import 'package:moneywallet/home/welcome/view/screen_splash.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'home/category/model/category_modal.dart';
import 'home/category/model/category_typemodel.dart';
import 'home/transaction/controller/provider/transaction_provider.dart';
import 'home/transaction/model/transaction_modal.dart';

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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WelcomeProvidfer>(
          create: (_) => WelcomeProvidfer(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<BottomNavbarProvider>(
          create: (_) => BottomNavbarProvider(),
        ),
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (_) => HomeScreenProvider(),
        ),
        ChangeNotifierProvider<TransactionDb>(
          create: (_) => TransactionDb(),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) => TransactionProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
