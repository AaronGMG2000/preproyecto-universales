import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userfromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
    );
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userfromFirebase);
  }

  Future<void> createGeneralChanel(User user) async {
    bool create = await AppDataBase.shared
        .newChanel("General", "General", "Grupo general", user);
    if (create) {
      await AppDataBase.shared.newMessage(
          "General", "Bienvenido a la comunidad", user.id, "notification");
      await AppDataBase.shared
          .addUserToChanel("General", "General", user.id, user.displayName);
    } else {
      await AppDataBase.shared
          .addUserToChanel("General", "General", user.id, user.displayName);
    }
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final auth.OAuthCredential credential =
        auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return _userfromFirebase(user);
  }

  Future<User?> signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
        apiKey: 'H31JlrCMKPuRIHXJCAdcLu0Ts',
        apiSecretKey: 'rVVC37WNZ90XvihipgJDcCwE0O7BjxwxcVfPZyCePtlUIb71jM',
        redirectURI: 'flutter-twitter-login://');
    final lgoinResult = await twitterLogin.login();
    final twitterAuthCredentials = auth.TwitterAuthProvider.credential(
        accessToken: lgoinResult.authToken!,
        secret: lgoinResult.authTokenSecret!);
    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(twitterAuthCredentials)).user;
    return _userfromFirebase(user);
  }

  Future<User?> sigInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return _userfromFirebase(user);
  }

  Future<User?> createUserWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final auth.OAuthCredential credential =
        auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    await createGeneralChanel(_userfromFirebase(user)!);
    return _userfromFirebase(user);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userfromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    await createGeneralChanel(_userfromFirebase(credential.user)!);
    return _userfromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
