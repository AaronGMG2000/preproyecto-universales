import 'package:firebase_database/firebase_database.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:uuid/uuid.dart';

class AppDataBase {
  AppDataBase._privateConstructor();
  static final AppDataBase shared = AppDataBase._privateConstructor();
  final database = FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> userStrem(String id) =>
      FirebaseDatabase.instance.ref().child('Usuarios').child(id).onValue;

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

  Future<void> setChange(User user) async {
    await database.child('Usuarios').child(user.id).update({'change': true});
  }

  Future<User> getUser(String id) async {
    final user = database.child('Usuarios/$id');
    late User retorno = User();
    await user.get().then((value) {
      if (value.value != null) {
        final data = Map<String, dynamic>.from(value.value as dynamic);
        Map<String, dynamic> canales = {};
        if (data['Canales'] != null) {
          canales = Map<String, dynamic>.from(data['Canales']);
        }
        retorno = User(
          id: id,
          email: data['correo'],
          displayName: data['nombre'],
          photoUrl: data['urlImage'],
          change: data['change'],
          canales: canales,
        );
      }
    });
    return retorno;
  }

  Future<String> addUser(User user) async {
    String message = "Usuario agregado con exito";
    try {
      final userF = database.child("Usuarios/${user.id}");
      await userF.get().then((value) {
        if (value.value == null) {
          userF.set({
            'nombre': user.displayName,
            'correo': user.email,
            'urlImage': user.photoUrl,
            'estado': true,
            'change': false,
          });
        }
      });
    } catch (e) {
      message = "Error al agregar el usuario";
    }
    return message;
  }

  Future<String> addUserToChanel(
      String chanel, String nameChanel, User user) async {
    String message = "Usuario agregado al canal con exito";
    try {
      await addUser(user);
      await database
          .child("Canales")
          .child(chanel)
          .child('usuarios')
          .child(user.id)
          .set(user.id);
      await database
          .child("Usuarios")
          .child(user.id)
          .child("Canales/$chanel")
          .set(nameChanel);
    } catch (e) {
      message = "Error al agregar el usuario al canal";
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

  Stream<DatabaseEvent> getChanelInUser(String userId) =>
      database.child("Usuarios").child(userId).child("Canales").onValue;

  Future<DatabaseEvent> getChanel(String chanel) async {
    return (await database.child("Canales").child(chanel).once());
  }

  Stream<DatabaseEvent> getChanels() => database.child("Canales").onValue;

  Stream<DatabaseEvent> getUsers(String chanel) =>
      database.child("Usuarios").onValue;

  Stream<DatabaseEvent> getAdministrators(String chanel) =>
      database.child("Canales").child(chanel).child('administradores').onValue;

  Stream<DatabaseEvent> getMessages(String chanel) => database
      .child("Canales")
      .child(chanel)
      .child('mensajes')
      .orderByChild('fecha_envio')
      .onValue;

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
