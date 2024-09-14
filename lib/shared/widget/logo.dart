import 'package:danrom/resources/themes.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool isUppercase;
  final double size;
  final String text;
  final TextStyle? style;

  const Logo({super.key, this.isUppercase = true, this.style, this.text = 'Danrom', this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Text(isUppercase ? text.toUpperCase() : text,
        style: style ?? AppTextTheme.gradientTextStyle.copyWith(fontSize: size, letterSpacing: 1));
  }
}
