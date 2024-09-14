import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    if (Platform.isAndroid) {
      await _firebaseMessaging.requestPermission();

      final fCMToken = await _firebaseMessaging.getToken();
      print('Android Token: $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } else if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(provisional: true);

      final apnsToken = await _firebaseMessaging.getAPNSToken();
      print('Apple push notification service Token: $apnsToken');
      // final fCMToken = await _firebaseMessaging.getToken();
      // print('iOS FCM Token: $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }
  }
}
