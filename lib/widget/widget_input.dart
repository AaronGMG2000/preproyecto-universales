import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_style.dart';

class InputIconText extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool readOnly;
  final String initialValue;
  final bool obscureText;
  final VoidCallback? onPressed;
  final Function(String? value)? onSaved;
  final FormFieldValidator? validator;
  const InputIconText({
    this.hint = "",
    this.icon = Icons.close,
    this.readOnly = false,
    this.initialValue = "",
    this.obscureText = false,
    this.onPressed,
    this.onSaved,
    this.validator,
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
        onSaved: widget.onSaved,
        readOnly: widget.readOnly,
        validator: widget.validator,
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
