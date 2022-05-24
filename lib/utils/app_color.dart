import 'package:flutter/material.dart';

class AppColor {
  AppColor._privateConstructor();

  static final AppColor shared = AppColor._privateConstructor();

  final mainColor = const Color(0xFF1D1D1D);
  final mainColorDark = Colors.white;
  final mainBackgroundColorDark = const Color(0xFF111111);
  final mainBackgroundColor = const Color(0xFFfafafa);
  final inputBackgroundDark = const Color(0xFF505050);
  final inputBackground = const Color(0xFFFFFFFF);
  final inputPlaceholderDark = Colors.white;
  final inputPlaceholder = const Color.fromRGBO(76, 76, 76, 1);
  final inputBorderFocusedDark = const Color(0xFF9615b8);
  final inputBorderFocused = const Color(0xFF9615b8);
  final inputBorderDark = const Color(0xFF1f1f1f);
  final inputBorder = const Color(0xFF1f1f1f);
  final inputBorderErrorDark = Colors.white;
  final inputBorderError = Colors.black;
  final buttonIconColor = Colors.blue;
  final buttonIconColorDark = Colors.amber.shade800;
  final custoAppBarColor = const Color.fromARGB(255, 54, 54, 54);
  final custoAppBarColorDark = const Color.fromARGB(255, 34, 34, 34);
  final backgroundHeaderSettings = Colors.blue;
  final backgroundHeaderSettingsDark = const Color.fromRGBO(17, 17, 17, 1);
  final backgroundSettins = Colors.white;
  final backgroundSettinsDark = const Color.fromRGBO(29, 29, 29, 1);
}
