// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/res/app_colors/App_Colors.dart';
import 'package:event_app/view/event_view/view/camera_screen.dart';
import 'package:event_app/view/event_view/view/create_post_screen.dart';
import 'package:event_app/view/event_view/view/post_screen.dart';
import 'package:event_app/view/splash_view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/token_manager/local_storage.dart';
import 'data/translation/my_translation.dart';
import 'firebase_options.dart';
import 'view/event_view/controller/camera_controller.dart';
import 'view/home_view/view/home.dart';
import 'view/profile_view/controller/user_profile_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///=========================== Get Storage =====================================================================================
  await GetStorage.init();

  /// ============================= init location =================================================================================
  Get.put(CameraManager());



  /// ============================= socket init =================================================================================
  SocketService socketService = Get.put(SocketService());
  await socketService.initializeSocket();


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

    print('Access token ===> ${LocalStorage.getData(key: "access_token")}');
    print('Refresh token ===> ${LocalStorage.getData(key: "refreshToken")}');

    String? locale = LocalStorage.getData(key: "language");
    return ScreenUtilInit(
      designSize: const Size(360, 800),  // Your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        Get.put(UserProfileController());
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
          home: MainScreen(),
        );
      },
    );
  }
}


/// Network check Screen
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ConnectivityResult? _connectivityResult;
  bool _isConnectedToInternet = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _initializeConnectivity();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (mounted) {
        setState(() {
          _connectivityResult = result;
          _isConnectedToInternet = result != ConnectivityResult.none;
        });
      }
    });
  }

  Future<void> _initializeConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _connectivityResult = result;
        _isConnectedToInternet = result != ConnectivityResult.none;
      });
    }
  }

  void _retryConnection() async {
    await _initializeConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_connectivityResult == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (_connectivityResult == ConnectivityResult.none || !_isConnectedToInternet) {
      // Show NoInternetScreen if there is no network or no active internet connection
      return NoInternetScreen(onRetry: _retryConnection);
    }

    // Check if access token exists and navigate accordingly
    return /*CameraPage()*/ LocalStorage.getData(key: "access_token") != null ? Home() : SplashScreen();
  }

}


Future<void> getCurrentLocation() async {
  while (true) {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Get.defaultDialog(
        title: "Location Services Disabled",
        middleText: "This app requires location services to function. Please enable them.",
        textConfirm: "Enable Services",
        onConfirm: () {
          Geolocator.openLocationSettings();
          Get.back();
        },
        textCancel: "Retry",
        onCancel: () {
          Get.back();
        },
      );
      continue; // Re-check location services
    }

    // 2. Check and request permissions using Permission Handler
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isDenied) {
      await Get.defaultDialog(
        title: "Location Permission Denied",
        middleText: "This app requires location permissions to function.",
        textConfirm: "Grant Permission",
        onConfirm: () {
          Get.back();
        },
        textCancel: "Retry",
        onCancel: () {
          Get.back();
        },
      );
      continue; // Re-request permissions
    } else if (permissionStatus.isPermanentlyDenied) {
      await Get.defaultDialog(
        title: "Location Permission Permanently Denied",
        middleText: "Permissions are permanently denied. Open the app settings to grant permissions.",
        textConfirm: "Open Settings",
        onConfirm: () async {
          await openAppSettings();
          Get.back();
        },
        textCancel: "Retry",
        onCancel: () {
          Get.back();
        },
      );
      continue; // Re-check permissions
    } else if (permissionStatus.isGranted) {
      break; // Exit the loop if permissions are granted
    }
  }

  // 3. Permissions granted, fetch the current position
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("Fetched Position: ${position.latitude}, ${position.longitude}");

    // 4. Get location details (like city, country) using the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String area = "${place.locality}, ${place.country}";
      String lat = "${position.latitude}";
      String long = "${position.longitude}";

      print('Area: $area Latitude: $lat Longitude: $long');

      // Save the location details into LocalStorage
      LocalStorage.saveData(key: nearbyLatitude, data: lat);
      LocalStorage.saveData(key: nearbyLongitude, data: long);

      Get.rawSnackbar(
        message: "Permission granted successfully!",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Permission granted successfully!");
    } else {
      Get.rawSnackbar(
        message: "Unable to retrieve location details.",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.rawSnackbar(
      message: "Error occurred while getting the location: $e",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    );
    print("Error occurred while getting the location: $e");
  }
}


class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'It looks like you’re offline. Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
