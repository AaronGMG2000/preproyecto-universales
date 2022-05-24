import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/model/user_model.dart';
import 'package:proyecto/pages/splash_page/splash_page.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/utils/app_color.dart';
import 'package:proyecto/utils/app_firebase.dart';
import 'package:proyecto/widget/widget_button.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return StreamBuilder(
      stream: AppDataBase.shared.getChanelInUser(widget.user.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final DatabaseEvent data = snapshot.data as DatabaseEvent;
          return FutureBuilder(
            future: getChanels(data.snapshot.value as dynamic),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: isDark
                      ? AppColor.shared.backgroundHomeDark
                      : AppColor.shared.backgroundHome,
                  appBar: AppBar(
                    backgroundColor: isDark
                        ? AppColor.shared.backgroundAppBarDark
                        : AppColor.shared.backgroundAppBar,
                    title: Row(
                      children: const [
                        Icon(Icons.menu),
                        SizedBox(width: 30),
                        Text('UniChat'),
                      ],
                    ),
                  ),
                  body: Container(
                    padding: const EdgeInsets.all(100),
                    child: ButtonTextGradient(
                      height: 60,
                      size: 24,
                      onPressed: () {
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        authService.signOut();
                      },
                      text: "Cerrar Sesión",
                    ),
                  ),
                );
              } else {
                return const SplashPage();
              }
            },
          );
        } else {
          return const SplashPage();
        }
      },
    );
  }

  Future<List<Chanel>> getChanels(Map data) async {
    List<Chanel> chanels = [];
    for (int i = 0; i < data.keys.length; i++) {
      final DatabaseEvent chanel =
          await AppDataBase.shared.getChanel(data.keys.elementAt(i) as String);

      chanels.add(await Chanel.fromMap(
          data.keys.elementAt(i), chanel.snapshot.value as Map));
    }
    return chanels;
  }
}
