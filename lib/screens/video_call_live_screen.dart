import 'dart:async';

import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import "package:provider/provider.dart";
import "../configs/agora_config.dart";
import "../providers/request_model.dart";
import '../widgets/requests/request_icon.dart';
import 'package:permission_handler/permission_handler.dart';

class TestVideoCallScreen extends StatefulWidget {
  static const routeName = '/testcallscreen';

  const TestVideoCallScreen({Key? key}) : super(key: key);

  @override
  State<TestVideoCallScreen> createState() => _TestVideoCallScreenState();
}

class _TestVideoCallScreenState extends State<TestVideoCallScreen> {
  late StreamSubscription _callSubscription;
  late AgoraClient client;

  bool _agoraLoaded = false;
  bool _isVideoDisabled = false;
  bool _isMicMuted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      String requestID = Provider.of<RequestModel>(context, listen: false).rid;
      String callID = Provider.of<RequestModel>(context, listen: false).cid;

      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appID,
          channelName: callID,
        ),
        agoraChannelData: AgoraChannelData(
          audioProfile: AudioProfile.SpeechStandard,
          videoEncoderConfiguration: VideoEncoderConfiguration(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: VideoFrameRate.Fps30,
            bitrate: 3420,
            orientationMode: VideoOutputOrientationMode.FixedPortrait,
          ),
          enableDualStreamMode: true,
          localPublishFallbackOption: StreamFallbackOptions.VideoStreamLow,
          remoteSubscribeFallbackOption: StreamFallbackOptions.VideoStreamLow,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
      );

      initAgora();

      setState(() {
        _agoraLoaded = true;
      });

      _callSubscription = FirebaseFirestore.instance
          .collection('requests')
          .doc(requestID)
          .collection('call')
          .doc(callID)
          .snapshots()
          .listen((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (!data['isActive'] && !data['isCalling']) {
          client.sessionController.endCall();
          Navigator.pop(context);
        }
      });
    });
  }

  void initAgora() async {
    await client.initialize();
    // client.agoraChannelData.
  }

  @override
  void dispose() {
    _callSubscription.cancel();
    client.sessionController.dispose();
    super.dispose();

    print("Session controller disposed");
  }

  void _handleMicToggle() {
    setState(() {
      _isMicMuted = !_isMicMuted;
    });
    client.sessionController.toggleMute();
  }

  void _handleCameraToggle() async {
    client.sessionController.toggleCamera();
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });

    var status = await Permission.camera.status;
    // if (value.isLocalVideoDisabled && status.isDenied) {
    //   await Permission.camera.request();
    // }
    // value = value.copyWith(isLocalVideoDisabled: !(value.isLocalVideoDisabled));
    // await value.engine?.muteLocalVideoStream(value.isLocalVideoDisabled);
  }

  void _handleEndCall(String requestID, String callID) async {
    DocumentReference videoCallRef =
        FirebaseFirestore.instance.collection('requests').doc(requestID).collection('call').doc(callID);

    await videoCallRef.update({
      'callerID': "",
      'callerName': "",
      'receiverID': "",
      "isActive": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    String requestID = Provider.of<RequestModel>(context, listen: false).rid;
    String callID = Provider.of<RequestModel>(context, listen: false).cid;

    return SafeArea(
      child: Scaffold(
        body: _agoraLoaded
            ? Stack(
                children: <Widget>[
                  AgoraVideoViewer(
                    client: client,
                    showNumberOfUsers: true,
                    layoutType: Layout.floating,
                    showAVState: true,
                    floatingLayoutContainerHeight: MediaQuery.of(context).size.height * 0.15,
                    disabledVideoWidget: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const FittedBox(
                            child: Icon(
                              Icons.person,
                              size: 250,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AgoraVideoButtons(
                    client: client,
                    enabledButtons: const [],
                    extraButtons: [
                      RawMaterialButton(
                        onPressed: _handleMicToggle,
                        child: Icon(
                          _isMicMuted ? Icons.mic_off : Icons.mic,
                          color: _isMicMuted ? Colors.white : Colors.blueAccent,
                          size: 20.0,
                        ),
                        shape: const CircleBorder(),
                        elevation: 2.0,
                        fillColor: _isMicMuted ? Colors.redAccent : Colors.white,
                        padding: const EdgeInsets.all(12.0),
                      ),
                      ElevatedButton(
                        //! onPressed for Decline Call
                        onPressed: () => _handleEndCall(requestID, callID),
                        child: const Icon(
                          Icons.call_end,
                          size: 38,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const CircleBorder(),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(20),
                          ),
                          backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                            if (states.contains(MaterialState.pressed)) return Colors.red[300]; // <-- Splash color
                          }),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () => client.sessionController.switchCamera(),
                        child: const Icon(
                          Icons.switch_camera,
                          color: Colors.blueAccent,
                          size: 20.0,
                        ),
                        shape: const CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(12.0),
                      ),
                      RawMaterialButton(
                        onPressed: _handleCameraToggle,
                        child: Icon(
                          _isVideoDisabled ? Icons.videocam_off : Icons.videocam,
                          color: _isVideoDisabled ? Colors.white : Colors.blueAccent,
                          size: 20.0,
                        ),
                        shape: const CircleBorder(),
                        elevation: 2.0,
                        fillColor: _isVideoDisabled ? Colors.redAccent : Colors.white,
                        padding: const EdgeInsets.all(12.0),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
