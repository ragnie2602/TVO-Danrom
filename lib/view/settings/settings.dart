import 'package:danrom/app_localization.dart';
import 'package:danrom/config/config.dart';
import 'package:danrom/config/routes.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final InAppReview inAppReview = InAppReview.instance;
  final LocalDataAccess localDataAccess = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: PrimaryIconButton(
                backgroundColor: Colors.transparent,
                child: const Icon(Icons.close, color: AppColor.black),
                onPressed: () => Navigator.pop(context)),
            title: Text(AppLocalizations.of(context)?.translate('Settings') ?? '',
                style: AppTextTheme.notosansSemiBold18)),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            // Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16),
            //       color: AppColor.gray10,
            //       image: const DecorationImage(
            //           image: AssetImage(Assets.imDanromPremium),
            //           alignment: Alignment.centerRight,
            //           fit: BoxFit.fitHeight)),
            //   // height: context.screenWidth * 134 / 393,
            //   width: context.screenWidth,
            //   child: Container(
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(16),
            //           gradient: LinearGradient(colors: [
            //             AppColor.gray11,
            //             AppColor.gray11.withOpacity(0.9132),
            //             AppColor.gray11.withOpacity(0)
            //           ])),
            //       // height: context.screenWidth * 134 / 393,
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            //       width: context.screenWidth * 328 / 393,
            //       child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Text('Danrom Premium', style: AppTextTheme.notosansBold18),
            //             Text(AppLocalizations.of(context)?.translate('Unlimited, faster & better') ?? '',
            //                 style: AppTextTheme.notosansRegular16),
            //             const SizedBox(height: 14),
            //             TextButton(
            //               onPressed: () {},
            //               style: const ButtonStyle(
            //                   backgroundColor: MaterialStatePropertyAll(AppColor.white),
            //                   padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 2))),
            //               child: Text(AppLocalizations.of(context)?.translate('Try from \$0.99') ?? '',
            //                   style: AppTextTheme.notosansBold12),
            //             )
            //           ])),
            // ),
            SettingItem(
                prefixIcon: SvgPicture.asset(Assets.icLanguage),
                label: AppLocalizations.of(context)?.translate('Language') ?? '',
                onPressed: () => Navigator.pushNamed(context, AppRoute.language),
                suffixIcon: Row(children: [
                  Text(languageDisplayStr[localDataAccess.getLanguage()] ?? '',
                      style: AppTextTheme.notosansMedium16.copyWith(color: AppColor.gray09))
                ])),
            SettingItem(
                prefixIcon: SvgPicture.asset(Assets.icPrivacy),
                label: AppLocalizations.of(context)?.translate('Private Policy') ?? '',
                onPressed: () {},
                suffixIcon: const Icon(Icons.keyboard_arrow_right_rounded)),
            SettingItem(
                prefixIcon: SvgPicture.asset(Assets.icStar),
                label: AppLocalizations.of(context)?.translate('Rate app') ?? '',
                onPressed: openRating,
                suffixIcon: const Icon(Icons.keyboard_arrow_right_rounded)),
            SettingItem(
                prefixIcon: SvgPicture.asset(Assets.icShare),
                label: AppLocalizations.of(context)?.translate('Share app') ?? '',
                onPressed: shareApp,
                suffixIcon: const Icon(Icons.keyboard_arrow_right_rounded)),
            SettingItem(
                prefixIcon: SvgPicture.asset(Assets.icVersion),
                label: AppLocalizations.of(context)?.translate('Version') ?? '',
                onPressed: () {},
                suffixIcon: Text('1.0.0', style: AppTextTheme.notosansMedium16.copyWith(color: AppColor.gray09)))
          ]),
        )));
  }

  void openRating() {
    inAppReview.openStoreListing();
  }

  void shareApp() {
    Share.shareUri(Uri.parse('https://play.google.com/store/apps/details?id=${AppConfig.packageName}'));
  }
}

class SettingItem extends StatelessWidget {
  final Widget prefixIcon;
  final String label;
  final Function() onPressed;
  final Widget suffixIcon;

  const SettingItem(
      {super.key, required this.prefixIcon, required this.label, required this.onPressed, required this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Bouncing(
        child: GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                prefixIcon,
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: AppTextTheme.notosansMedium16)),
                suffixIcon
              ]),
            )));
  }
}
