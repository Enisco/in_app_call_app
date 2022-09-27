import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_model.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/home_screen_view.dart';
import 'package:in_app_call_app/app_two/ui/widgets/buttons.dart';
import 'package:in_app_call_app/app_two/ui/widgets/custom_textfield.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';
import 'package:in_app_call_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

TextEditingController newUserIDController = TextEditingController();
TextEditingController newUserPasswordController = TextEditingController();

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String errMessage = '';
  late StreamSubscription _receivedDataStream;
  final _database = FirebaseDatabase.instance.ref();

  String curent_caller_id = 'No caller yet',
      curent_channel_name = 'No channel',
      curent_token = 'No token yet',
      curent_call_state = 'no',
      curent_call_type = 'none',
      curent_call_direction = 'none';

  final databaseReference = FirebaseDatabase.instance.ref();

  void updateData(String userId, String callerId, String channelName,
      String token, String isCallActive, String callType) {
    databaseReference.child(userId).update(
        {'caller_id': callerId, 'channel_name': channelName, 'token': token});
    databaseReference.child(userId).update({
      'caller_id': callerId,
      'channel_name': channelName,
      'token': token,
      'is_call_active': isCallActive,
      'call_type': callType
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width / 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your preferred ID',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Vspacer(8),
            CustomTextfield(
              textController: newUserIDController,
              labelText:
                  'This is the unique ID friends will be calling you with',
            ),
            Vspacer(size.height / 50),
            const Text(
              'Enter your preferred password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Vspacer(8),
            CustomTextfield(
              textController: newUserPasswordController,
              labelText: 'Enter preferred password',
            ),
            Vspacer(size.height / 10),
            Center(
              child: Text(
                errMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Vspacer(20),
            RectButton(
              icondata: Icons.create,
              text: 'Create Account',
              widthRatio: 0.6,
              pressed: () {
                if (newUserIDController.text.trim() == '') {
                  setState(() {
                    errMessage = 'Enter an ID to continue';
                  });
                } else {
                  setState(() {
                    errMessage = '';
                  });

                  LaunchCallModel.requestPermissions();

                  LaunchCallModel.updateCallData(
                      newUserIDController.text.trim(),
                      curent_caller_id,
                      curent_channel_name,
                      curent_token,
                      curent_call_state,
                      curent_call_type,
                      curent_call_direction);
                  print("Data updated");

                  LaunchCallModel.saveStringValue('current_call_state', 'no');
                  LaunchCallModel.saveStringValue('user_ID', newUserIDController.text.trim());

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreenView(
                        savedUserID: newUserIDController.text.trim(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
