import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

void alertBottom(String text, Color color, int duration, context) {
  Flushbar(
    message: text,
    backgroundColor: color,
    duration: Duration(milliseconds: duration),
    flushbarPosition: FlushbarPosition.BOTTOM,
  ).show(context);
}
