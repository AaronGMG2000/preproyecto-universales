import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';

class Chanel {
  late String id;
  late List<dynamic> administradores;
  late List<Message> mensajes;
  late String descripcion;
  late String nombre;
  late Map<String, User> usuarios;
  late DateTime fechaCreacion;
  late User creador;
  late Color color = Colors.blue;

  Chanel({
    this.id = '',
    this.administradores = const [],
    this.mensajes = const [],
    this.descripcion = '',
    this.nombre = '',
    this.usuarios = const {},
  });

  static Future<Chanel> fromMap(String key, Map data) async {
    Chanel chanel = Chanel();
    chanel.id = key;
    chanel.administradores = data['administradores'] == null
        ? []
        : data['administradores'].values.toList();
    chanel.mensajes =
        data['mensajes'] == null ? [] : getMessages(data['mensajes']);
    chanel.mensajes.sort((a, b) => b.fechaEnvio.compareTo(a.fechaEnvio));
    chanel.descripcion =
        data['descripcion'] == null ? '' : data['descripcion'] as String;
    chanel.nombre = data['nombre'] == null ? '' : data['nombre'] as String;
    chanel.usuarios =
        data['usuarios'] == null ? {} : await getUsers(data['usuarios']);
    chanel.fechaCreacion = data['fecha_creacion'] == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(data['fecha_creacion'] as int);
    chanel.creador = chanel.usuarios[data['creador']]!;
    return chanel;
  }

  static Future<Chanel> fromMapOnly(String key, Map data) async {
    Chanel chanel = Chanel();
    chanel.id = key;
    chanel.administradores = [];
    chanel.mensajes =
        data['mensajes'] == null ? [] : getMessages(data['mensajes']);
    chanel.mensajes.sort((a, b) => b.fechaEnvio.compareTo(a.fechaEnvio));
    chanel.descripcion =
        data['descripcion'] == null ? '' : data['descripcion'] as String;
    chanel.nombre = data['nombre'] == null ? '' : data['nombre'] as String;
    chanel.nombre = chanel.nombre.isEmpty ? '-' : chanel.nombre;
    late String keyUser = chanel.mensajes.first.usuario;
    DatabaseEvent dataU = await AppDataBase.shared.getUserD(keyUser);
    User usuario = User();
    usuario.fromMap(keyUser, dataU.snapshot.value as Map);
    keyUser = data['creador'];
    DatabaseEvent dataU2 = await AppDataBase.shared.getUserD(keyUser);
    User usuario2 = User();
    usuario2.fromMap(keyUser, dataU2.snapshot.value as Map);
    chanel.usuarios = {usuario.id: usuario, usuario2.id: usuario2};
    chanel.fechaCreacion = data['fecha_creacion'] == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(data['fecha_creacion'] as int);
    chanel.creador =
        data['creador'] == null ? User() : chanel.usuarios[data['creador']]!;
    chanel.color = getRandomColor();
    return chanel;
  }
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

Future<Map<String, User>> getUsers(Map data) async {
  Map<String, User> users = {};
  for (String key in data.keys) {
    DatabaseEvent dataU = await AppDataBase.shared.getUserD(key);
    User newUser = User();
    newUser.fromMap(key, dataU.snapshot.value as Map);
    users[newUser.id] = newUser;
  }
  data.forEach((key, value) {});
  return users;
}

List<Message> getMessages(Map data) {
  List<Message> messages = [];
  for (int i = 0; i < data.keys.length; i++) {
    Message newMessage = Message.fromMap(
        data.keys.elementAt(i), data.values.elementAt(i) as Map);
    messages.add(newMessage);
  }
  return messages;
}
