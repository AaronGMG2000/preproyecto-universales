import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/create_password_page/create_pasword_page.dart';
import 'package:proyecto/pages/home_page/home_page.dart';
import 'package:proyecto/pages/login_page/login_page.dart';
import 'package:proyecto/pages/splash_page/splash_page.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_firebase.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return const LoginPage();
            }
            return StreamBuilder(
              stream: AppDataBase.shared.userStrem(user.id),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  final DatabaseEvent data = snapshot.data as DatabaseEvent;
                  if (data.snapshot.value != null) {
                    User user = User();
                    user.fromMap(data.snapshot.key as String,
                        data.snapshot.value as dynamic);
                    if (user.change) {
                      return HomePage(user: user);
                    } else {
                      return const CreatePasswordPage();
                    }
                  } else {
                    return const SplashPage();
                  }
                } else {
                  return const SplashPage();
                }
              },
            );
          }
          return const SplashPage();
        },
      ),
    );
  }
}
