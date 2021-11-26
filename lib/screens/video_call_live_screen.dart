import 'dart:async';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import "package:provider/provider.dart";
import 'package:permission_handler/permission_handler.dart';

import "../configs/agora_config.dart";
import "../providers/request_model.dart";

class VideoCallScreen extends StatefulWidget {
  static const routeName = '/call';

  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late StreamSubscription _callSubscription;
  late AgoraClient client;

  //* local state for displaying loader / toggling video call control button UI
  bool _agoraLoaded = false;
  bool _isVideoDisabled = false;
  bool _isMicMuted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      String requestID = Provider.of<RequestModel>(context, listen: false).rid;
      String callID = Provider.of<RequestModel>(context, listen: false).cid;

      //* Initialize Agora Client
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appID,
          channelName: callID,
        ),
        //* Configure video call settings
        //* REF - https://docs.agora.io/en/Interactive%20Broadcast/video_profile_android?platform=Android
        agoraChannelData: AgoraChannelData(
          //* Increases capturing of human voice
          audioProfile: AudioProfile.SpeechStandard,
          //* Increase this to increase video quality
          videoEncoderConfiguration: VideoEncoderConfiguration(
            dimensions: VideoDimensions(width: 1280, height: 720),
            frameRate: VideoFrameRate.Fps30,
            bitrate: 3420,
            //* Prevents users from changing their display orientation
            orientationMode: VideoOutputOrientationMode.FixedPortrait,
          ),
          //* Displays higher quality video if possible
          enableDualStreamMode: true,
          //* Makes stream fallback to low resolution stream instead of completely disconnecting when network is bad
          localPublishFallbackOption: StreamFallbackOptions.VideoStreamLow,
          remoteSubscribeFallbackOption: StreamFallbackOptions.VideoStreamLow,
        ),
        //* Pass in permissions status for Agora to prompt users for permissions if necessary
        //? Not sure if receiver of call will have errors if permissions not enabled, dont think so
        //? As the permissions are manually asked when user click the video call button, hence
        //? the person receiving the call does not have that
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
      );

      //* async function to initialize the AgoraClient (aka connect to server)
      initAgora();

      //* Change page from loading to actual UI
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

        //* Returns both users in the call to the chat screen
        //* This condition is only met when one user hangs up
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
  }

  //* Extraction of Agora UI Kit's mic toggle function as the UI is not updating
  void _handleMicToggle() {
    client.sessionController.toggleMute();
    setState(() {
      _isMicMuted = !_isMicMuted;
    });
  }

  //* Extraction of Agora UI Kit's camera toggle function as the UI is not updating
  void _handleCameraToggle() async {
    client.sessionController.toggleCamera();
    setState(() {
      _isVideoDisabled = !_isVideoDisabled;
    });
  }

  //* Method to update firestore that one user has ended call, listener in initState will kick user out of this screen
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
        backgroundColor: Colors.black,
        body: _agoraLoaded
            ? Stack(
                children: <Widget>[
                  //* Video Call UI template
                  AgoraVideoViewer(
                    client: client,
                    layoutType: Layout.floating,
                    showAVState: true,
                    //* Defines the top layer (smaller vid) size
                    floatingLayoutContainerHeight: MediaQuery.of(context).size.height * 0.15,
                    //* Custom disabled video widget design
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
                  //* Video Call Buttons UI - replaced buttons with their buttons from source code
                  AgoraVideoButtons(
                    client: client,
                    //* List is empty to remove default buttons
                    enabledButtons: const [],
                    extraButtons: [
                      //* Toggle Mic Button
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
                      //* End Call Button
                      ElevatedButton(
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
                      //* Switch Camera Button
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
                      //* Toggle Camera On/Off button
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
            //* Loader if agora not initialized
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
