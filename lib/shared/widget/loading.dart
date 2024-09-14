import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/colors.dart';

class Loading extends StatelessWidget {
  const Loading(
      {super.key, this.backgroundColor, this.size = 50, this.spinnerColor, this.spinnerSize = 50, this.message});

  final Color? backgroundColor;
  final Color? spinnerColor;
  final double size;
  final double spinnerSize;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            constraints: BoxConstraints(minWidth: context.screenWidth * 0.5, maxWidth: context.screenWidth * 0.75),
            color: AppColor.transparent,
            child:
                Lottie.asset('assets/animations/card.json', width: context.screenWidth * 0.6, fit: BoxFit.scaleDown)));
  }
}
