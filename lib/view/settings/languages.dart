import "package:danrom/app_ad.dart";
import "package:danrom/app_localization.dart";
import "package:danrom/config/routes.dart";
import "package:danrom/data/constants.dart";
import "package:danrom/data/local/local_data_access.dart";
import "package:danrom/di/di.dart";
import "package:danrom/language_cubit.dart";
import "package:danrom/resources/colors.dart";
import "package:danrom/resources/resources.dart";
import "package:danrom/resources/themes.dart";
import "package:danrom/shared/utils/dart_extensions.dart";
import "package:danrom/shared/widget/logo.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  AppAd appAd = getIt.get();
  bool isAdLoaded = false, firstlyAppear = false;
  late String lgValue;
  LocalDataAccess localDataAccess = getIt.get();

  @override
  void initState() {
    super.initState();

    if (appAd.nativeAd == null) appAd.loadNativeAd();
    firstlyAppear = (localDataAccess.getLanguage() == null);
    lgValue = localDataAccess.getLanguage() ?? 'system';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                          end: Alignment.bottomRight)),
                  height: context.screenWidth * 33 / 393,
                  padding: EdgeInsets.zero,
                  child: TextButton(
                      onPressed: firstlyAppear
                          ? () {
                              localDataAccess.setLanguage(lgValue);
                              Navigator.popAndPushNamed(context, AppRoute.home);
                            }
                          : () {
                              localDataAccess.setLanguage(lgValue);
                              Navigator.pop(context);
                            },
                      style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shadowColor: AppColor.transparent),
                      child: Text(AppLocalizations.of(context)?.translate('Next') ?? '',
                          style: AppTextTheme.interSemiBold14.copyWith(color: AppColor.white)))),
              const SizedBox(width: 16)
            ],
            leading: Container(),
            leadingWidth: 0,
            title: Logo(
                isUppercase: false,
                size: 24,
                style: AppTextTheme.gradientTextStyle.copyWith(fontFamily: 'Poppins'),
                text: AppLocalizations.of(context)?.translate('Languages') ?? '')),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(children: [
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('System Language') ?? '',
                            groupValue: lgValue,
                            languageIcon: Assets.lgSystem,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(null);
                            },
                            value: LanguageDisplay.system),
                        const SizedBox(height: 8),
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('English') ?? '',
                            groupValue: lgValue,
                            language: 'English',
                            languageIcon: Assets.lgEnglish,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(Locale(p0));
                            },
                            value: LanguageDisplay.english),
                        const SizedBox(height: 8),
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('Chinese') ?? '',
                            groupValue: lgValue,
                            language: '简体中文',
                            languageIcon: Assets.lgChinese,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(Locale(p0));
                            },
                            value: LanguageDisplay.chinese),
                        const SizedBox(height: 8),
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('Indonesian') ?? '',
                            groupValue: lgValue,
                            language: 'Bahasa Indonesia',
                            languageIcon: Assets.lgIndonesian,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(Locale(p0));
                            },
                            value: LanguageDisplay.indonesian),
                        const SizedBox(height: 8),
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('Vietnamese') ?? '',
                            groupValue: lgValue,
                            language: 'Tiếng Việt',
                            languageIcon: Assets.lgVietnamese,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(Locale(p0));
                            },
                            value: LanguageDisplay.vietnamese),
                        const SizedBox(height: 8),
                        LanguageItem(
                            country: AppLocalizations.of(context)?.translate('Arabic') ?? '',
                            groupValue: lgValue,
                            language: 'العربية',
                            languageIcon: Assets.lgArabic,
                            onTap: (p0) {
                              setState(() => localDataAccess.setLanguage(lgValue = p0));
                              context.read<LanguageCubit>().change(Locale(p0));
                            },
                            value: LanguageDisplay.arabic),
                        const SizedBox(height: 8),
                      ])))),
          Align(
            alignment: Alignment.bottomCenter,
            child: appAd.nativeAd != null
                ? Container(
                    constraints: BoxConstraints(maxHeight: context.screenWidth / 393 * 259),
                    child: AdWidget(ad: appAd.nativeAd!))
                : Container(
                    height: 90,
                    width: context.screenWidth,
                    color: Colors.grey[300], // Placeholder color
                    child: const Center(child: CircularProgressIndicator())),
          )
        ]));
  }

  @override
  void dispose() {
    appAd.loadNativeAd();
    super.dispose();
  }
}

class LanguageItem extends StatelessWidget {
  final String country;
  final String groupValue;
  final String? language;
  final String languageIcon;
  final Function(String) onTap;
  final String value;

  const LanguageItem(
      {super.key,
      required this.country,
      required this.groupValue,
      this.language,
      required this.languageIcon,
      required this.onTap,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(blurRadius: 2, color: AppColor.gray04.withOpacity(0.1), offset: const Offset(0, 1)),
              BoxShadow(blurRadius: 4, color: AppColor.gray04.withOpacity(0.09), offset: const Offset(0, 4)),
              BoxShadow(blurRadius: 5, color: AppColor.gray04.withOpacity(0.05), offset: const Offset(0, 9)),
              BoxShadow(blurRadius: 6, color: AppColor.gray04.withOpacity(0.01), offset: const Offset(0, 16)),
              BoxShadow(blurRadius: 7, color: AppColor.gray04.withOpacity(0), offset: const Offset(0, 25))
            ],
            color: AppColor.white),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: ListTile(
            horizontalTitleGap: 8,
            leading: languageIcon.endsWith('.png')
                ? Image.asset(languageIcon, height: context.screenWidth * 36 / 393)
                : SvgPicture.asset(languageIcon, height: context.screenWidth * 36 / 393),
            onTap: () => onTap(value),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(country, style: AppTextTheme.poppinsMedium14),
              if (language != null) const SizedBox(height: 8),
              if (language != null) Text(language!, style: AppTextTheme.poppinsRegular12)
            ]),
            trailing: GradientRadio(isSelected: value == groupValue)));
  }
}

class GradientRadio<T> extends StatelessWidget {
  final bool isSelected;
  final double size;

  const GradientRadio({super.key, required this.isSelected, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: !isSelected ? AppColor.black.withOpacity(0.2) : AppColor.transparent, width: 2),
            gradient:
                isSelected ? const LinearGradient(colors: [AppColor.primaryColor1, AppColor.primaryColor2]) : null,
            shape: BoxShape.circle),
        padding: const EdgeInsets.all(0),
        child: Container(
            decoration: const BoxDecoration(color: AppColor.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(3),
            child: AnimatedContainer(
                curve: Curves.elasticInOut,
                decoration: BoxDecoration(
                    color: isSelected ? null : AppColor.white,
                    gradient: isSelected
                        ? const LinearGradient(colors: [AppColor.primaryColor1, AppColor.primaryColor2])
                        : null,
                    shape: BoxShape.circle),
                duration: const Duration(milliseconds: 300),
                height: context.screenWidth * 14 / 393,
                padding: const EdgeInsets.all(3),
                width: context.screenWidth * 14 / 393)));
  }
}
