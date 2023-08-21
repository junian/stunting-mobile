import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'controller/SessionController.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final sessionController = Get.put(SessionController());

  @pragma('vm:entry-point')
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  }

  Future<void> requestPermission() async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> initNotifications() async {
    // await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    sessionController.setToken(fCMToken.toString());
    print('token = $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
