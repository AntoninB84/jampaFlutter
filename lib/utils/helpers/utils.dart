import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class Utils{

  static Future<void> logMessage(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/alarm_log.txt');
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp : $message\n', mode: FileMode.append);
    log(message);
  }

}