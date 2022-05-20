import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_color.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: AppColor.shared.mainBackgroundColorDark,
          child: Center(child: Image.asset("assets/images/splash_image.png")),
        ),
      ),
    );
  }
}
