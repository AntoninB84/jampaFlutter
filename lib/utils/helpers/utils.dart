import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

/// A utility class providing helper methods for logging and event transformation.
abstract class Utils{

  /// Logs a message with a timestamp to a file in the application's documents directory.
  /// Also logs the message to the console.
  static Future<void> logMessage(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/reminder_log.txt');
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp : $message\n', mode: FileMode.append);
    log(message);
  }

  /// Creates an event transformer that debounces events for the specified duration.
  static EventTransformer<Event> debounceTransformer<Event>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).switchMap(mapper);
    };
  }

}