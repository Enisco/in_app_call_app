import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/call/launch_call_model.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';
import 'package:in_app_call_app/constants.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class VoiceCallScreen extends StatefulWidget {
  String callToken, callChannelName, receipientID, savedUserID, actionType;

  VoiceCallScreen(
      {Key? key,
      required this.callChannelName,
      required this.callToken,
      required this.receipientID,
      required this.savedUserID,
      required this.actionType})
      : super(key: key);

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool useLoudSpeaker = false;
  RtcEngine? _engine;
  bool endOngoingCall = false;

  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine?.leaveChannel();
    _engine?.destroy();
    controller?.disposeTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set speaker to earpiece
    _engine?.setEnableSpeakerphone(useLoudSpeaker);
    // initialize agora sdk
    initialize();
    controller =
        CountdownTimerController(endTime: endTime, onEnd: noAnswerToCall);
    if (widget.actionType == 'launch') {
      playOutgoingCallTone();
    }
  }

  Future<void> initialize() async {
    var appId = agoraAppID;
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine?.joinChannel(
        widget.callToken, widget.callChannelName, null, 0);
  }

  void playOutgoingCallTone() async {
    await FlutterRingtonePlayer.play(
        fromAsset: "ringtones/outgoing_ringtone.mp3", looping: true);
  }

  void endRing() {
    FlutterRingtonePlayer.stop();
    controller?.disposeTimer();
    print('No answer');
  }

  void noAnswerToCall() {
    endRing();
    endCall(context);
  }

  void endCall(BuildContext context) {
    endRing();
    LaunchCallModel.updateCallData(
        widget.receipientID, 'none', 'none', 'none', 'no', 'none', 'none');
    LaunchCallModel.updateCallData(
        widget.savedUserID, 'none', 'none', 'none', 'no', 'none', 'none');

    _users.clear();
    _engine?.leaveChannel();
    _engine?.destroy();
    Navigator.pop(context, 'done');
  }

  void toggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine?.muteLocalAudioStream(muted);
  }

  void toggleSpeaker() {
    _engine?.setEnableSpeakerphone(!useLoudSpeaker).then((value) {
      setState(() {
        useLoudSpeaker = !useLoudSpeaker;
      });
    }).catchError((err) {
      print('setEnableSpeakerphone $err');
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(agoraAppID);
    await _engine?.enableAudio();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine?.setEventHandler(RtcEngineEventHandler(
        error: (code) {},
        joinChannelSuccess: (channel, uid, elapsed) {
          print('Successfully joined channel: $channel');
        },
        leaveChannel: (stats) {
          print('I left channel!!!!!');
          endCall(context);
        },
        userJoined: (uid, elapsed) {
          endRing();
          setState(() {
            LaunchCallModel.callStatusString = 'In call';
          });
        },
        userOffline: (uid, elapsed) {
          print('User left channel!!!!!');
          endCall(context);
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.receipientID),
        centerTitle: true,
        leading: InkWell(
          onTap: Navigator.of(context).pop,
          child: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/call_bg3.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Positioned(
                top: size.height * 0.55,
                left: size.width * 0.45,
                child: CountdownTimer(
                    controller: controller,
                    onEnd: noAnswerToCall,
                    endTime: endTime,
                    widgetBuilder: (context, time) {
                      if (time == null) {
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          endCall(context);
                        });
                        return const Text('No answer');
                      }

                      print('Continue playing ringtone');
                      return Text(
                        LaunchCallModel.callStatusString,
                        style:
                            const TextStyle(color: Colors.amber, fontSize: 14),
                      );
                    }),
              ),
              Positioned(
                top: size.height / 3.5,
                left: size.width / 3.5,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 5),
                    color: Colors.green,
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('images/dp2.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: SizedBox(
                  width: size.width,
                  // alignment: Alignment.bottomCenter,
                  child: Center(child: toolbar(context)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget toolbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Hspacer(25),
        RawMaterialButton(
          onPressed: toggleMute,
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: muted ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: muted ? Colors.white : Colors.blueAccent,
            size: 20.0,
          ),
        ),
        RawMaterialButton(
          onPressed: () => endCall(context),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.redAccent,
          padding: const EdgeInsets.all(15.0),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        RawMaterialButton(
          onPressed: toggleSpeaker,
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: useLoudSpeaker ? Colors.blueAccent : Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            useLoudSpeaker
                ? CupertinoIcons.speaker_2
                : CupertinoIcons.speaker_slash,
            color: useLoudSpeaker ? Colors.white : Colors.blueAccent,
            size: 20.0,
          ),
        ),
        Hspacer(25),
      ],
    );
  }
}
