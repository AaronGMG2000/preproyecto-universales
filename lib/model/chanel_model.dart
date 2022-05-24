import 'package:firebase_database/firebase_database.dart';
import 'package:proyecto/model/message_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';

class Chanel {
  String id;
  List<User> administradores;
  List<Message> mensajes;
  String descripcion;
  String nombre;
  List<User> usuarios;
  late DateTime fechaCreacion;
  late User creador;

  Chanel({
    this.id = '',
    this.administradores = const [],
    this.mensajes = const [],
    this.descripcion = '',
    this.nombre = '',
    this.usuarios = const [],
  });

  static Future<Chanel> fromMap(String key, Map data) async {
    Chanel chanel = Chanel();
    chanel.id = key;
    chanel.administradores = await getUsers(data['administradores']);
    chanel.mensajes = await getMessages(data['mensajes']);
    chanel.descripcion = data['descripcion'] as String;
    chanel.nombre = data['nombre'] as String;
    chanel.usuarios = await getUsers(data['usuarios']);
    chanel.fechaCreacion =
        DateTime.fromMillisecondsSinceEpoch(data['fecha_creación'] as int);
    chanel.creador = await AppDataBase.shared.getUser(data['creador']);
    return chanel;
  }
}

Future<List<User>> getUsers(Map data) async {
  List<User> users = [];
  for (int i = 0; i < data.keys.length; i++) {
    User newUser = await AppDataBase.shared.getUser(data.keys.elementAt(i));
    users.add(newUser);
  }
  data.forEach((key, value) {});
  return users;
}

Future<List<Message>> getMessages(Map data) async {
  List<Message> messages = [];
  for (int i = 0; i < data.keys.length; i++) {
    Message newMessage = await Message.fromMap(
        data.keys.elementAt(i), data.values.elementAt(i) as Map);
    messages.add(newMessage);
  }
  return messages;
}
