import 'package:flutter/material.dart';

class CustomAlignedText extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final EdgeInsets padding;
  final TextStyle? style;

  const CustomAlignedText({
    super.key,
    required this.text,
    this.alignment = Alignment.topLeft,
    this.padding = const EdgeInsets.only(left: 8.0),
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: style ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
