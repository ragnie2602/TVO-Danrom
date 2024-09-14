// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class BottomNavigationIcon extends StatelessWidget {
//   final String icon;
//   final double size;
//   final Gradient gradient;

//   BottomNavigationIcon({required this.icon, required this.size, required this.gradient});

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (Rect bounds) {
//         return gradient.createShader(bounds);
//       },
//       child: BottomNavigationIcon(
//         child: SvgPicture(
//           icon,
//           size: size,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
