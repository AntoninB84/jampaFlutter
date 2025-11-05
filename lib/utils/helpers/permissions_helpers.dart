import 'package:permission_handler/permission_handler.dart';

class PermissionsHelpers {

  static Future<void> requestAllPermissions() async {
    await Future.wait([
      checkNotificationPermission(),
      checkAlarmPermission(),
    ]);
  }

  static Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> checkAlarmPermission() async {
    // Note: Alarm permission is only required on Android 13 and above
    final status = await Permission.scheduleExactAlarm.request();
    return status.isGranted;
  }
}