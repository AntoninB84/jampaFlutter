extension StringExtension on String {
  /// Capitalize the first letter of the given string
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}