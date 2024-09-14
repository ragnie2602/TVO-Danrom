import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/data/local/shared_preferences.dart';
import 'package:danrom/app_ad.dart';
import 'package:danrom/view/coin/cubit/coin_cubit.dart';
import 'package:danrom/view/decision/card_state.dart';
import 'package:danrom/view/decision/cubit/decision_cubit.dart';
import 'package:danrom/view/number/cubit/number_cubit.dart';
import 'package:danrom/view/wheel/cubit/wheel_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

configureInjection() async {
  final sharedPref = await SharedPreferences.getInstance();

  // LocalDataAccess
  getIt.registerLazySingleton<LocalDataAccess>(() => SharePrefHelper(sharedPref: sharedPref));

  // Cubit
  getIt.registerLazySingleton(() => CoinCubit());
  getIt.registerLazySingleton(() => DecisionCubit());
  getIt.registerLazySingleton(() => NumberCubit());
  getIt.registerLazySingleton(() => WheelCubit());

  // Data
  getIt.registerLazySingleton(() => CardState());

  // Ads
  getIt.registerLazySingleton(() => AppAd());
}
