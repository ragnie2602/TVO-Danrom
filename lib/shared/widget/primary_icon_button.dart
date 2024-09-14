import 'package:danrom/resources/colors.dart';
import 'package:flutter/material.dart';

class PrimaryIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final MaterialStateProperty<BorderSide?>? border;
  final Widget child;
  final Function() onPressed;
  final MaterialStatePropertyAll<OutlinedBorder?>? shape;

  const PrimaryIconButton(
      {super.key, this.backgroundColor, this.border, required this.child, required this.onPressed, this.shape});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(backgroundColor ?? AppColor.gray02),
            elevation: const MaterialStatePropertyAll(0.0),
            fixedSize: const MaterialStatePropertyAll(Size(0, 0)),
            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
            shape: shape ?? const MaterialStatePropertyAll(CircleBorder()),
            side: border),
        child: child);
  }
}
