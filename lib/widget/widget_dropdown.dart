import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_color.dart';

class Dropdownbutton1 extends StatefulWidget {
  final List<String> items;
  final Function(dynamic) onChanged;
  final double padding;
  final Function getValue;
  final String initialValue;
  const Dropdownbutton1({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.getValue,
    required this.initialValue,
    this.padding = 30,
  }) : super(key: key);

  @override
  Dropdownbutton1State createState() => Dropdownbutton1State();
}

class Dropdownbutton1State extends State<Dropdownbutton1> {
  late String? selectedItem = widget.initialValue;

  Future<void> getDefault() async {
    Future.delayed(Duration.zero, () async {
      dynamic value = await widget.getValue();
      setState(() {
        selectedItem = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDefault();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black,
              width: 3,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.all(5),
        ),
        value: selectedItem,
        dropdownColor:
            isDark ? AppColor.shared.backgroundSettinsDark : Colors.white,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (item) {
          setState(() {
            selectedItem = item;
            widget.onChanged(item);
          });
        },
      ),
    );
  }
}
