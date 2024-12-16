import 'package:flutter/material.dart';

class btn extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color bg_color;
  final Color textcolor;
  final double fontSize;

  const btn({
    super.key,
    required this.text,
    required this.onPressed,
    required this.bg_color,
    required this.textcolor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(bg_color),
            foregroundColor: WidgetStatePropertyAll(textcolor)),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
