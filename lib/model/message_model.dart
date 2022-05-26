class Message {
  String id;
  String texto;
  String type;
  late DateTime fechaEnvio;
  late String usuario;

  Message({
    this.id = '',
    this.texto = '',
    this.type = '',
  });

  static Message fromMap(String key, Map data) {
    Message message = Message();
    message.id = key;
    message.texto = data['texto'] == null ? '' : data['texto'] as String;
    message.type = data['type'] == null ? 'text' : data['type'] as String;
    message.fechaEnvio = data['fecha_envio'] == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(data['fecha_envio'] as int);
    message.usuario = data['usuario'] == null ? '' : data['usuario'] as String;
    return message;
  }
}
