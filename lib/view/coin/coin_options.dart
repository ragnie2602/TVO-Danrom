import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/coin/cubit/coin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinOptions extends StatelessWidget {
  final AppAd appAd = getIt.get();

  CoinOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt.get<CoinCubit>(),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    color: AppColor.black.withOpacity(0.08),
                    offset: const Offset(0, -2),
                    spreadRadius: 0)
              ],
              color: AppColor.white),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Text(AppLocalizations.of(context)?.translate('Options') ?? '',
                  style: AppTextTheme.descriptionBoldSemiLarge),
              const SizedBox(width: 6),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                          end: Alignment.bottomRight)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Text('Pro', style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white))),
              const Spacer(),
              PrimaryIconButton(
                  backgroundColor: AppColor.white,
                  child: SvgPicture.asset(Assets.icClose),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]),
            const SizedBox(height: 16),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: coinSkins
                        .map((e) => Row(children: [
                              CoinSkinItem(
                                  appAd: appAd,
                                  coinSkin: e,
                                  cubit: getIt.get<CoinCubit>(),
                                  localDataAccess: getIt.get<LocalDataAccess>()),
                              const SizedBox(width: 16)
                            ]))
                        .toList()))
          ])),
    );
  }
}

class CoinSkinItem extends StatelessWidget {
  final AppAd appAd;
  final String coinSkin;
  final CoinCubit cubit;
  final LocalDataAccess localDataAccess;

  const CoinSkinItem(
      {super.key, required this.appAd, required this.coinSkin, required this.cubit, required this.localDataAccess});

  @override
  Widget build(BuildContext context) {
    return Bouncing(
        child: InkWell(
      onTap: () {
        if (!localDataAccess.getCoinRepo().contains(coinSkin)) {
          if (appAd.rwSkin < 2) {
            appAd.loadRewardSkinAd();
            return;
          }
          appAd.rwSkin -= 2;
        }
        localDataAccess.addCoinSkin(coinSkin);
        localDataAccess.setCoinSkin(coinSkin);
        cubit.chooseCoinSkin(coinSkin);
      },
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.gray06),
          child: Stack(children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 12),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_up.svg'),
                  const SizedBox(height: 4),
                  SvgPicture.asset('${Assets.icCoinSkinPrefix}/${coinSkin}_down.svg'),
                  const SizedBox(height: 8)
                ])),
            BlocBuilder<CoinCubit, CoinState>(
                buildWhen: (previous, current) => current is CoinChooseCoinSkin || current is CoinInitial,
                builder: (context, state) {
                  return Positioned(
                      bottom: 4,
                      right: 4,
                      child: ShaderMask(
                          shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: coinSkin == localDataAccess.getCoinSkin()
                                      ? [AppColor.primaryColor1, AppColor.primaryColor2]
                                      : [AppColor.gray03, AppColor.gray03])
                              .createShader(bounds),
                          child: const Icon(Icons.check_circle_rounded, color: Colors.white)));
                })
          ])),
    ));
  }
}
