import 'dart:io';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Types of notifications
enum NotificationType {
  reminder,
}

/// Data structure for notification details
class NotificationData {
  final NotificationType notificationType;
  final String? objectId;
  final String? objectType;
  final DateTime? scheduledDate;

  NotificationData({
    required this.notificationType,
    this.objectId,
    this.objectType,
    this.scheduledDate,
  });
}

/// Manages local notifications for the app
class LocalNotificationManager {

  //region Singleton
  static final LocalNotificationManager _instance = LocalNotificationManager._internal();

  factory LocalNotificationManager() {
    return _instance;
  }

  LocalNotificationManager._internal();
  //endregion

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
    'Jampa_flutter', // id
    'Jampa', // title
    importance: Importance.max,
  );

  /// Initializes the local notification manager
  Future<void> initialize() async {
    // Initialize local notifications with platform specific settings
    await initializeLocalNotifications();
    // Initialize timezone for precise scheduling
    await initializeTimeZone();

    // Create notification channel for Android
    await flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
       ?.createNotificationChannel(androidChannel);
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Initializes timezone data and sets the local timezone for precise scheduling
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
  }

  /// Initializes local notifications with platform specific settings
  Future<void> initializeLocalNotifications() async {
    // Notification logo for android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("ic_notification");
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestCriticalPermission: false,
      requestSoundPermission: false,
    );

    // Initialize notifications setup
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? response) async {
        // on click foreground notif
        _manageForegroundFromLocalNotification(response);
      },
      onDidReceiveBackgroundNotificationResponse: messageBackgroundHandler,
    );
  }

  /// Handles notification taps when the app is in the background or terminated
  @pragma('vm:entry-point')
  static Future<void> messageBackgroundHandler(NotificationResponse notificationResponse) async {
    print("Handling a background message: ${notificationResponse.payload}");
    //TODO  Handle the notification tap when the app is in the background or terminated
  }

  /// Handles notification taps when the app is in the foreground
  Future<void> _manageForegroundFromLocalNotification(NotificationResponse? response) async {
    var payload = response?.payload;
    if (payload?.isNotEmpty == true) {
      try {
       // TODO Handle the notification tap when the app is in the foreground
      } catch (error) {
        // Handle any errors that occur during notification handling
      }
    }
  }

  // region DisplayNotification
  /// Displays an immediate notification with the given title, body, and data
  Future<bool> showNotification(String? title, String? body, NotificationData notificationData) async {
    String groupKey = "group_${notificationData.notificationType}";

    // android
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
          notificationData.hashCode,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              priority: Priority.high,
              groupKey: groupKey,
              styleInformation: const BigTextStyleInformation(''),
            ),
          ),
          payload: "?notificationType=${notificationData.notificationType.name}"
              "?objectId=${notificationData.objectId}"
              "?objectType=${notificationData.objectType}");
    }
    // ios
    // else if (Platform.isIOS) {
    //   await flutterLocalNotificationsPlugin.show(
    //       notificationData.hashCode,
    //       title,
    //       body,
    //       NotificationDetails(
    //           iOS: DarwinNotificationDetails(
    //             presentAlert: true,
    //             threadIdentifier: groupKey,
    //             presentBadge: true,
    //             presentSound: true,
    //           )),
    //       payload: "?notificationType=${notificationData.notificationType.name}?objectId=${notificationData.objectId}");
    // }

    return true;
  }

  /// Schedules a notification for a future date and time
  Future<void> scheduleNotification(String? title, String? body, NotificationData notificationData) async {
    String groupKey = "group_${notificationData.notificationType}";

    if(notificationData.scheduledDate == null){
      return;
    }
    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(notificationData.scheduledDate!, tz.local);

    // android
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationData.hashCode,
          title,
          body,
          scheduledTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              importance: Importance.high,
              priority: Priority.max,
              groupKey: groupKey,
              styleInformation: const BigTextStyleInformation(''),
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: "?notificationType=${notificationData.notificationType.name}"
              "?objectId=${notificationData.objectId}"
              "?objectType=${notificationData.objectType}",
      );
    }
  }

  /// Removes a scheduled or displayed notification by its ID
  Future<void> removeNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

// endregion
}