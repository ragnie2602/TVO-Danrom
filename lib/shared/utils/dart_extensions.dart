import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  dynamic get arguments => ModalRoute.of(this)?.settings.arguments;

  dynamic showAppDialog(Dialog dialog, {bool barrierDismissible = true}) =>
      showDialog(context: this, builder: (context) => dialog, barrierDismissible: barrierDismissible);

  void pop([dynamic result]) {
    if (Navigator.of(this).canPop()) Navigator.of(this).pop(result);
  }

  ensureVisible() {
    Scrollable.ensureVisible(this, duration: const Duration(milliseconds: 200), alignment: 0.1);
  }
}
