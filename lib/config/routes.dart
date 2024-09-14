import 'package:danrom/view/decision/card_skin.dart';
import 'package:danrom/view/home/home.dart';
import 'package:danrom/view/settings/languages.dart';
import 'package:danrom/view/settings/settings.dart';
import 'package:danrom/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const String splash = '/';
  static const String home = '/home';

  static const String cardSkin = '/cardSkin';

  static const String language = '/language';
  static const String settings = '/settings';

  static Map<String, Widget Function(BuildContext)> generateRoute() => {
        AppRoute.splash: (context) => const SplashScreen(),
        AppRoute.home: (context) => const HomePage(),
        AppRoute.cardSkin: (context) => const CardSkin(),
        AppRoute.language: (context) => const Languages(),
        AppRoute.settings: (context) => const Settings()
      };

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name!) {
      case AppRoute.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen(), settings: settings);
      default:
        return null;
    }
  }
}
