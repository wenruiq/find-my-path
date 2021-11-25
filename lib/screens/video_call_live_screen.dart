import 'dart:async';

import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:agora_uikit/agora_uikit.dart';
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
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
      );

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
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _callSubscription.cancel();
    super.dispose();
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

    return Scaffold(
      body: _agoraLoaded
          ? Stack(
              children: <Widget>[
                AgoraVideoViewer(
                  client: client,
                  showNumberOfUsers: true,
                ),
                AgoraVideoButtons(
                  client: client,
                  enabledButtons: const [
                    BuiltInButtons.toggleCamera,
                    BuiltInButtons.switchCamera,
                    BuiltInButtons.toggleMic,
                  ],
                  extraButtons: [
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
                  ],
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
