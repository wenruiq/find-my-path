import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:math';
import 'dart:convert';

import "../widgets/chat/messages.dart";
import "../widgets/chat/new_message.dart";
import "../widgets/util//dismiss_keyboard.dart";

// For the testing purposes, you should probably use https://pub.dev/packages/uuid
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');

  final _otherUser = types.User(firstName: 'lols', lastName: "haha", id: 'dnskajdsa');

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _otherUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(builder: (context, snapshot) {
        return SafeArea(
          bottom: false,
          child: Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
            showUserNames: true,
            theme: DefaultChatTheme(inputBackgroundColor: Theme.of(context).primaryColor),
          ),
        );
      }),
    );
    // return DismissKeyboard(
    //   child: SafeArea(
    //     child: Scaffold(
    //       appBar: AppBar(
    //         title: const Text('Craig'),
    //         actions: [
    //           DropdownButton(
    //             underline: Container(),
    //             icon: Icon(
    //               Icons.more_vert,
    //               color: Theme.of(context).primaryIconTheme.color,
    //             ),
    //             items: [
    //               DropdownMenuItem(
    //                 child: Row(
    //                   children: const <Widget>[
    //                     Icon(Icons.exit_to_app),
    //                     SizedBox(width: 8),
    //                     Text('Logout'),
    //                   ],
    //                 ),
    //                 value: 'logout',
    //               ),
    //             ],
    //             onChanged: (itemIdentifier) {
    //               if (itemIdentifier == 'logout') {
    //                 FirebaseAuth.instance.signOut();
    //               }
    //             },
    //           ),
    //         ],
    //       ),
    //       body: Container(
    //         child: Column(
    //           children: const <Widget>[
    //             Expanded(
    //               child: Messages(),
    //             ),
    //             const Divider(thickness: 1),
    //             NewMessage(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
