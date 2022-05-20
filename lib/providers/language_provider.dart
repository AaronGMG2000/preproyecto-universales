import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static Locale? _locale;
  Future<Locale> getDefaultLanguage() async {
    final String? saveLang =
        await AppPreferences.shared.getStringPreference('defaultLanguage');
    if (saveLang != null) {
      return Locale(saveLang, '');
    } else {
      _locale = Locale(Platform.localeName.substring(0, 2), '');
      return _locale!;
    }
  }

  Locale get getLang => _locale!;

  set setLanguage(Locale lang) {
    _locale = lang;
    AppPreferences.shared.setPreference('defaultLanguage', lang.languageCode);
    notifyListeners();
  }
}
