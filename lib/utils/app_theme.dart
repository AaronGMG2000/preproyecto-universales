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
      scaffoldBackgroundColor: isDarkTheme
          ? AppColor.shared.mainBackgroundColorDark
          : AppColor.shared.mainBackgroundColor,
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
                ? AppColor.shared.inputBorderError
                : AppColor.shared.inputBorderErrorDark,
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
