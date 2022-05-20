import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static int? _theme;
  Future<int> getDefaultLanguage() async {
    final int? theme =
        await AppPreferences.shared.getIntPreference('defaultTheme');
    if (theme != null) {
      return theme;
    } else {
      return 0;
    }
  }

  int get getTheme => _theme!;

  set setTheme(int theme) {
    _theme = theme;
    AppPreferences.shared.setPreference('defaultTheme', theme);
    notifyListeners();
  }
}
