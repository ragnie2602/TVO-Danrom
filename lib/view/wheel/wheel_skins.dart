import 'package:danrom/app_ad.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/wheel/cubit/wheel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WheelSkins extends StatelessWidget {
  final AppAd appAd = getIt.get();
  final WheelCubit cubit;
  final LocalDataAccess localDataAccess;

  WheelSkins({super.key, required this.cubit, required this.localDataAccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: cubit,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      color: AppColor.black.withOpacity(0.08),
                      offset: const Offset(0, -2),
                      spreadRadius: 0)
                ],
                color: AppColor.white),
            padding: const EdgeInsets.all(16),
            child: Scaffold(
                appBar: AppBar(
                    actions: [
                      PrimaryIconButton(
                          backgroundColor: AppColor.white,
                          child: SvgPicture.asset(Assets.icClose),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColor.white,
                    leading: null,
                    title: Row(children: [
                      const Text('Wheel skins  ', style: AppTextTheme.descriptionBoldRegular),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                  end: Alignment.bottomRight)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child:
                              Text('Pro', style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))
                    ]),
                    titleSpacing: 0.0,
                    scrolledUnderElevation: 0.0,
                    surfaceTintColor: AppColor.transparent),
                body: BlocBuilder<WheelCubit, WheelState>(
                  buildWhen: (previous, current) => current is WheelChangeSkin,
                  builder: (context, state) {
                    return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 10, childAspectRatio: 168 / 219),
                        itemBuilder: (context, index) => WheelSkinItem(
                            appAd: appAd,
                            cubit: cubit,
                            localDataAccess: localDataAccess,
                            wheelSkin: wheelSkins.keys.toList()[index]),
                        itemCount: wheelSkins.length);
                  },
                ))));
  }
}

class WheelSkinItem extends StatelessWidget {
  final AppAd appAd;
  final WheelCubit cubit;
  final LocalDataAccess localDataAccess;
  final String wheelSkin;

  const WheelSkinItem(
      {super.key, required this.appAd, required this.cubit, required this.localDataAccess, required this.wheelSkin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!localDataAccess.getWheelRepo().contains(wheelSkin)) {
            if (appAd.rwSkin < 2) {
              appAd.loadRewardSkinAd();
              return;
            }
            appAd.rwSkin -= 2;
          }
          localDataAccess.addWheelSkin(wheelSkin);
          localDataAccess.setWheelSkin(wheelSkin);
          cubit.changeSkin(wheelSkin);
        },
        child: Bouncing(
            child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.gray06),
                child: Stack(alignment: Alignment.topCenter, children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 12),
                      child: SvgPicture.asset('${Assets.icWheelSkinPrefix}/$wheelSkin.svg')),
                  BlocBuilder<WheelCubit, WheelState>(builder: (context, state) {
                    return Positioned(
                        bottom: 4,
                        child: ShaderMask(
                            shaderCallback: (Rect bounds) => LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: wheelSkin == localDataAccess.getWheelSkin()
                                        ? [AppColor.primaryColor1, AppColor.primaryColor2]
                                        : [AppColor.gray03, AppColor.gray03])
                                .createShader(bounds),
                            child: const Icon(Icons.check_circle_rounded, color: Colors.white)));
                  })
                ]))));
  }
}
