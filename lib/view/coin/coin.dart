import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/coin/coin_options.dart';
import 'package:danrom/view/coin/cubit/coin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Coin extends StatefulWidget {
  const Coin({super.key});

  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _positionAnimation;

  final AppAd appAd = getIt.get();

  final player = AudioPlayer();
  late String coinSkin;
  final CoinCubit cubit = getIt.get();
  int down = 0, end = 25, up = 0;
  LocalDataAccess localDataAccess = getIt.get();
  bool _isFlying = false;
  double rotate = 0.5;

  @override
  void initState() {
    super.initState();
    coinSkin = localDataAccess.getCoinSkin();

    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _rotationAnimation = Tween<double>(begin: 0, end: end * math.pi / 2).animate(_controller)..addListener(() {});
    _positionAnimation = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(flipHandler);

    _controller.addStatusListener((status) {
      if (_isFlying && status == AnimationStatus.completed) {
        player.play(AssetSource(Assets.auFlipCoinSuspended));
        _isFlying = false;
        _controller.reverse();
      } else if (!_isFlying && status == AnimationStatus.dismissed) {
        player.play(AssetSource(Assets.auFlipCoinDrop));
        setState(() {
          if (rotate.floor() % 2 == 0) {
            rotate = 0.5;
            down++;
          } else {
            rotate = 1.5;
            up++;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: BlocProvider.value(
          value: cubit,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocListener<CoinCubit, CoinState>(
                listener: (context, state) {
                  if (state is CoinChooseCoinSkin) {
                    setState(() {
                      coinSkin = state.coinSkin;
                    });
                  }
                },
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColor.gray07),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_up.svg',
                            width: context.screenWidth * 25 / 393),
                        Text('  $down  ', style: AppTextTheme.descriptionBoldSmall),
                        SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_down.svg',
                            width: context.screenWidth * 25 / 393),
                        Text('  $up', style: AppTextTheme.descriptionBoldSmall),
                      ])),
                  Expanded(
                      child: Stack(alignment: AlignmentDirectional.center, children: [
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Positioned(
                            bottom: _positionAnimation.value * context.screenHeight,
                            child: Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001) // Thay đổi giá trị này để điều chỉnh góc nhìn
                                  ..rotateX(_rotationAnimation.value),
                                child: Stack(children: [
                                  ((rotate - 0.5).floor() % 2 == 0)
                                      ? SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_up.svg',
                                          width: context.screenWidth * 109 / 393)
                                      : SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_down.svg',
                                          width: context.screenWidth * 109 / 393)
                                ]))))
                  ])),
                  const SizedBox(height: 16),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    PrimaryIconButton(
                        child: SvgPicture.asset(Assets.icSliderHorizontal),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              barrierColor: AppColor.gray08.withOpacity(0.7),
                              builder: (context) => Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        color: AppColor.black.withOpacity(0.08),
                                        offset: const Offset(0, -2),
                                        spreadRadius: 0)
                                  ]),
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: CoinOptions())));
                        }),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                end: Alignment.bottomRight)),
                        child: TextButton(
                            onPressed: () async {
                              appAd.loadInterstitialAd();
                              setState(() {
                                _isFlying = true;
                                _rotationAnimation =
                                    Tween<double>(begin: 0, end: (end = math.Random().nextInt(6) + 20) * math.pi / 2)
                                        .animate(_controller)
                                      ..addListener(flipHandler);

                                _controller.forward();
                                player.play(AssetSource(Assets.auFlipCoinStart));
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: AppColor.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                shadowColor: AppColor.transparent),
                            child: Text(AppLocalizations.of(context)?.translate('Flip') ?? '',
                                style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))),
                    const Spacer(),
                    PrimaryIconButton(
                        child: SvgPicture.asset(Assets.icReload),
                        onPressed: () {
                          setState(() {
                            down = up = 0;
                          });
                        })
                  ])
                ]),
              )),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  flipHandler() {
    if (_isFlying && _rotationAnimation.value >= rotate * math.pi) {
      rotate += 1;
    } else if (!_isFlying && _rotationAnimation.value <= (end - rotate) * math.pi) {
      rotate += 1;
    }
  }
}
