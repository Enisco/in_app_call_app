// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_model.dart';
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/home_screen_view.dart';

class FirebaseMessagingServices {
  // Firebase Messaging functions that handle received push notifications

  static late final FirebaseMessaging _messaging;
  //* Functions that start the anser call procedure

  // For handling notification when the app is in foreground (register notification)
  static void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission, received notification being parsed');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received message at foreground: $message');
        LaunchCallModel.answerCallInForeGround(); //A function to be implemeted
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in background but not terminated state
  static void handlePushNotificationAtBackground() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('Received message in BG : $message');
        // LaunchCallModel.answerCallInBackGround();
      },
    );
  }

  static Future _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    LaunchCallModel.answerCallInBackGround();
  }

  // For handling notification when the app is in terminated state (InitialMessage)
  // checkForInitialMessage(BuildContext context) async {
  static handlePushNotificationAtTerminatedState() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // LaunchCallModel.answerCallInBackGround(); //A function to be implemeted
    }
  }

  static void init() {
    print('Initializing all ');
    registerNotification();
    handlePushNotificationAtBackground();
    handlePushNotificationAtTerminatedState();
  }
}
