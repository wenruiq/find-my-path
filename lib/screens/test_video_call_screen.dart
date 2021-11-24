import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';

import '../widgets/requests/request_icon.dart';

class TestVideoCallScreen extends StatelessWidget {
  static const routeName = '/testcallscreen';

  const TestVideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Agora Call"),
      ),
      body: const Center(
        child: RequestIcon(name: "Nimama"),
      ),
    );
  }
}
