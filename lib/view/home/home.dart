import 'package:danrom/app_localization.dart';
import 'package:danrom/config/routes.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/logo.dart';
import 'package:danrom/view/chooser/chooser.dart';
import 'package:danrom/view/coin/coin.dart';
import 'package:danrom/view/decision/decision.dart';
import 'package:danrom/view/number/number.dart';
import 'package:danrom/view/wheel/wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd bannerAd;
  int currentPageIndex = 2;
  bool isAdLoaded = false;
  final pages = [const Wheel(), const Chooser(), const Decision(), const Number(), const Coin()];

  @override
  void initState() {
    super.initState();

    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        listener: BannerAdListener(
            onAdLoaded: (ad) => setState(() {
                  isAdLoaded = true;
                }),
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            }),
        request: const AdRequest());
    bannerAd.load();

    WidgetsBinding.instance.addPostFrameCallback((_) => checkNotificationPermission());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          // IconButton(
          //     onPressed: () {
          //       checkNotificationPermission();
          //     },
          //     icon: SvgPicture.asset(Assets.icPro)),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoute.settings),
              icon: SvgPicture.asset(Assets.icSettings, color: AppColor.gray01))
        ], backgroundColor: AppColor.white, centerTitle: false, title: const Logo(size: 24)),
        backgroundColor: AppColor.backgroundColor,
        body: pages[currentPageIndex],
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          BottomNavigationBar(
              backgroundColor: AppColor.white,
              currentIndex: currentPageIndex,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 0 ? Assets.icWheelSelected : Assets.icWheel),
                    label: AppLocalizations.of(context)?.translate('Wheel')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 1 ? Assets.icChooserSelected : Assets.icChooser),
                    label: AppLocalizations.of(context)?.translate('Chooser')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 2 ? Assets.icDecisionSelected : Assets.icDecision),
                    label: AppLocalizations.of(context)?.translate('Decision')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 3 ? Assets.icNumberSelected : Assets.icNumber),
                    label: AppLocalizations.of(context)?.translate('Number')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 4 ? Assets.icCoinSelected : Assets.icCoin),
                    label: AppLocalizations.of(context)?.translate('Coin'))
              ],
              onTap: (value) => setState(() {
                    currentPageIndex = value;
                  }),
              selectedItemColor: AppColor.purple,
              selectedFontSize: 12,
              selectedLabelStyle: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.purple),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedFontSize: 12,
              unselectedItemColor: AppColor.black,
              unselectedLabelStyle: AppTextTheme.descriptionSemiBoldSmall.copyWith(fontWeight: FontWeight.w400),
              type: BottomNavigationBarType.fixed),
          if (isAdLoaded)
            SizedBox(height: bannerAd.size.height.toDouble(), width: context.screenWidth, child: AdWidget(ad: bannerAd))
        ]),
        resizeToAvoidBottomInset: false);
  }

  Future<void> checkNotificationPermission() async {
    var isGranted = await Permission.notification.status.isGranted;
    LocalDataAccess localDataAccess = getIt.get();

    if ((!isGranted || !localDataAccess.notificationPermission()) && mounted) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
              backgroundColor: AppColor.white,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SvgPicture.asset(Assets.icNotiPermission),
                    const SizedBox(height: 24),
                    const Text('Notification', style: AppTextTheme.interBold20),
                    const SizedBox(height: 24),
                    Text('Please enable notifications to receive updates and reminders',
                        style: AppTextTheme.interMedium16.copyWith(color: AppColor.gray14),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 36),
                    Container(
                        constraints: BoxConstraints(minWidth: context.screenWidth),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                                colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        padding: EdgeInsets.zero,
                        child: TextButton(
                            onPressed: () async {
                              if (await Permission.notification.request() == PermissionStatus.permanentlyDenied) {
                                openAppSettings();
                              }
                              localDataAccess.setNotificationPermission(true);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: Text('Turn on', style: AppTextTheme.cardMedium.copyWith(color: AppColor.white)))),
                    const SizedBox(height: 12),
                    Container(
                        constraints: BoxConstraints(minWidth: context.screenWidth),
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColor.black01), borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.zero,
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child:
                                Text('Skip for now', style: AppTextTheme.cardMedium.copyWith(color: AppColor.black01))))
                  ]))));
    }
  }
}
