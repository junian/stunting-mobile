import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growthtracker/pages/ChildrenEditorPage.dart';
import 'package:growthtracker/pages/HomePage.dart';
import 'package:growthtracker/pages/VaccinationPage.dart';
import 'package:growthtracker/pages/VaccinationSchedulePage.dart';
import 'package:growthtracker/pages/SetProfilePage2.dart';
import 'package:growthtracker/pages/SetProfilePage.dart';
import 'package:growthtracker/pages/SplashScreenPage.dart';
import 'package:growthtracker/pages/WelcomePage.dart';
import 'package:get/get.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growthtracker/controller/LanguageController.dart';
import 'package:growthtracker/localization/AppTranslations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  //set potrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Resolve the initial language from the saved preference, or from the
  // device system language (English fallback).
  final languageController = Get.put(LanguageController(), permanent: true);
  Get.locale = languageController.locale.value;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'STANTAPP',
      translations: AppTranslations(),
      locale: Get.locale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('id')],
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
      // home: SplashScreenPage(),
      home: SplashScreenPage(),
      // home: SetProfilePage(),
    );
  }
}
