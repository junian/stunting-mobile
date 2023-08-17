import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stantapp/firebase_api.dart';
import 'package:stantapp/pages/AddAccountChildern.dart';
import 'package:stantapp/pages/HomePage.dart';
import 'package:stantapp/pages/ImunisasiPage.dart';
import 'package:stantapp/pages/JadwalVaksinasiPage.dart';
import 'package:stantapp/pages/SetProfilePage%202.dart';
import 'package:stantapp/pages/SetProfilePage.dart';
import 'package:stantapp/pages/SplashScreen.dart';
import 'package:stantapp/pages/WelcomePage.dart';
import 'package:get/get.dart';
import 'package:stantapp/widget/BottomNavbar.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  
  runApp(const MyApp());

  await GetStorage.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: SplashScreen(),
      home: SplashScreen(),
      // home: SetProfilePage(),
    );
  }
}
