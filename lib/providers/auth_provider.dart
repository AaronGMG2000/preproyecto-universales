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
      photoUrl: user.photoURL ?? '',
    );
  }

  Stream<User?>? get user =>
      _firebaseAuth.authStateChanges().map(_userfromFirebase);

  Future<void> createGeneralChanel(User user) async {
    bool create = await AppDataBase.shared
        .newChanel("General", "General", "Grupo general", user);
    if (create) {
      await AppDataBase.shared.newMessage(
          "General", "Bienvenido a la comunidad", user.id, "notification");
      await AppDataBase.shared.addUserToChanel("General", "General", user);
    } else {
      await AppDataBase.shared.addUserToChanel("General", "General", user);
    }
  }

  Future<void> changePassword(String password) async {
    await _firebaseAuth.currentUser!.updatePassword(password);
    await AppDataBase.shared
        .setChange(_userfromFirebase(_firebaseAuth.currentUser)!);
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final auth.OAuthCredential credential =
        auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    await createGeneralChanel(_userfromFirebase(user)!);
    await AppDataBase.shared.setOnline(_userfromFirebase(user)!, true);
    if (user!.email == null) {
      await AppDataBase.shared
          .setChange(_userfromFirebase(_firebaseAuth.currentUser)!);
    }
    return await AppDataBase.shared.getUser(user.uid);
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
    await createGeneralChanel(_userfromFirebase(user)!);

    await AppDataBase.shared.setOnline(_userfromFirebase(user)!, true);
    if (user!.email == null) {
      await AppDataBase.shared
          .setChange(_userfromFirebase(_firebaseAuth.currentUser)!);
    }
    return await AppDataBase.shared.getUser(user.uid);
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
    await createGeneralChanel(_userfromFirebase(user)!);
    await AppDataBase.shared.setOnline(_userfromFirebase(user)!, true);
    if (user!.email == null) {
      await AppDataBase.shared
          .setChange(_userfromFirebase(_firebaseAuth.currentUser)!);
    }
    return await AppDataBase.shared.getUser(user.uid);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    String id = _firebaseAuth.currentUser!.uid;

    await AppDataBase.shared
        .setOnline(_userfromFirebase(_firebaseAuth.currentUser)!, true);
    return await AppDataBase.shared.getUser(id);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
    String photoUrl,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    await credential.user?.updatePhotoURL(photoUrl);
    await createGeneralChanel(_userfromFirebase(_firebaseAuth.currentUser)!);
    await AppDataBase.shared
        .setChange(_userfromFirebase(_firebaseAuth.currentUser)!);
    return await AppDataBase.shared.getUser(_firebaseAuth.currentUser!.uid);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
