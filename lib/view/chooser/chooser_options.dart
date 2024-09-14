import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/widget/option_item.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooserOptions extends StatefulWidget {
  final Function() onChanged;
  const ChooserOptions({super.key, required this.onChanged});

  @override
  State<ChooserOptions> createState() => _ChooserOptionsState();
}

class _ChooserOptionsState extends State<ChooserOptions> {
  final AppAd appAd = getIt.get();
  final LocalDataAccess localDataAccess = getIt.get();
  late int winners;

  @override
  void initState() {
    super.initState();

    winners = localDataAccess.getWinners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8, color: AppColor.black.withOpacity(0.08), offset: const Offset(0, -2), spreadRadius: 0)
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
                backgroundColor: AppColor.white,
                leading: Container(),
                leadingWidth: 0,
                scrolledUnderElevation: 0.0,
                surfaceTintColor: AppColor.transparent,
                title: Text(AppLocalizations.of(context)?.translate('Options') ?? '',
                    style: AppTextTheme.descriptionBoldSemiLarge)),
            backgroundColor: AppColor.white,
            body: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              OptionItem(
                  content: Row(children: [
                    Text(AppLocalizations.of(context)?.translate('Winners') ?? '',
                        maxLines: 2, softWrap: true, style: AppTextTheme.poppinsMedium16),
                    const SizedBox(width: 10),
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
                  prefixIcon: SvgPicture.asset(Assets.icMedal),
                  suffixIcon: Expanded(
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: AppColor.gray02),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    4,
                                    (index) => TextButton(
                                        onPressed: () {
                                          if (index > 0) {
                                            if (appAd.rwWinnersOrTapmode < 1) {
                                              appAd.loadRewardAd(context);
                                              return;
                                            }
                                            appAd.rwWinnersOrTapmode--;
                                          }
                                          setState(() {
                                            localDataAccess.setWinners(winners = index + 1);
                                            widget.onChanged();
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                index + 1 == winners ? AppColor.white : AppColor.transparent,
                                            minimumSize: const Size(0, 0),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
                                        child: Text('${index + 1}', style: AppTextTheme.poppinsMedium14)))))),
                  )),
              const SizedBox(height: 9),
              Text(AppLocalizations.of(context)?.translate("Number of winners if there's enough players") ?? '',
                  style: AppTextTheme.poppinsRegular10),
              const SizedBox(height: 16),
              OptionItem(
                  content: Row(children: [
                    Text(AppLocalizations.of(context)?.translate('Tap Mode') ?? '',
                        style: AppTextTheme.poppinsMedium16),
                    const SizedBox(width: 10),
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
                  initSwitch: !localDataAccess.getTapMode(),
                  isShowSwitch: true,
                  onSwitched: (p0) async {
                    if (p0 && appAd.rwWinnersOrTapmode < 1) {
                      appAd.loadRewardAd(context);
                      return;
                    }
                    if (p0) appAd.rwWinnersOrTapmode--;

                    localDataAccess.setTapMode(p0);
                    widget.onChanged();
                  },
                  prefixIcon: SvgPicture.asset(Assets.icHandPointing)),
              const SizedBox(height: 9),
              Text(AppLocalizations.of(context)?.translate("Allow for more than 5 players") ?? '',
                  style: AppTextTheme.poppinsRegular10)
            ]))));
  }
}
