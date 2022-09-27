// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:in_app_call_app/app_two/services/native_notify_services.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/home_screen_view.dart';
import 'package:in_app_call_app/app_two/ui/ongoing%20call%20screens/voice_call_screen.dart';
import 'package:in_app_call_app/video_call_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
int changesCount = 0;
var textEvents = "";

class LaunchCallModel {
  static TextEditingController reciepientIDcontroller = TextEditingController();
  static late StreamSubscription _receivedDataStream;
  static String callStatusString = 'Connecting. . .',
      launchingCalltring = '',
      errMessage = '';
  static String? channelName;
  static int? uid;
  static int currentPage = 0;
  // static BuildContext? context;

  static void saveStringValue(String stringKey, String stringValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(stringKey, stringValue);
    print('Saved $stringKey as $stringValue');
  }

  // Get any saved String value
  static Future<String> getSavedString(String stringKey) async {
    final prefs = await SharedPreferences.getInstance();
    final String? readValue = prefs.getString(stringKey);
    print('Retrieved value for $stringKey is $readValue.');
    return readValue ?? '';
  }

  // Get the saved User ID
  static void getSavedUserID() async {
    savedUserID = await getSavedString('user_ID');
    print('My saved UserID is $savedUserID.');
  }

  // Get the saved call state
  static void getSavedCallState() async {
    launchCallState = await getSavedString('current_call_state');
    print('My saved call state is $launchCallState.');
  }

  static Future<void> handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  static void requestPermissions() async {
    await handleCameraAndMic(Permission.camera);
    await handleCameraAndMic(Permission.microphone);
  }

  static String curent_caller_id = 'No caller yet',
      curent_channel_name = 'No channel',
      curent_token = 'No token yet',
      curent_call_state = 'no',
      curent_call_type = 'No active call yet',
      curent_call_direction = 'No active call yet';

  static final databaseReference = FirebaseDatabase.instance.ref();
  static String? savedUserID, launchCallState;
  static bool isCallStillActive = false;

  // Show InComing Call function
  static Future<void> showInComingCall(String callerID,
      String callerChannelName, String callerToken, String callType) async {
    await Future.delayed(
      const Duration(seconds: 2),
      () async {
        var params = <String, dynamic>{
          'id': 1,
          'nameCaller': callerID,
          'appName': 'Callkit',
          'avatar':
              'https://images.pexels.com/photos/338713/pexels-photo-338713.jpeg',
          'handle': '$callType call',
          'type': 0,
          'duration': 30000,
          'extra': <String, dynamic>{'userId': '1a2b3c4d'},
          'android': <String, dynamic>{
            'isCustomNotification': true,
            'isShowLogo': false,
            'ringtonePath': 'ringtone_default',
            'backgroundColor': '#0955fa',
            'background':
                'https://images.pexels.com/photos/3894157/pexels-photo-3894157.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            'actionColor': '#4CAF50'
          },
          'ios': <String, dynamic>{
            'iconName': 'AppIcon40x40',
            'handleType': '',
            'supportsVideo': true,
            'maximumCallGroups': 2,
            'maximumCallsPerCallGroup': 1,
            'audioSessionMode': 'default',
            'audioSessionActive': true,
            'audioSessionPreferredSampleRate': 44100.0,
            'audioSessionPreferredIOBufferDuration': 0.005,
            'supportsDTMF': true,
            'supportsHolding': true,
            'supportsGrouping': false,
            'supportsUngrouping': false,
            'ringtonePath': 'Ringtone.caf'
          }
        };
        await FlutterCallkitIncoming.showCallkitIncoming(params);
        FlutterCallkitIncoming.onEvent.listen(
          (event) async {
            switch (event!.name) {
              case CallEvent.ACTION_CALL_ACCEPT:
                callStatusString = 'In call';
                print('Call accepted');
                if (callType == 'video') {
                  // startVideoCall(context, callerChannelName, callerToken,
                  //     curent_caller_id, 'accept');
                } else {
                  startVoiceCall(callerChannelName, callerToken,
                      curent_caller_id, 'accept');

                  // FlutterForegroundTask.launchApp();
                }
                break;
              case CallEvent.ACTION_CALL_DECLINE:
                var params = <String, dynamic>{'id': callerID};
                await FlutterCallkitIncoming.endCall(params);
                print('Call declined');
                break;
              case CallEvent.ACTION_CALL_ENDED:
                var params = <String, dynamic>{'id': callerID};
                await FlutterCallkitIncoming.endCall(params);
                break;
              case CallEvent.ACTION_CALL_CALLBACK:
                print('Call back');
                //callBack();  //TODO
                break;
            }
          },
        );
      },
    );
  }

