// ignore_for_file: public_member_api_docs, use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_call_app/app_two/app_def_two.dart';
import 'package:in_app_call_app/app_two/services/firebase_mesging_services.dart';
import 'package:in_app_call_app/constants.dart';
import 'package:in_app_call_app/just_test.dart';
import 'package:native_notify/native_notify.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

SharedPreferences? prefs;
String? userIDsaved;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await Firebase.initializeApp();
  FirebaseMessagingServices.init();
  NativeNotify.initialize(nnAppID, nnAppToken, firebaseServerKey, null);

  final prefs = await SharedPreferences.getInstance();
  final String? currentUserID = prefs.getString('user_ID');
  bool accountExisting;
  if (currentUserID == null || currentUserID == '') {
    accountExisting = false;
    userIDsaved = '';
  } else {
    accountExisting = true;
    userIDsaved = currentUserID;
  }
  runApp(MyAppTwo(accountExisting: accountExisting, userIDsaved: userIDsaved!));
  // runApp(const ExampleApp());
  // const int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(minutes: 1), helloAlarmID, doNothing);
}

void doNothing() {}
