import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'local_data_access.dart';

class SharePrefHelper implements LocalDataAccess {
  final SharedPreferences sharedPref;

  SharePrefHelper({required this.sharedPref});

  /* FUNCTION*/

  // Card
  @override
  void clearCardLoop() {
    sharedPref.remove(SharedPreferenceKey.cardLoop);
  }

  @override
  void clearCardSkin() {
    sharedPref.remove(SharedPreferenceKey.cardSkin);
  }

  @override
  bool getCardLoop() {
    return sharedPref.getBool(SharedPreferenceKey.cardLoop) ?? false;
  }

  @override
  String getCardSkin() => sharedPref.getString(SharedPreferenceKey.cardSkin) ?? '';

  @override
  String getCoinSkin() => sharedPref.getString(SharedPreferenceKey.coinSkin) ?? 'dollar';

  @override
  void setCardLoop(bool cardLoop) {
    sharedPref.setBool(SharedPreferenceKey.cardLoop, cardLoop);
  }

  @override
  void setCardSkin(String cardSkin) {
    sharedPref.setString(SharedPreferenceKey.cardSkin, cardSkin);
  }

  @override
  void setCoinSkin(String coinSkin) {
    sharedPref.setString(SharedPreferenceKey.coinSkin, coinSkin);
  }

  // Chooser
  @override
  bool getTapMode() {
    return sharedPref.getBool(SharedPreferenceKey.tapMode) ?? false;
  }

  @override
  int getWinners() {
    return sharedPref.getInt(SharedPreferenceKey.chooserWinners) ?? 1;
  }

  @override
  void setTapMode(bool tapMode) {
    sharedPref.setBool(SharedPreferenceKey.tapMode, tapMode);
  }

  @override
  void setWinners(int winners) {
    sharedPref.setInt(SharedPreferenceKey.chooserWinners, winners);
  }

  // Number
  @override
  int getCount() {
    return sharedPref.getInt('count') ?? 1;
  }

  @override
  bool getDuplicateResults() {
    return sharedPref.getBool('is_duplicate') ?? true;
  }

  @override
  int getMaximumRange() {
    return sharedPref.getInt('maximum_range') ?? 10;
  }

  @override
  int getMinimumRange() {
    return sharedPref.getInt('minimum_range') ?? 1;
  }

  @override
  bool getSortResults() {
    return sharedPref.getBool('is_sorted') ?? true;
  }

  @override
  void setCount(int count) {
    sharedPref.setInt('count', count);
  }

  @override
  void setDuplicateResults(bool isDuplicate) {
    sharedPref.setBool('is_duplicate', isDuplicate);
  }

  @override
  void setMaximumRange(int maximum) {
    sharedPref.setInt('maximum_range', maximum);
  }

  @override
  void setMinimumRange(int minimum) {
    sharedPref.setInt('minimum_range', minimum);
  }

  @override
  void setSortResults(bool isSorted) {
    sharedPref.setBool('is_sorted', isSorted);
  }

  // Wheel
  @override
  List<String> getWheelChoices() {
    return sharedPref.getStringList(SharedPreferenceKey.wheelChoices) ?? [];
  }

  @override
  int getWheelDuration() {
    return sharedPref.getInt(SharedPreferenceKey.wheelDuration) ?? 5;
  }

  @override
  bool getWheelLoop() {
    return sharedPref.getBool(SharedPreferenceKey.wheelLoop) ?? false;
  }

  @override
  String getWheelSkin() {
    return sharedPref.getString(SharedPreferenceKey.wheelSkin) ?? 'style1';
  }

  @override
  void setWheelChoices(List<String> wheelChoices) {
    sharedPref.setStringList(SharedPreferenceKey.wheelChoices, wheelChoices);
  }

  @override
  void setWheelDuration(int duration) {
    sharedPref.setInt(SharedPreferenceKey.wheelDuration, duration);
  }

  @override
  void setWheelLoop(bool wheelLoop) {
    sharedPref.setBool(SharedPreferenceKey.wheelLoop, wheelLoop);
  }

  @override
  void setWheelSkin(String wheelSkin) {
    sharedPref.setString(SharedPreferenceKey.wheelSkin, wheelSkin);
  }
  /* --------- */

  /* SYSTEM*/
  @override
  String? getLanguage() {
    return sharedPref.getString(SharedPreferenceKey.language);
  }
  @override
  bool notificationPermission() {
    return sharedPref.getBool(SharedPreferenceKey.notificationPermission) ?? false;
  }

  @override
  void setLanguage(String language) {
    sharedPref.setString(SharedPreferenceKey.language, language);
  }
  @override
  void setNotificationPermission(bool granted) {
    sharedPref.setBool(SharedPreferenceKey.notificationPermission, granted);
  }
  /* --------- */

  /* DATA */

  @override
  void addCardSkin(String skin) {
    sharedPref.setStringList(SharedPreferenceKey.cardRepo, getCardRepo()..add(skin));
  }

  @override
  List<String> getCardRepo() {
    return sharedPref.getStringList(SharedPreferenceKey.cardRepo) ?? [];
  }

  @override
  void addCoinSkin(String skin) {
    sharedPref.setStringList(SharedPreferenceKey.coinRepo, getCoinRepo()..add(skin));
  }

  @override
  List<String> getCoinRepo() {
    return sharedPref.getStringList(SharedPreferenceKey.coinRepo) ?? [];
  }

  @override
  void addWheelSkin(String skin) {
    sharedPref.setStringList(SharedPreferenceKey.wheelRepo, getWheelRepo()..add(skin));
  }

  @override
  List<String> getWheelRepo() {
    return sharedPref.getStringList(SharedPreferenceKey.wheelRepo) ?? [];
  }
}
