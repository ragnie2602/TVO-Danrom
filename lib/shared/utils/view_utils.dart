import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewUtils {
  static GlobalKey<NavigatorState>? _rootNavigatorKey;
  static void unFocusView() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static GlobalKey<NavigatorState> getRootNavigatorKey() => _rootNavigatorKey ??= GlobalKey<NavigatorState>();
}

toastInformation(String text) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    fontSize: 16.0);
