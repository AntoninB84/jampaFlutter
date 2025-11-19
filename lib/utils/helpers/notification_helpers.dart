import 'package:alarm/alarm.dart';

import '../local_notification_manager.dart';

class NotificationPayload {
  int? notificationId;
  int? alarmId;
  String objectType;
  String? objectId;

  NotificationPayload({
    this.notificationId,
    this.alarmId,
    required this.objectType,
    required this.objectId,
  });
}

abstract class NotificationHelpers {

  static Future<List<NotificationPayload>> fetchPendingPayloads() async {
    final pendingNotifications = await LocalNotificationManager().flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final pendingAlarms = await Alarm.getAlarms();
    List<NotificationPayload> pendingNotificationPayload =
    pendingNotifications.map((e) =>
        NotificationHelpers.getNotificationPayload(
            notificationId: e.id,
            payload: e.payload ?? "")
    ).toList()..addAll(pendingAlarms.map((e) =>
        NotificationHelpers.getNotificationPayload(
            alarmId: e.id,
            payload: e.payload ?? ""))
    );
    return pendingNotificationPayload;
  }

  static Map<String, String> extractPayloadValues(String payload){
    Map<String, String> values = {};
    List<String> parts = payload.split("?");
    for(final part in parts){
      if(part.contains("=")){
        List<String> keyValue = part.split("=");
        if(keyValue.length == 2){
          values[keyValue[0]] = keyValue[1];
        }
      }
    }
    return values;
  }

  static String? extractObjectIdFromPayload(String payload){
    Map<String, String> values = extractPayloadValues(payload);
    if(values.containsKey("objectId")){
      return values["objectId"];
    }
    return null;
  }

  static NotificationPayload getNotificationPayload({
    int? alarmId,
    int? notificationId,
    required String payload
  }){
    Map<String, String> values = extractPayloadValues(payload);
    return NotificationPayload(
      alarmId: alarmId,
      notificationId: notificationId,
      objectType: values["objectType"] ?? "",
      objectId: extractObjectIdFromPayload(payload),
    );
  }
}