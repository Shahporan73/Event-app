// ignore_for_file: prefer_const_constructors

import 'package:event_app/view/settings_view/view/language_screen.dart';
import 'package:event_app/view/splash_view/splash_screen.dart';
import 'package:event_app/view/splash_view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/token_manager/local_storage.dart';
import 'data/translation/my_translation.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  ///=========================== Get Storage =====================================================================================
  await GetStorage.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Set the status bar style here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set the status bar color
      statusBarIconBrightness:
      Brightness.dark, // Use Brightness.light for dark icons
    ));

    String? locale = LocalStorage.getData(key: "language");
    return ScreenUtilInit(
      designSize: const Size(360, 800),  // Your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          locale: locale != null ? Locale(locale) : Get.deviceLocale, // Set locale
          fallbackLocale: Locale('en'),
          translations: MyTranslations(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light, // Light theme
            ),
            useMaterial3: true,
          ),
          home: SplashScreen(),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}
