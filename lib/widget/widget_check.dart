import 'package:flutter/material.dart';

class CheckboxText extends StatefulWidget {
  final Function(bool) onChanged;
  final String text;
  const CheckboxText({
    Key? key,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  CheckboxTextState createState() => CheckboxTextState();
}

class CheckboxTextState extends State<CheckboxText> {
  bool rememberMe = false;
  void _onRememberMeChanged(bool? newValue) => setState(() {
        rememberMe = newValue!;
        widget.onChanged(rememberMe);
      });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: _onRememberMeChanged,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
