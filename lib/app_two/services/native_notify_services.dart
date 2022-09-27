import 'package:in_app_call_app/constants.dart';
import 'package:native_notify/native_notify.dart';

class NativeNotifyServices {
  static void registerUserIndieID(String userID) {
    NativeNotify.registerIndieID(userID);
    print('NativeNotifyServices: $userID registered successfully');
  }

  static void sendCallIndiePushNotification(String receiverSub) {
    NativeNotify.sendIndieNotification(
        1212, nnAppToken, receiverSub, '', '', null, null);
    print('$receiverSub has been sent a call notification');
  }

  static void sendMessageIndiePushNotification(String receiverSub) {
    NativeNotify.sendIndieNotification(
        1212, nnAppToken, receiverSub, 'NN Message', '', null, null);
    print('$receiverSub has been sent a messge notification');
  }
}
