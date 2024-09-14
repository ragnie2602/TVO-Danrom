import 'dart:async';

import 'package:danrom/config/routes.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;
  LocalDataAccess localDataAccess = getIt.get();

  @override
  void initState() {
    super.initState();

    timeOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Stack(children: [
          Center(child: SvgPicture.asset(Assets.icSplash, width: context.screenWidth * 118.86 / 393)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                        ).createShader(bounds),
                    child: const Text('Danrom', style: AppTextTheme.robotoFlexBoldMedium, textAlign: TextAlign.center)),
                const Text(' - Decision Making', style: AppTextTheme.robotoFlexBoldMedium)
              ]),
              const SizedBox(height: 8),
              const Text('Something different than funny random', style: AppTextTheme.interMedium11),
              const SizedBox(height: 32),
              GradientProgressIndicator(
                  progress: progress / 3, colors: const [AppColor.primaryColor1, AppColor.primaryColor2])
            ]),
          )
        ]));
  }

  timeOut() async {
    Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          progress += progress < 1.6
              ? 0.002
              : progress < 2.2
                  ? 0.0005
                  : 0.0008;
          if (progress >= 3) {
            t.cancel();
            Navigator.popAndPushNamed(
                context, localDataAccess.getLanguage() == null ? AppRoute.language : AppRoute.home);
          }
        });
      }
    });
  }
}

class GradientProgressIndicator extends StatelessWidget {
  final double progress;
  final List<Color> colors;

  const GradientProgressIndicator({super.key, required this.progress, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ).createShader(bounds);
      },
      child: Container(
        height: 5,
        width: double.infinity,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
