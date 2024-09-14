import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:danrom/app_localization.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/app_ad.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/wheel/cubit/wheel_cubit.dart';
import 'package:danrom/view/wheel/wheel_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Wheel extends StatefulWidget {
  const Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  final AppAd appAd = getIt.get();
  late List<dynamic> colors;
  final WheelCubit cubit = getIt.get();
  late int duration;
  LinearGradient? gradient;
  List<int> isChosen = [];
  bool isFlying = false;
  late bool isLoop;
  final LocalDataAccess localDataAccess = getIt.get();
  String result = '';
  final selected = StreamController<int>.broadcast();
  int tmp = 0;
  late List<String> wheelChoices;
  late String wheelSkin;

  @override
  void initState() {
    super.initState();

    duration = localDataAccess.getWheelDuration();
    isLoop = localDataAccess.getWheelLoop();
    wheelChoices = localDataAccess.getWheelChoices();
    wheelSkin = localDataAccess.getWheelSkin();
    colors = wheelSkins[wheelSkin]?['colors'] ?? [];
    gradient = wheelSkins[wheelSkin]?['gradient'];
  }

  @override
  Widget build(BuildContext context) {
    log(isChosen.toString());
    return Scaffold(
        backgroundColor: AppColor.white,
        body: BlocProvider.value(
            value: cubit,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100), color: AppColor.purple01.withOpacity(0.12)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: BlocBuilder<WheelCubit, WheelState>(
                                buildWhen: (previous, current) => current is WheelChangeQuestion,
                                builder: (context, state) {
                                  return Text(state is WheelChangeQuestion ? state.question : "Wanna hangout?",
                                      style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.purple01));
                                })),
                        SizedBox(height: context.screenWidth * 32 / 393),
                        Text(result, style: AppTextTheme.poppinsMedium32),
                        SizedBox(height: context.screenWidth * 40 / 393),
                        Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  blurRadius: 11, color: AppColor.black.withOpacity(0.1), offset: const Offset(-1, 5)),
                              BoxShadow(
                                  blurRadius: 20,
                                  color: AppColor.black.withOpacity(0.09),
                                  offset: const Offset(-5, 19)),
                              BoxShadow(
                                  blurRadius: 27,
                                  color: AppColor.black.withOpacity(0.05),
                                  offset: const Offset(-12, 43)),
                              BoxShadow(
                                  blurRadius: 31,
                                  color: AppColor.black.withOpacity(0.01),
                                  offset: const Offset(-21, 76)),
                              BoxShadow(
                                  blurRadius: 34, color: AppColor.black.withOpacity(0), offset: const Offset(-34, 118))
                            ], shape: BoxShape.circle),
                            height: context.screenHeight * 307 / 852,
                            child: IgnorePointer(
                                ignoring: isFlying,
                                child: GestureDetector(
                                    onTap: () => isChosen.length < wheelChoices.length
                                        ? setState(() {
                                            while (
                                                isChosen.contains(tmp = math.Random().nextInt(wheelChoices.length))) {}
                                            selected.add(tmp);
                                            isFlying = true;
                                          })
                                        : null,
                                    child: BlocConsumer<WheelCubit, WheelState>(
                                        listener: (context, state) {
                                          if (state is WheelShuffleChoice) {
                                            isChosen.clear();
                                          }
                                        },
                                        buildWhen: (previous, current) =>
                                            current is WheelChangeChoices ||
                                            current is WheelChangeDuration ||
                                            current is WheelChangeSkin ||
                                            current is WheelLoop,
                                        builder: (context, state) {
                                          if (state is WheelChangeChoices) {
                                            wheelChoices = localDataAccess.getWheelChoices();
                                          } else if (state is WheelChangeDuration) {
                                            duration = state.duration > 1 ? state.duration : 1;
                                          } else if (state is WheelChangeSkin) {
                                            wheelSkin = state.wheelSkin;
                                            colors = wheelSkins[wheelSkin]?['colors'];
                                            gradient = wheelSkins[wheelSkin]?['gradient'];
                                          } else if (state is WheelLoop) {
                                            localDataAccess.setWheelLoop(isLoop = state.isLoop);
                                            if (isLoop) {
                                              isChosen.clear();
                                            }
                                          }

                                          return Stack(alignment: Alignment.center, children: [
                                            Transform.rotate(
                                                angle: math.pi / 2,
                                                child: Container(
                                                    decoration:
                                                        BoxDecoration(gradient: gradient, shape: BoxShape.circle),
                                                    child: FortuneWheel(
                                                        animateFirst: false,
                                                        duration: Duration(seconds: duration),
                                                        indicators: [
                                                          FortuneIndicator(
                                                              alignment: Alignment.center,
                                                              child: Transform.rotate(
                                                                  angle: -math.pi / 2,
                                                                  child: SvgPicture.asset(
                                                                      '${Assets.icWheelIndicator}/style1.svg',
                                                                      height: context.screenWidth * 53.58 / 393)))
                                                        ],
                                                        items: List.generate(wheelChoices.length, (index) {
                                                          var color = colors[index % colors.length];
                                                          if (color is LinearGradient) {
                                                            color = AppColor.transparent;
                                                          }

                                                          return FortuneItem(
                                                              style: FortuneItemStyle(
                                                                  borderColor: AppColor.transparent,
                                                                  color: isChosen.contains(index)
                                                                      ? const Color(0xFFE7E7E7)
                                                                      : color),
                                                              child: Text(wheelChoices[index],
                                                                  style: AppTextTheme.interRegular20.copyWith(
                                                                      color: index % 2 == 0
                                                                          ? AppColor.white
                                                                          : AppColor.black)));
                                                        }),
                                                        onAnimationEnd: () async {
                                                          appAd.loadInterstitialAd();
                                                          setState(() {
                                                            result = wheelChoices[tmp];
                                                            if (!isLoop) isChosen.add(tmp);
                                                            isFlying = false;
                                                          });
                                                        },
                                                        selected: selected.stream))),
                                            if (wheelSkins[wheelSkin]?['decoration'] == true)
                                              SvgPicture.asset('${Assets.icWheelDecoration}/$wheelSkin.svg',
                                                  width: context.screenWidth)
                                          ]);
                                        })))),
                        SizedBox(height: context.screenWidth * 40 / 393),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                    end: Alignment.bottomRight)),
                            child: ElevatedButton(
                                onPressed: () => setState(() {
                                      isChosen.clear();
                                      result = '';
                                    }),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.transparent,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                    shadowColor: AppColor.transparent),
                                child: Text(AppLocalizations.of(context)?.translate('Reset') ?? '',
                                    style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))),
                      ])),
                  PrimaryIconButton(
                      child: SvgPicture.asset(Assets.icSliderHorizontal),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: AppColor.transparent,
                            builder: (context) => Container(
                                constraints: BoxConstraints(maxHeight: context.screenHeight * 351 / 393),
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      color: AppColor.black.withOpacity(0.08),
                                      offset: const Offset(0, -2),
                                      spreadRadius: 0)
                                ]),
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: WheelOptions())),
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))));
                      })
                ]))));
  }
}
