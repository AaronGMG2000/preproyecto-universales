import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/pages/home_page/home_page.dart';
import 'package:proyecto/pages/login_page/login_page.dart';
import 'package:proyecto/providers/login_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
        ],
        child:
            Consumer(builder: (context, LoginProvider loginProvider, widget) {
          return loginProvider.getLogin
              ? const Center(child: HomePage())
              : const Center(child: LoginPage());
        }),
      ),
    );
  }
}
