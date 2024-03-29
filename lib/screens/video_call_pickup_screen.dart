import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import "package:provider/provider.dart";
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';

import "../providers/request_model.dart";
import "../providers/user_model.dart";

class VideoCallPickupScreen extends StatefulWidget {
  static const routeName = '/callpickup';

  const VideoCallPickupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoCallPickupScreen> createState() => _VideoCallPickupScreenState();
}

class _VideoCallPickupScreenState extends State<VideoCallPickupScreen> with SingleTickerProviderStateMixin {
  //* Controller for waves on display photo
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    //* Ringtone, looping is true, requires calling stop() at dispose
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 0.6, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );

    //* Display pic waves effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      lowerBound: 0.5,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    _animationController.dispose();
    super.dispose();
  }

  //* Updates firebase and leaves this screen if user hangs up
  void _endCallFunction(String requestID, String callID) async {
    DocumentReference videoCallRef =
        FirebaseFirestore.instance.collection('requests').doc(requestID).collection('call').doc(callID);

    await videoCallRef.update({
      'callerID': "",
      "callerName": "",
      "receiverID": "",
      "isCalling": false,
      "isDeclined": true,
    });

    Navigator.pop(context);
  }

  //* Updates firebase and brings user to video call page when user accepts
  void _startCallFunction(String requestID, String callID) async {
    DocumentReference videoCallRef =
        FirebaseFirestore.instance.collection('requests').doc(requestID).collection('call').doc(callID);

    await videoCallRef.update({
      "isCalling": false,
      "isActive": true,
    });

    //* Replaces this page with call page on context so when user leaves call return to chat
    Navigator.pushNamedAndRemoveUntil(context, '/call', ModalRoute.withName('/chat'));
  }

  //* Function that returns the ripple effect for _buildRipplingCircle
  Widget _buildWaves(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[100]!.withOpacity(1 - _animationController.value),
      ),
    );
  }

  //* Function that returns the rippling circle widget
  Widget _buildRipplingCircle() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //* Individual wave ripples, use one line for one ripple
            _buildWaves(225 * _animationController.value),
            _buildWaves(275 * _animationController.value),
            // _buildWaves(275 * _animationController.value),
            _buildWaves(325 * _animationController.value),
            // _buildWaves(325 * _animationController.value),
            Align(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[500],
                ),
                child: const Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String callerName;
    String requestID = Provider.of<RequestModel>(context, listen: false).rid;
    String callID = Provider.of<RequestModel>(context, listen: false).cid;

    //* callerName is passed in from chat room
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    callerName = arguments['callerName'] ?? "Unknown";

    return Scaffold(
      body: Container(
        //* Padding controls how close the two action buttons are to each other
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //* Linear Gradient configures background color of this screen
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        //* Stack contains the rippling circle - at the center, and a column
        child: Stack(
          children: <Widget>[
            _buildRipplingCircle(),

            //* Column axis alignments control the positioning of the call header and action buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    //* Styling for Incoming Call Text
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        "Incoming Call",
                        semanticsLabel: "Incoming Call From $callerName",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    //* Styling for caller name text (uses Marquee for long name handling)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: AutoSizeText(
                        callerName,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        minFontSize: 35,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                        overflowReplacement: SizedBox(
                          height: 45,
                          child: Marquee(
                            text: callerName,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            scrollAxis: Axis.horizontal,
                            velocity: 25,
                            blankSpace: 10,
                            startAfter: const Duration(
                              milliseconds: 200,
                            ),
                            pauseAfterRound: const Duration(
                              seconds: 1,
                              milliseconds: 500,
                            ),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            fadingEdgeEndFraction: 0.1,
                            fadingEdgeStartFraction: 0.1,
                            showFadingOnlyWhenScrolling: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //* This sized box further defines the vertical positioning of incoming call text and action buttons
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),

                //* Row contains two columns - each column being the action button + the label underneath it
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //* Decline Call Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Semantics(
                            label: "Decline call and return to chat room",
                            child: ElevatedButton(
                              //! onPressed for Decline Call
                              onPressed: () => _endCallFunction(requestID, callID),
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
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.red[300]; // <-- Splash color
                                }),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Decline",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),

                    //* Accept Call Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Semantics(
                            label: "Accept and enter video call",
                            child: ElevatedButton(
                              //! onPressed for accept call
                              onPressed: () => _startCallFunction(requestID, callID),
                              child: const Icon(
                                Icons.call,
                                size: 38,
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  const CircleBorder(),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20),
                                ),
                                backgroundColor: MaterialStateProperty.all(Colors.green), // <-- Button color
                                overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                  if (states.contains(MaterialState.pressed)) Colors.green[300]; // <-- Splash color
                                }),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Accept",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
