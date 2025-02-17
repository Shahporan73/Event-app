// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_app/data/services/socket_controller.dart';
import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/res/internet_view/no_internet_screen.dart';
import 'package:event_app/view/splash_view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  ///=========================== Get Storage =====================================================================================
  await GetStorage.init();

  /// ============================= init location =================================================================================
  Get.put(CameraManager());



  /// ============================= socket init =================================================================================
  SocketService socketService = Get.put(SocketService());
  await socketService.initializeSocket();


  // permission
  Future.delayed(Duration.zero, () async {
    await getCurrentLocation();
  }).then((value) async{
    await requestNotificationPermission();
  },).then((value) async{
    await requestCameraPermission();
  },);



  /// ============================= Notification init =================================================================================
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message in foreground: ${message.notification?.title}');
    if (message.notification != null) {
      showNotification(
        message.notification?.title,
        message.notification?.body,
      );
    }
  });


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

    // getCurrentLocation();
    // requestNotificationPermission();

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
    return LocalStorage.getData(key: "access_token") != null ? Home() : SplashScreen();
  }

}

Future<void> requestNotificationPermission() async {
  // Check if the permission is granted or denied
  PermissionStatus status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted) {
    // Request notification permission
    PermissionStatus result = await Permission.notification.request();

    if (result.isGranted) {
      print("Notification permission granted.");
    } else if (result.isDenied) {
      print("Notification permission denied.");
    } else if (result.isPermanentlyDenied) {
      print("Notification permission permanently denied. Open settings to enable.");
      openAppSettings(); // Optionally open app settings to enable permission
    }
  } else if (status.isGranted) {
    print("Notification permission already granted.");
  }
}


Future<void> getCurrentLocation() async {
  while (true) {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Notify the user that location services are disabled
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

    // 2. Check and request permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Notify user and loop to retry
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
        continue;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Notify user and allow them to open app settings
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
    }

    // 3. Permissions granted, fetch the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15), // Ensures the location is fetched within a limit
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
        break; // Exit the loop after success
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
      break; // Exit the loop on error
    }
  }
}

/// Request Camera and Microphone Permissions
Future<void> requestCameraPermission() async {
  final status = await Permission.camera.request();
  final microphoneStatus = await Permission.microphone.request();

  if (status.isGranted && microphoneStatus.isGranted) {
    // initializeCamera(); // Initialize camera if permission is granted
    CameraManager().initializeCamera();
    print('Camera and microphone Permission granted');
  } else if (status.isDenied || microphoneStatus.isDenied) {
    Get.snackbar(
      'Permission Denied',
      'Camera and microphone permissions are required to use this feature.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  } else if (status.isPermanentlyDenied || microphoneStatus.isPermanentlyDenied) {
    Get.snackbar(
      'Permission Required',
      'Please enable camera and microphone permissions from app settings.',
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
    openAppSettings(); // Open app settings to manually enable permissions
  }
}


Future<void> showNotification(String? title, String? body) async {
  // Android-specific notification details
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // ID of the notification channel
    'your_channel_name', // Name of the notification channel
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  // Combine Android and iOS/macOS notification details
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title, // Notification title
    body, // Notification body
    platformChannelSpecifics, // Notification details
  );
}


