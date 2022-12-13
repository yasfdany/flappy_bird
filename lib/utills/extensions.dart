extension StringExtension on String {
  String get fileName => split("/").last;
}
