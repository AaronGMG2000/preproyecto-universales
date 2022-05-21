import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/home_page/home_page.dart';
import 'package:proyecto/pages/login_page/login_page.dart';
import 'package:proyecto/pages/splash_page/splash_page.dart';
import 'package:proyecto/providers/auth_provider.dart';

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
            return const HomePage();
          }
          return const SplashPage();
        },
      ),
    );
  }
}
