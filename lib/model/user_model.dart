class User {
  String id;
  String displayName;
  String email;
  String photoUrl;
  bool change;
  bool estado;
  Map<String, dynamic> canales;

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
    displayName = data['nombre'] as String;
    email = data['correo'] as String;
    photoUrl = data['urlImage'] as String;
    change = data['change'] as bool;
    estado = data['estado'] as bool;
    canales = Map<String, dynamic>.from(data['canales'] as dynamic);
  }
}
