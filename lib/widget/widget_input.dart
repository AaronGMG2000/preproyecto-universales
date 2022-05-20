import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_style.dart';

class InputIconText extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool readOnly;
  final String initialValue;
  final bool obscureText;
  final VoidCallback? onChange;
  final VoidCallback? onPressed;
  const InputIconText({
    this.hint = "",
    this.icon = Icons.close,
    this.readOnly = false,
    this.initialValue = "",
    this.obscureText = false,
    this.onChange,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<InputIconText> createState() => _InputIconTextState();
}

class _InputIconTextState extends State<InputIconText> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        initialValue: widget.initialValue,
        readOnly: widget.readOnly,
        onTap: widget.onChange,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20.0),
          filled: true,
          labelText: widget.hint,
          suffixIcon: IconButton(
            onPressed: widget.onPressed,
            icon:
                Icon(widget.icon, color: isDark ? Colors.white : Colors.black),
          ),
        ),
        style: AppStyle.shared.fonts.inputText(context),
      ),
    );
  }
}
