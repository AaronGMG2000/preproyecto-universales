import 'package:flutter/material.dart';

class AppFont {
  static const _fontLato = 'Lato';
  TextStyle titleText(BuildContext context) {
    return const TextStyle(
      fontSize: 32,
      fontFamily: _fontLato,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle newAccountText(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return TextStyle(
      fontSize: 16,
      fontFamily: _fontLato,
      color: isDark ? Colors.white : Colors.blue,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle newAccountText2(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return TextStyle(
      fontSize: 16,
      fontFamily: _fontLato,
      color: isDark ? const Color(0xFF5C5A5A) : Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle moreOptionsSigInText(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return TextStyle(
      fontSize: 14,
      fontFamily: _fontLato,
      color: isDark ? const Color(0xFF656565) : Colors.white70,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle inputText(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return TextStyle(
      fontSize: 15,
      fontFamily: _fontLato,
      color: !isDark
          ? const Color.fromRGBO(76, 76, 76, 1)
          : const Color.fromRGBO(253, 253, 253, 1),
      fontWeight: FontWeight.bold,
    );
  }
}
