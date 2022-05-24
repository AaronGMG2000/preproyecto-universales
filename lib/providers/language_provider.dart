import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static Locale? _locale;
  Future<Locale> getDefaultLanguage() async {
    final int? number =
        await AppPreferences.shared.getIntPreference('defaultLanguage');
    switch (number) {
      case 2:
        return const Locale('es', '');
      case 1:
        return const Locale('en', '');
      default:
        return Locale(Platform.localeName.substring(0, 2), '');
    }
  }

  Locale get getLang => _locale!;

  set setLanguage(int? lang) {
    switch (lang) {
      case 2:
        _locale = const Locale('es', '');
        break;
      case 1:
        _locale = const Locale('en', '');
        break;
      default:
        _locale = Locale(Platform.localeName.substring(0, 2), '');
        break;
    }
    AppPreferences.shared.setPreference('defaultLanguage', lang);
    notifyListeners();
  }
}
