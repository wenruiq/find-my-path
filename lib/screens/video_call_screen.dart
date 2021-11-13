import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCallTestScreen extends StatefulWidget {
  const VideoCallTestScreen({Key? key}) : super(key: key);
  static const routeName = '/videocall';

  @override
  _VideoCallTestScreenState createState() => _VideoCallTestScreenState();
}

class _VideoCallTestScreenState extends State<VideoCallTestScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "e1d1c21b2eb64f9e98ffdc9c5c87cd3b",
      channelName: "test",
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Video Call Test'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            AgoraVideoViewer(client: client),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
