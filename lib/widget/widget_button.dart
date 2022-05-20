import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_color.dart';

class ButtonIcon extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double size;
  final String urlImage;
  const ButtonIcon({
    Key? key,
    this.icon,
    required this.onPressed,
    this.width = 40,
    this.height = 40,
    this.size = 40,
    this.urlImage = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isDark
            ? AppColor.shared.buttonIconColorDark
            : AppColor.shared.buttonIconColor,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: icon != null
            ? Icon(
                icon,
                size: size,
              )
            : Image.asset(
                urlImage,
                color: Colors.white,
                height: size,
              ),
      ),
    );
  }
}

class ButtonTextGradient extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double size;
  final String text;
  final Color color1;
  final Color color2;
  const ButtonTextGradient({
    Key? key,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 40,
    this.size = 16,
    this.text = "",
    this.color1 = const Color(0xFFb514de),
    this.color2 = const Color(0xFFce27a2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: size),
        ),
      ),
    );
  }
}
