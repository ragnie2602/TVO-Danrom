abstract class LocalDataAccess {
  /* FUNCTION */

  // Card
  void clearCardSkin();
  void clearCardLoop();

  bool getCardLoop();
  String getCardSkin();
  String getCoinSkin();

  void setCardLoop(bool cardLoop);
  void setCardSkin(String cardSkin);
  void setCoinSkin(String coinSkin);

  // Chooser
  bool getTapMode();
  int getWinners();

  void setTapMode(bool tapMode);
  void setWinners(int winners);

  // Number
  int getCount();
  bool getDuplicateResults();
  int getMaximumRange();
  int getMinimumRange();
  bool getSortResults();

  void setCount(int count);
  void setDuplicateResults(bool isDuplicate);
  void setMaximumRange(int maximum);
  void setMinimumRange(int minimum);
  void setSortResults(bool isSorted);

  // Wheel
  List<String> getWheelChoices();
  int getWheelDuration();
  bool getWheelLoop();
  String getWheelSkin();

  void setWheelChoices(List<String> wheelChoices);
  void setWheelDuration(int duration);
  void setWheelLoop(bool wheelLoop);
  void setWheelSkin(String wheelSkin);
  /* -------------- */

  /* SYSTEM */
  String? getLanguage();
  bool notificationPermission();

  void setLanguage(String language);
  void setNotificationPermission(bool granted);
  /* -------------- */

  /* DATA */
  void addCoinSkin(String skin);
  List<String> getCoinRepo();

  void addCardSkin(String skin);
  List<String> getCardRepo();

  void addWheelSkin(String skin);
  List<String> getWheelRepo();
}
