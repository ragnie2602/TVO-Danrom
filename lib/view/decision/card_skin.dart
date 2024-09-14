import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/gradient_border_container.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/decision/cubit/decision_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CardSkin extends StatefulWidget {
  const CardSkin({super.key});

  @override
  State<CardSkin> createState() => _CardSkinState();
}

class _CardSkinState extends State<CardSkin> {
  final AppAd appAd = getIt.get();
  final DecisionCubit cubit = getIt.get();
  final LocalDataAccess localDataAccess = getIt.get();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: cubit,
        child: Container(
            width: context.screenWidth,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 8, color: AppColor.black.withOpacity(0.08), offset: const Offset(0, -2), spreadRadius: 0)
            ], color: AppColor.white),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              AppBar(
                  actions: [
                    PrimaryIconButton(
                        backgroundColor: AppColor.white,
                        child: SvgPicture.asset(Assets.icClose),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  backgroundColor: AppColor.white,
                  leading: Container(),
                  leadingWidth: 0,
                  title: Text(AppLocalizations.of(context)?.translate('Card skins') ?? '',
                      style: AppTextTheme.descriptionBoldSemiLarge)),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: cardSkins.entries
                          .map((e) => Row(children: [
                                CardSkinItem(
                                    appAd: appAd, cardSkin: e.key, localDataAccess: localDataAccess, pro: e.value),
                                const SizedBox(width: 12)
                              ]))
                          .toList()))
            ])));
  }
}

class CardSkinItem extends StatefulWidget {
  final AppAd appAd;
  final String cardSkin;
  final LocalDataAccess localDataAccess;
  final bool pro;

  const CardSkinItem(
      {super.key, required this.appAd, required this.cardSkin, required this.localDataAccess, this.pro = false});

  @override
  State<CardSkinItem> createState() => _CardSkinItemState();
}

class _CardSkinItemState extends State<CardSkinItem> {
  final DecisionCubit cubit = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Bouncing(
        child: BlocBuilder<DecisionCubit, DecisionState>(
            buildWhen: (previous, current) => current is DecisionChooseCardSkin,
            builder: (context, state) {
              return InkWell(
                  onTap: () {
                    if (!widget.localDataAccess.getCardRepo().contains(widget.cardSkin)) {
                      if (widget.appAd.rwSkin < 2) {
                        widget.appAd.loadRewardSkinAd();
                        return;
                      }
                      widget.appAd.rwSkin -= 2;
                    }
                    widget.localDataAccess.addCardSkin(widget.cardSkin);
                    widget.localDataAccess.setCardSkin(widget.cardSkin);
                    cubit.chooseCardSkin(widget.cardSkin);
                  },
                  child: GradientBorderContainer(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 6, color: AppColor.black.withOpacity(0.1), offset: const Offset(-1, 3)),
                            BoxShadow(
                                blurRadius: 12, color: AppColor.black.withOpacity(0.09), offset: const Offset(-4, 11)),
                          ],
                          color: AppColor.white),
                      gradientColors: state is DecisionChooseCardSkin && state.cardSkin == widget.cardSkin
                          ? [AppColor.primaryColor1, AppColor.primaryColor2]
                          : [AppColor.gray06, AppColor.gray06],
                      child: Stack(alignment: Alignment.topRight, children: [
                        Stack(alignment: Alignment.bottomRight, children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
                              child: SimpleShadow(
                                  offset: const Offset(0, 4),
                                  opacity: 0.25,
                                  sigma: 3,
                                  child: SvgPicture.asset('${Assets.icCardPrototypePrefix}/${widget.cardSkin}',
                                      width: context.screenWidth * 90 / 393))),
                          ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: state is DecisionChooseCardSkin && state.cardSkin == widget.cardSkin
                                            ? [AppColor.primaryColor1, AppColor.primaryColor2]
                                            : [AppColor.gray03, AppColor.gray03])
                                    .createShader(bounds);
                              },
                              child: const Icon(Icons.check_circle_rounded, color: Colors.white))
                        ]),
                        if (widget.pro)
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                      end: Alignment.bottomRight)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              child: Text('Pro',
                                  style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))
                      ])));
            }));
  }
}
