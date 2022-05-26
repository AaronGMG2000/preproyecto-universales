import 'dart:math';

import 'package:flutter/material.dart';

class User {
  late String id;
  late String displayName;
  late String email;
  late String photoUrl;
  late bool change;
  late bool estado;
  late Color color = Colors.blue;
  late Map<String, dynamic> canales;

  User({
    this.id = '',
    this.displayName = '',
    this.email = '',
    this.photoUrl = '',
    this.change = true,
    this.estado = true,
    this.canales = const {},
  });

  fromMap(String key, Map data) {
    id = key;
    displayName = data['nombre'] == null ? '-' : data['nombre'] as String;
    displayName = displayName.isEmpty ? '-' : displayName;
    email = data['correo'] == null ? '' : data['correo'] as String;
    photoUrl = data['urlImage'] == null ? '' : data['urlImage'] as String;
    change = data['change'] == null ? false : data['change'] as bool;
    estado = data['estado'] == null ? false : data['estado'] as bool;
    canales = data['canales'] == null
        ? {}
        : Map<String, dynamic>.from(data['canales'] as dynamic);
    color = getRandomColor();
  }

  Color getRandomColor() {
    final List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
