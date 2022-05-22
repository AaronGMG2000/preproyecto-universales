import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/providers/auth_provider.dart';
import 'package:proyecto/widget/widget_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(100),
      child: ButtonTextGradient(
        height: 60,
        size: 24,
        onPressed: () {
          final authService = Provider.of<AuthService>(context, listen: false);
          authService.signOut();
        },
        text: "Cerrar Sesión",
      ),
    );
  }
}
