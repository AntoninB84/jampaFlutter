import 'package:collection/collection.dart';

extension StringExtension on String {
  /// Capitalize the first letter of the given string
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}