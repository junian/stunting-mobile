import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/LanguageController.dart';
import 'package:growthtracker/helper/AppRouteObserver.dart';
import 'package:growthtracker/helper/Branding.dart';
import 'package:growthtracker/localization/AppTranslations.dart';
import 'package:growthtracker/pages/SplashScreenPage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Portrait only, edge-to-edge with a transparent status bar so the gradient
  // headers can run behind the system UI.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Resolve the initial language from the saved preference, or from the
  // device system language (English fallback).
  final languageController = Get.put(LanguageController(), permanent: true);
  Get.locale = languageController.locale.value;

  // Localized month names for every date the app formats.
  await initializeDateFormatting('en');
  await initializeDateFormatting('id');
  Intl.defaultLocale = languageController.locale.value.languageCode;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Get.locale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('id')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 240),
      navigatorObservers: [appRouteObserver],
      home: const SplashScreenPage(),
    );
  }
}
