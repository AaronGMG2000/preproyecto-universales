import 'package:encrypt/encrypt.dart';

Future<String> encryptText(String text) async {
  final key = Key.fromUtf8("12345678901234567890123456789012");
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  return encrypter.encrypt(text, iv: iv).base64;
}

Future<String> deencryptText(String text) async {
  final key = Key.fromUtf8("12345678901234567890123456789012");
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));
  return encrypter.decrypt64(text, iv: iv);
}
