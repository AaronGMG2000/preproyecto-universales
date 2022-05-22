import 'package:firebase_database/firebase_database.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:uuid/uuid.dart';

class AppDataBase {
  AppDataBase._privateConstructor();
  static final AppDataBase shared = AppDataBase._privateConstructor();
  final database = FirebaseDatabase.instance.ref();

  Future<void> newMessage(
      String chanel, String message, String userId, String type) async {
    Uuid uuid = const Uuid();
    final id = uuid.v4();
    final messageData = {
      'texto': message,
      'usuario': userId,
      'type': type,
      'fecha_envio': DateTime.now().millisecondsSinceEpoch,
    };
    await database
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .child(id)
        .set(messageData);
  }

  Future<bool> newChanel(
      String id, String chanelName, String description, User user) async {
    final chanel = database.child('Canales/$id');
    late bool response = false;
    await chanel.get().then((value) {
      if (value.value == null) {
        chanel.set({
          'nombre': chanelName,
          'descripcion': description,
          'fecha_creación': DateTime.now().millisecondsSinceEpoch,
          'creador': user.id,
          'administradores': {user.id: user.id},
          'usuarios': {user.id: user.id},
        });
        response = true;
      }
    });
    return response;
  }

  Future<String> addUserToChanel(String chanel, String nameChanel,
      String userId, String displayName) async {
    String message = "Usuario agregado con exito";
    try {
      await database
          .child("Canales")
          .child(chanel)
          .child('usuarios')
          .child(userId)
          .set(displayName);
      await database
          .child("Usuarios")
          .child(userId)
          .child(chanel)
          .set(nameChanel);
    } catch (e) {
      message = "Error al agregar el usuario";
    }
    return message;
  }

  Future<String> addAdministratorToChanel(String chanel, String userId) async {
    String message = "Usuario agregado con exito";
    try {
      await database
          .child("Canales")
          .child(chanel)
          .child('administradores')
          .child(userId)
          .set(userId);
    } catch (e) {
      message = "Error al agregar el usuario";
    }
    return message;
  }

  Future<dynamic> getUserInChanel(String chanel, String userId) async {
    return await database
        .child("Canales")
        .child(chanel)
        .child('usuarios')
        .child(userId)
        .once();
  }

  Future<dynamic> getChanelInUser(String userId) async {
    return await database.child("Usuarios").child(userId).once();
  }

  Future<Map<String, dynamic>> getChanel(String chanel) async {
    return (await database.child("Canales").child(chanel).once())
        as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getChanels(String chanel) async {
    return (await database.child("Canales").once()) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUsers(String chanel) async {
    return (await database.child("Usuarios").once()) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAdministrators(String chanel) async {
    return (await database
        .child("Canales")
        .child(chanel)
        .child('administradores')
        .once()) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMessages(String chanel) async {
    return (await database
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .orderByChild('fecha_envio')
        .once()) as Map<String, dynamic>;
  }

  Future<void> deleteChanel(String chanel) async {
    await database.child("Canales").child(chanel).remove();
  }

  Future<void> deleteUserInChanel(String chanel, String userId) async {
    await database
        .child("Canales")
        .child(chanel)
        .child('usuarios')
        .child(userId)
        .remove();
  }

  Future<void> deleteAdministratorInChanel(String chanel, String userId) async {
    await database
        .child("Canales")
        .child(chanel)
        .child('administradores')
        .child(userId)
        .remove();
  }

  Future<void> deleteMessage(String chanel, String messageId) async {
    await database
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .child(messageId)
        .remove();
  }

  Future<void> updateMessage(
      String chanel, String messageId, String message) async {
    await database
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .child(messageId)
        .update({'texto': message});
    await database
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .child(messageId)
        .update({'fecha_edicion': message});
  }
}
