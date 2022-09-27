import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_model.dart';
import 'package:in_app_call_app/app_two/ui/widgets/buttons.dart';
import 'package:in_app_call_app/app_two/ui/widgets/custom_textfield.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';

// ignore: non_constant_identifier_names
class LaunchCallViewWidget extends StatefulWidget {
  const LaunchCallViewWidget({Key? key}) : super(key: key);

  @override
  State<LaunchCallViewWidget> createState() => _LaunchCallViewWidgetState();
}

class _LaunchCallViewWidgetState extends State<LaunchCallViewWidget> {
  @override
  void initState() {
    super.initState();
    setState(() {
      LaunchCallModel.launchingCalltring;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Vspacer(size.height / 15),
        const Text(
          'Enter reciepient\'s ID',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Vspacer(12),
        CustomTextfield(
          textController: LaunchCallModel.reciepientIDcontroller,
          labelText: 'Enter the ID of the person you want to call',
        ),
        Vspacer(size.height / 20),
        Center(
          child: Text(
            LaunchCallModel.errMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        Vspacer(10),
        RectButton(
          text: 'Voice Call',
          color: Colors.blue.shade800,
          icondata: CupertinoIcons.phone_arrow_up_right,
          pressed: () async {
            LaunchCallModel.startCallProcedure(context, 'voice');
            // setState(() {
            //   LaunchCallModel.launchingCalltring = '';
            // });
          },
        ),
        Vspacer(size.height / 15),
        Text(
          LaunchCallModel.launchingCalltring,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.amber[700],
          ),
        ),
      ],
    );
  }
}
