import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';

class Message {
  String id;
  String texto;
  String type;
  late DateTime fechaEnvio;
  late User usuario;

  Message({
    this.id = '',
    this.texto = '',
    this.type = '',
  });

  static Future<Message> fromMap(String key, Map data) async {
    Message message = Message();
    message.id = key;
    message.texto = data['texto'] as String;
    message.type = data['type'] as String;
    message.fechaEnvio =
        DateTime.fromMillisecondsSinceEpoch(data['fecha_envio'] as int);
    message.usuario = await AppDataBase.shared.getUser(key);
    return message;
  }
}
