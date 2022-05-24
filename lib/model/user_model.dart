class User {
  String id;
  String displayName;
  String email;
  String photoUrl;
  bool change;
  Map<String, dynamic> canales;

  User({
    this.id = '',
    this.displayName = '',
    this.email = '',
    this.photoUrl = '',
    this.change = true,
    this.canales = const {},
  });
}
