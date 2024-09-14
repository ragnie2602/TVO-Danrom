import 'package:danrom/resources/colors.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppAd {
  AppOpenAd? appOpenAd;
  bool justHidden = false;
  int interstitialAdCount = 0, rwSkin = 0, rwWinnersOrTapmode = 0;
  InterstitialAd? interstitialAd;
  NativeAd? nativeAd;
  RewardedAd? rewardedAd, rewardedSkinAd;

  AppAd() {
    AppOpenAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/9257395921',
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) => appOpenAd = ad, onAdFailedToLoad: (error) => print('Open ad error $error')),
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest());

    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => interstitialAd = ad,
            onAdFailedToLoad: (error) {
              interstitialAd!.dispose();
              print("Interstitial Ad error: $error");
            }));

    nativeAd = NativeAd(
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        factoryId: 'ListTile',
        listener: NativeAdListener(onAdLoaded: null, onAdFailedToLoad: (ad, error) => print('Native ad error: $error')),
        // nativeTemplateStyle: NativeTemplateStyle(
        //     cornerRadius: 8,
        //     primaryTextStyle:
        //         NativeTemplateTextStyle(style: NativeTemplateFontStyle.normal, size: 13, textColor: AppColor.purple01),
        //     secondaryTextStyle:
        //         NativeTemplateTextStyle(style: NativeTemplateFontStyle.normal, size: 13, textColor: AppColor.purple01),
        //     templateType: TemplateType.medium),
        request: const AdRequest());
    nativeAd?.load();

    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => rewardedAd = ad,
            onAdFailedToLoad: (error) => print('Rewarded ad failed to load: $error')));

    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => rewardedSkinAd = ad,
            onAdFailedToLoad: (error) => print('Rewarded ad failed to load: $error')));
  }

  loadAppOpenAd() async {
    if (appOpenAd == null) {
      await AppOpenAd.load(
          adUnitId: 'ca-app-pub-3940256099942544/9257395921',
          adLoadCallback: AppOpenAdLoadCallback(
              onAdLoaded: (ad) => appOpenAd = ad, onAdFailedToLoad: (error) => print('Open ad error $error')),
          orientation: AppOpenAd.orientationPortrait,
          request: const AdRequest());
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
      // print('onAdDismissedFullScreenContent');
      ad.dispose();
    }, onAdShowedFullScreenContent: (ad) {
      // print("onAdshowedFullScreenContent");
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      // print("onAdFailedToShowFullScreenContent with error: $error");
      ad.dispose();
    });

    print('App-open app is showinggggg');
    appOpenAd!.show();

    // Refresh ad
    appOpenAd = null;
    await loadAppOpenAd();
  }

  loadInterstitialAd() async {
    interstitialAdCount++;
    if (interstitialAdCount % 5 == 0) {
      if (interstitialAd != null) interstitialAd!.show();

      await InterstitialAd.load(
          adUnitId: 'ca-app-pub-3940256099942544/1033173712',
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
            interstitialAd = ad;
          }, onAdFailedToLoad: (error) {
            interstitialAd!.dispose();
            print("Interstitial Ad error: $error");
          }));
    }
  }

  loadNativeAd() async {
    nativeAd = NativeAd(
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        factoryId: 'ListTile',
        listener: NativeAdListener(onAdLoaded: null, onAdFailedToLoad: (ad, error) => print('Native ad error: $error')),
        // nativeTemplateStyle: NativeTemplateStyle(
        //     cornerRadius: 8,
        //     primaryTextStyle:
        //         NativeTemplateTextStyle(style: NativeTemplateFontStyle.normal, size: 13, textColor: AppColor.purple01),
        //     secondaryTextStyle:
        //         NativeTemplateTextStyle(style: NativeTemplateFontStyle.normal, size: 13, textColor: AppColor.purple01),
        //     templateType: TemplateType.medium),
        request: const AdRequest());
    nativeAd?.load();
  }

  loadRewardAd(BuildContext context) async {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose());

      rewardedAd!.show(onUserEarnedReward: (ad, reward) => rwWinnersOrTapmode++);
    }
    await RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => rewardedAd = ad,
            onAdFailedToLoad: (error) {
              if (error.code == 3) {
                context.showAppDialog(const Dialog(
                    backgroundColor: AppColor.white,
                    shadowColor: AppColor.gray04,
                    child: Padding(
                        padding: EdgeInsets.all(8.0), child: Text('Số lượng quảng cáo nhận thưởng đạt giới hạn'))));
              }

              print('Rewarded ad failed to load: $error');
            }));
  }

  loadRewardSkinAd() async {
    if (rewardedSkinAd != null) {
      rewardedSkinAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) => ad.dispose(),
          onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose());

      rewardedSkinAd!.show(onUserEarnedReward: (ad, reward) => rwSkin++);
    }
    await RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => rewardedSkinAd = ad,
            onAdFailedToLoad: (error) {
              print('Rewarded ad failed to load: $error');
            }));
  }
}
