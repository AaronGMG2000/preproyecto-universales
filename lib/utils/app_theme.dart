import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_color.dart';

class AppTheme {
  static ThemeData themeData(int typeTheme, bool isDark, BuildContext context) {
    bool isDarkTheme = false;
    switch (typeTheme) {
      case 0:
        isDarkTheme = isDark;
        break;
      case 1:
        isDarkTheme = false;
        break;
      default:
        isDarkTheme = true;
        break;
    }
    return ThemeData(
      primaryColor: isDarkTheme
          ? AppColor.shared.mainColorDark
          : AppColor.shared.mainColor,
      textTheme: TextTheme(
        headline1: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
        headline2: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
        bodyText2: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
        bodyText1: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
      ),
      scaffoldBackgroundColor: isDarkTheme
          ? AppColor.shared.mainBackgroundColorDark
          : AppColor.shared.mainBackgroundColor,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(Colors.blue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDarkTheme
            ? AppColor.shared.inputBackgroundDark
            : AppColor.shared.inputBackground,
        labelStyle: TextStyle(
          color: isDarkTheme
              ? AppColor.shared.inputPlaceholderDark
              : AppColor.shared.inputPlaceholder,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
              color: isDarkTheme
                  ? AppColor.shared.inputBorderFocusedDark
                  : AppColor.shared.inputBorderFocused,
              width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: isDarkTheme
                ? AppColor.shared.inputBorderDark
                : AppColor.shared.inputBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: isDarkTheme
                ? AppColor.shared.inputBorderErrorDark
                : AppColor.shared.inputBorderError,
          ),
        ),
      ),
      iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : AppColor.shared.mainColor),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: isDarkTheme
                ? AppColor.shared.inputBorderDark
                : AppColor.shared.inputBorder,
            //onPrimary: Colors.green,
            onSurface: Colors.yellow,
          ),
      hintColor: isDarkTheme
          ? AppColor.shared.inputPlaceholderDark
          : AppColor.shared.inputPlaceholder,
    );
  }
}