  static void startVideoCall(BuildContext context, String callChannelName,
      String callToken, String dialedReceipientID, String callActionType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCall(
          channelName: callChannelName,
          callToken: callToken,
          role: ClientRole.Broadcaster,
          savedUserID: savedUserID!,
          receipientID: dialedReceipientID,
        ),
      ),
    );
  }

  static String res = '';
  static void startVoiceCall(String callChannelName, String callToken,
      String dialedReceipientID, String callActionType) {
    print('startVoiceCall');

    // print('Navigating to VoiceCall screen');

    FlutterForegroundTask.launchApp();
    print('Navigated to HomeScreen, launching VoiceCall screen');

    Get.to(
      () => VoiceCallScreen(
        savedUserID: savedUserID!,
        callChannelName: callChannelName,
        callToken: callToken,
        receipientID: dialedReceipientID,
        actionType: callActionType,
      ),
    );
  }

  //Generate a random uid
  static int generateRandomUid() {
    Random random = Random();
    int randomNumber = random.nextInt(20000);
    return randomNumber;
  }

  // Generate a new call Token
  static Future<String> getRefreshCallToken(
      String newChannelName, int uID) async {
    String generatedToken = '';
    String queryText = '$newChannelName~$uID';
    print('queryText: $queryText');
    print(
        'https://agora-token-server-enisco.herokuapp.com/get-token/$queryText');

    try {
      var response = await Dio().get(
          'https://agora-token-server-enisco.herokuapp.com/get-token/$queryText');
      generatedToken = response.toString();
      print('Token: $generatedToken');
    } catch (e) {
      print('error: $e');
      generatedToken = 'error';
    }
    if (generatedToken != curent_token &&
        generatedToken != '' &&
        generatedToken != 'error') {
      curent_token = generatedToken;
    }
    return generatedToken;
  }

  // Update data in Firebase Realtime DB
  static void updateCallData(
      String receipientUserId,
      String callerUserId,
      String channelName,
      String token,
      String isCallActive,
      String call_type,
      String call_direction) {
    databaseReference.child(receipientUserId).update({
      'caller_id': callerUserId,
      'channel_name': channelName,
      'token': token,
      'is_call_active': isCallActive,
      'call_type': call_type,
      'call_direction': call_direction
    });
    print('Reciepient $receipientUserId\'s Call Data updated');
  }

  static Future listenRt(String userId) async {
    await Firebase.initializeApp();

    DatabaseReference dataChangesRef = FirebaseDatabase.instance.ref(userId);
    print(('ListenRt function invoked'));

    dataChangesRef.onValue.listen((DatabaseEvent event) {
      changesCount += 1;
      print("changesCount = $changesCount");
      print("Reading from $userId");
      final database = FirebaseDatabase.instance.ref();
      database.child(userId).onValue.listen((event) {
        final data = event.snapshot.value;
        print('RTDB data: $data');
      });
      _receivedDataStream =
          database.child(userId).onValue.listen((event) async {
        var dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        curent_caller_id = dataMap['caller_id'];
        curent_channel_name = dataMap['channel_name'];
        curent_token = dataMap['token'];
        curent_call_state = dataMap['is_call_active'];
        curent_call_type = dataMap['call_type'];
        curent_call_direction = dataMap['call_direction'];
        print(
            'curent_caller_id: $curent_caller_id\ncurent_channel_name: $curent_channel_name\ncurent_token: $curent_token\ncurent_call_state: $curent_call_state\ncurent_call_type: $curent_call_type');

        if (curent_call_state == 'yes' && curent_call_direction == 'incoming') {
          showInComingCall(curent_caller_id, dataMap['channel_name'],
              dataMap['token'], dataMap['call_type']);
          print('is_call_active: $curent_call_state');
        } else {
          //* To be implemmted with local_notifications:
          //showMissedCallNotification()
          print('is_call_active: $curent_call_state');
        }
      });
    });
  }

  // Send empty Indie Push Notification,
  // notification will be received silently at the other end
  static void sendIndiePushNotificationCall() {
    NativeNotifyServices.sendCallIndiePushNotification(
        reciepientIDcontroller.text.trim());
    print('Indie notification sent to ${reciepientIDcontroller.text.trim()}');
  }

  static void sendIndiePushNotificationMessage() {
    NativeNotifyServices.sendMessageIndiePushNotification(
        reciepientIDcontroller.text.trim());
  }

  static void onTap(int index) {
    currentPage = index;
  }

  static Future<void> startCallProcedure(
      BuildContext context, String callType) async {
    if (reciepientIDcontroller.text.trim() == '' ||
        reciepientIDcontroller.text.trim().isEmpty) {
      errMessage = 'Enter a valid receipient ID to launch call';
      launchingCalltring = '';
    } else if (reciepientIDcontroller.text.trim() == savedUserID) {
      errMessage = 'Error! You cannot call yourself';
      launchingCalltring = '';
    } else {
      launchingCalltring = 'Launching call. . .';
      requestPermissions();

      errMessage = '';
      uid = generateRandomUid();
      channelName =
          '$savedUserID${reciepientIDcontroller.text.trim()}channel$uid';
      curent_channel_name = channelName!;
      callStatusString = 'Ringing. . .';

      // final newCallToken =
      await getRefreshCallToken(channelName!, 0);
      print(curent_token);
      String activeToken = curent_token;
      updateCallData(savedUserID!, savedUserID!, channelName!, activeToken,
          'yes', callType, 'outgoing');
      updateCallData(reciepientIDcontroller.text.trim(), savedUserID!,
          channelName!, activeToken, 'yes', callType, 'incoming');

      sendIndiePushNotificationCall();

      String instantCallChannel = curent_channel_name;
      String instantCallToken = curent_token;
      print('instantCallChannel: $instantCallChannel');
      print('instantCallToken: $instantCallToken');

      if (callType == 'video') {
        startVideoCall(context, curent_channel_name, curent_token,
            reciepientIDcontroller.text.trim(), 'launch');
      } else {
        startVoiceCall(curent_channel_name, curent_token,
            reciepientIDcontroller.text.trim(), 'launch');
      }
    }
  }

  static void receiveCallProcedure() async {
    saveStringValue('launch_call', 'true');
    print('Incoming Call Notification Received\n\n');
    getSavedUserID();
    print('Refreshed savedUserID: $savedUserID \n\n');
    listenRt(savedUserID!);
  }

  static void answerCallInForeGround() {
    print('answerCallInForeGround\n\n\n');
    receiveCallProcedure();
  }

  static void answerCallInBackGround() {
    print('answerCallInBackGround\n\n\n');
    receiveCallProcedure();
  }
}
