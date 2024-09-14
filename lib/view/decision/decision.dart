import 'dart:math' as math;

import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/utils/view_utils.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/loading.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/decision/card_state.dart';
import 'package:danrom/view/decision/cubit/decision_cubit.dart';
import 'package:danrom/view/decision/decision_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Decision extends StatefulWidget {
  const Decision({super.key});

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  final AppAd appAd = getIt.get();
  final CardState cardState = getIt.get();
  final DecisionCubit cubit = getIt.get();
  bool isInitialized = false;
  final LocalDataAccess localDataAccess = getIt.get();
  final TextEditingController questionController = TextEditingController();
  bool started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialized) {
      questionController.text = AppLocalizations.of(context)
              ?.translate('Don\'t ever feel alone in making decisions,\nDanrom will always be here to help you.') ??
          '';
    }

    isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final cardLoop = localDataAccess.getCardLoop();
    final cardSkin = localDataAccess.getCardSkin().isEmpty ? 'style1.svg' : localDataAccess.getCardSkin();

    return Scaffold(
        backgroundColor: AppColor.white,
        resizeToAvoidBottomInset: false,
        body: BlocProvider.value(
            value: cubit,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: context.screenHeight * 40 / 852),
                  TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.all(16),
                          filled: true,
                          fillColor: AppColor.white),
                      maxLines: 2,
                      readOnly: true,
                      style: AppTextTheme.descriptionBoldRegular,
                      textAlign: TextAlign.center),
                  const Spacer(),
                  BlocListener<DecisionCubit, DecisionState>(
                      listener: (context, state) {
                        if (state is DecisionSetCardLoop) {
                          setState(() {
                            started = false;
                          });
                        } else if (state is DecisionChooseCardSkin) {
                          setState(() {});
                        }
                      },
                      child: !started
                          ? Bouncing(
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      started = true;
                                    });
                                  },
                                  child: Stack(alignment: AlignmentDirectional.center, children: [
                                    SvgPicture.asset(Assets.icEllipse, width: context.screenWidth * 283 / 393),
                                    Column(
                                      children: [
                                        SizedBox(height: context.screenWidth * 0.052),
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          SizedBox(width: context.screenWidth * 0.45),
                                          SimpleShadow(
                                              offset: const Offset(0, 2),
                                              opacity: 0.25,
                                              sigma: 2,
                                              child: Transform.rotate(
                                                  angle: math.pi / 180 * 14.47,
                                                  child: SvgPicture.asset('${Assets.icCardPrototypePrefix}/$cardSkin',
                                                      height: context.screenWidth * 211 / 393,
                                                      width: context.screenWidth * 150 / 393)))
                                        ]),
                                      ],
                                    ),
                                    Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SizedBox(width: context.screenWidth * 0.2),
                                        SimpleShadow(
                                            offset: const Offset(0, 2),
                                            opacity: 0.25,
                                            sigma: 2,
                                            child: Transform.rotate(
                                                angle: math.pi / 180 * 7.72,
                                                child: SvgPicture.asset('${Assets.icCardPrototypePrefix}/$cardSkin',
                                                    height: context.screenWidth * 211 / 393,
                                                    width: context.screenWidth * 150 / 393)))
                                      ]),
                                      SizedBox(height: context.screenWidth * 0.066)
                                    ]),
                                    Column(children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SimpleShadow(
                                            offset: const Offset(0, 2),
                                            opacity: 0.25,
                                            sigma: 2,
                                            child: Transform.rotate(
                                                angle: math.pi / 180 * -3.92,
                                                child: SvgPicture.asset('${Assets.icCardPrototypePrefix}/$cardSkin',
                                                    height: context.screenWidth * 211 / 393,
                                                    width: context.screenWidth * 150 / 393))),
                                        SizedBox(width: context.screenWidth * 0.2),
                                      ]),
                                      SizedBox(height: context.screenWidth * 0.052)
                                    ]),
                                    Column(
                                      children: [
                                        SizedBox(height: context.screenWidth * 0.052),
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          SimpleShadow(
                                              offset: const Offset(0, 2),
                                              opacity: 0.25,
                                              sigma: 2,
                                              child: Transform.rotate(
                                                  angle: math.pi / 180 * -10.5,
                                                  child: SvgPicture.asset('${Assets.icCardPrototypePrefix}/$cardSkin',
                                                      height: context.screenWidth * 211 / 393,
                                                      width: context.screenWidth * 150 / 393))),
                                          SizedBox(width: context.screenWidth * 0.45),
                                        ]),
                                      ],
                                    ),
                                  ])))
                          : Flexible(
                              flex: 6,
                              child: Card(
                                  cardSkin: cardSkin,
                                  text: AppLocalizations.of(context)?.translate(cardState.text) ?? ''))),
                  const Spacer(),
                  if (!started) SvgPicture.asset(Assets.icTouch),
                  if (!started)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(AppLocalizations.of(context)?.translate('Touch on cards to ') ?? '',
                          style: AppTextTheme.descriptionSmall),
                      Text(AppLocalizations.of(context)?.translate('Start!') ?? '',
                          style: AppTextTheme.descriptionBoldSmall)
                    ]),
                  const Spacer(),
                  Row(children: [
                    PrimaryIconButton(
                        child: SvgPicture.asset(Assets.icSliderHorizontal),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: AppColor.transparent,
                              barrierColor: AppColor.transparent,
                              builder: (context) => Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        blurRadius: 8,
                                        color: AppColor.black.withOpacity(0.08),
                                        offset: const Offset(0, -2),
                                        spreadRadius: 0)
                                  ]),
                                  child: DecisionOptions(
                                      questionController: questionController,
                                      shuffle: () => setState(() {
                                            started = false;
                                          }))),
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))));
                        }),
                    const Spacer(),
                    if (started)
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                  end: Alignment.bottomRight)),
                          child: ElevatedButton(
                              onPressed: () async {
                                appAd.loadInterstitialAd();

                                showDialog(context: context, builder: (context) => const Loading());
                                await Future.delayed(const Duration(seconds: 1));
                                setState(() {
                                  if (cardLoop) {
                                    cardState.i = math.Random().nextInt(cardState.cardTexts.length);
                                  } else {
                                    cardState.randomizeNoLoop();
                                  }
                                  Navigator.pop(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  shadowColor: AppColor.transparent),
                              child: Text(AppLocalizations.of(context)?.translate('Reset') ?? '',
                                  style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))),
                    const Spacer(),
                    if (started)
                      PrimaryIconButton(
                          child: SvgPicture.asset(Assets.icCopy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: cardState.cardTexts[cardState.index]));
                            toastInformation(AppLocalizations.of(context)?.translate("Text copied") ?? '');
                          })
                  ])
                ]))));
  }
}

class Card extends StatefulWidget {
  final String text;
  final String cardSkin;

  const Card({super.key, this.text = '', required this.cardSkin});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  final DecisionCubit cubit = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(alignment: AlignmentDirectional.center, children: [
      widget.cardSkin == 'style1.svg'
          ? SimpleShadow(
              offset: const Offset(0, 4),
              opacity: 0.25,
              child: SvgPicture.asset('${Assets.icCardSkinPrefix}/${widget.cardSkin}',
                  width: context.screenWidth * 277.25 / 393))
          : SvgPicture.asset('${Assets.icCardSkinPrefix}/${widget.cardSkin}',
              width: context.screenWidth * 277.25 / 393),
      Container(
          constraints:
              BoxConstraints(maxHeight: context.screenWidth * 282.62 / 393, maxWidth: context.screenWidth * 180 / 393),
          child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: cardTextColor[widget.cardSkin] ?? [],
                  ).createShader(bounds),
              child: Text(widget.text, style: AppTextTheme.cardMedium, textAlign: TextAlign.center)))
    ]));
  }
}
