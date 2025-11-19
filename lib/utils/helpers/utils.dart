import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class Utils{

  static Future<void> logMessage(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/reminder_log.txt');
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp : $message\n', mode: FileMode.append);
    log(message);
  }

  static EventTransformer<Event> debounceTransformer<Event>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).switchMap(mapper);
    };
  }

}