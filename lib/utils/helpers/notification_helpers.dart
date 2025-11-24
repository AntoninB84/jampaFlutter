import 'package:alarm/alarm.dart';
import 'package:jampa_flutter/utils/enums/object_type_enum.dart';

import '../local_notification_manager.dart';

/// A class representing the payload of a notification or alarm.
/// Includes optional IDs for notification and alarm, as well as
/// required fields for object type and object ID.
///
/// Used for managing and extracting information from notifications and alarms.
class NotificationPayload {

  /// Optional ID of the notification if applicable.
  int? notificationId;

  /// Optional ID of the alarm if applicable.
  int? alarmId;

  /// The type of the object associated with the notification or alarm.
  /// This corresponds to predefined object types in the application that
  /// can be retrieved through [ObjectTypeEnum].
  String objectType;

  /// The ID of the object associated with the notification or alarm.
  String? objectId;

  NotificationPayload({
    this.notificationId,
    this.alarmId,
    required this.objectType,
    required this.objectId,
  });
}

/// A helper class for managing notifications and alarms.
/// Provides static methods to fetch pending notifications and alarms,
/// extract values from payloads, and create [NotificationPayload] instances.
abstract class NotificationHelpers {

  /// Fetches all pending notifications and alarms, returning a list of
  /// [NotificationPayload] instances representing each pending item.
  static Future<List<NotificationPayload>> fetchPendingPayloads() async {

    // Fetch pending notifications from the local notification manager.
    final pendingNotifications = await LocalNotificationManager().flutterLocalNotificationsPlugin.pendingNotificationRequests();
    // Fetch pending alarms from the alarm package.
    final pendingAlarms = await Alarm.getAlarms();

    // Combine both notifications and alarms into a single list of payloads.
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

    // Return the combined list of pending notification payloads.
    return pendingNotificationPayload;
  }

  /// Extracts key-value pairs from a given payload string.
  /// The payload is expected to be in the format "key1=value1?key2=value2".
  /// Returns a map of extracted key-value pairs.
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

  /// Extracts the object ID from a given payload string.
  /// Returns the object ID if present, otherwise returns null.
  static String? extractObjectIdFromPayload(String payload){
    Map<String, String> values = extractPayloadValues(payload);
    if(values.containsKey("objectId")){
      return values["objectId"];
    }
    return null;
  }

  /// Creates a [NotificationPayload] instance from the given parameters.
  /// Accepts optional alarm and notification IDs, along with a required payload string.
  /// Extracts necessary values from the payload to populate the [NotificationPayload].
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