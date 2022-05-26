import 'package:flutter/material.dart';
import 'package:proyecto/utils/app_color.dart';

class ModalBottom extends StatelessWidget {
  final String? title;
  final Widget content;

  const ModalBottom({required this.content, this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: isDark ? AppColor.shared.backgroundModalDark : Colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * .9,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.clear,
                    color: isDark ? Colors.white : Colors.black),
              ),
            ),
            Text(
              title ?? "",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black, fontSize: 28),
            ),
            Expanded(child: SizedBox(width: double.infinity, child: content))
          ],
        ),
      ),
    );
  }
}

class ModalEditBottom extends StatelessWidget {
  final String? title;
  final Widget content;

  const ModalEditBottom({required this.content, this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: isDark ? AppColor.shared.backgroundModalDark : Colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * .2,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.clear,
                        color: isDark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            Text(
              title ?? "",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(child: SizedBox(width: double.infinity, child: content))
          ],
        ),
      ),
    );
  }
}
