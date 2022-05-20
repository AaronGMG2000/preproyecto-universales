import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._privateConstructor();
  static final AppPreferences shared = AppPreferences._privateConstructor();

  setPreference(String key, value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) prefs.setBool(key, value);
    if (value is String) prefs.setString(key, value);
    if (value is int) prefs.setInt(key, value);
    if (value is double) prefs.setDouble(key, value);
  }

  Future<dynamic> _getPreference(String key) async =>
      (await SharedPreferences.getInstance()).get(key);

  Future<bool?> getBoolPreference(String key) async =>
      await _getPreference(key);
  Future<int?> getIntPreference(String key) async => await _getPreference(key);

  Future<String?> getStringPreference(String key) async =>
      await _getPreference(key);
}
