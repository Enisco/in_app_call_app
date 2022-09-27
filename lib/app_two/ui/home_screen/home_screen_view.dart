import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_model.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_widget_view.dart';
import 'package:in_app_call_app/app_two/ui/ongoing%20call%20screens/voice_call_screen.dart';
import 'package:in_app_call_app/app_two/ui/widgets/focus_line.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';
import 'package:in_app_call_app/constants.dart';
import 'package:native_notify/native_notify.dart';

class HomeScreenView extends StatefulWidget {
  String savedUserID;
  HomeScreenView({Key? key, required this.savedUserID}) : super(key: key);

  @override
  State<HomeScreenView> createState() => HomeScreenViewState();
}

class HomeScreenViewState extends State<HomeScreenView> {
  final _androidAppRetain = const MethodChannel("android_app_retain");
  String errMessage = '';
  String? channelName;
  int? uid;

  @override
  void initState() {
    super.initState();
    // FirebaseMessagingServices.init();
    NativeNotify.registerIndieID(widget.savedUserID);
    print('${widget.savedUserID} registered');
    LaunchCallModel.getSavedUserID();
  }

  @override
  void dispose() {
    LaunchCallModel.reciepientIDcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return Future.value(true);
          } else {
            _androidAppRetain.invokeMethod("sendToBackground");
            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            "Call and Message App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            children: [
              Vspacer(30),
              Column(
                children: [
                  Center(
                    child: Text(
                      'Welcome, ${widget.savedUserID}!',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Vspacer(15),
                  Container(
                    // height: 180,
                    padding: EdgeInsets.all(size.width * 0.02),
                    width: size.width * 0.9,
                    child: Column(
                      children: [
                        Vspacer(20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(
                                    0, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Hspacer(4),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    LaunchCallModel.currentPage = 0;
                                  });
                                  LaunchCallModel.onTap(0);
                                },
                                child: Column(
                                  children: [
                                    Vspacer(10),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                          color:
                                              LaunchCallModel.currentPage == 0
                                                  ? kPrimaryColor
                                                  : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 5),
                                    FocusLne(
                                        size, LaunchCallModel.currentPage == 0),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    LaunchCallModel.currentPage = 1;
                                  });
                                  LaunchCallModel.onTap(1);
                                },
                                child: Column(
                                  children: [
                                    Vspacer(10),
                                    Text(
                                      'Message',
                                      style: TextStyle(
                                          color:
                                              LaunchCallModel.currentPage == 1
                                                  ? kPrimaryColor
                                                  : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 5),
                                    FocusLne(
                                        size, LaunchCallModel.currentPage == 1),
                                  ],
                                ),
                              ),
                              Hspacer(4),
                            ],
                          ),
                        ),
                        if (LaunchCallModel.currentPage == 0)
                          const LaunchCallViewWidget(),
                        if (LaunchCallModel.currentPage == 1)
                          Container(
                            height: size.height / 10,
                            width: size.width,
                            color: kPrimaryColor,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String res = '';
  void startAvoiceCall(String savedUserID, String callChannelName,
      String callToken, String dialedReceipientID, String callActionType) {
    print('Navigating to VoiceCall screen');
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => VoiceCallScreen(
          savedUserID: savedUserID,
          callChannelName: callChannelName,
          callToken: callToken,
          receipientID: dialedReceipientID,
          actionType: callActionType,
        ),
      ),
    );
  }

  Future<void> enterCallScreen(
      String savedUserID,
      String callChannelName,
      String callToken,
      String dialedReceipientID,
      String callActionType) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return VoiceCallScreen(
            savedUserID: savedUserID,
            callChannelName: callChannelName,
            callToken: callToken,
            receipientID: dialedReceipientID,
            actionType: callActionType,
          );
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );

    print('Returned message is $result ');
    setState(() {
      LaunchCallModel.res = result;
    });
  }
}
