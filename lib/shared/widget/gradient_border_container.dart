import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final List<Color> gradientColors;

  const GradientBorderContainer({super.key, required this.child, this.decoration, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: decoration,
          child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ).createShader(bounds);
              },
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0), // Đặt màu và độ rộng của viền
                    borderRadius: BorderRadius.circular(10.0), // Đặt borderRadius
                  ),
                  padding: const EdgeInsets.all(4),
                  child: child)),
        ),
        Container(padding: const EdgeInsets.all(4), child: child)
      ],
    );
  }
}
