import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  static bool _login = false;

  bool get getLogin => _login;

  set setLogin(bool login) {
    _login = login;
    notifyListeners();
  }
}
