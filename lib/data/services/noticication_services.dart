import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  late final InitializationSettings initializationSettings;

  NotificationHelper() {
    // Initialize platform-specific settings
    final AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
    const DarwinInitializationSettings();

    // Combine platform-specific settings into a general initialization setting
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
  }

  Future<void> initializeNotifications() async {
    // Request permissions for iOS/macOS and initialize notifications
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (result == null || !result) {
        print("Notification permissions were not granted on iOS/macOS.");
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      print("Notification permissions are assumed granted on Android below API 33.");
      // For Android 13+, consider integrating the permission_handler package
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
}
