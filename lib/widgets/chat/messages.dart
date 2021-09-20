import "package:flutter/material.dart";

import "./message_bubble.dart";

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Testing yo!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('321DDDDW')),
        MessageBubble(
            imageURL: '',
            senderName: 'Lifu',
            msgText: 'Testing yo!',
            msgTime: '21:00',
            isMe: false,
            msgType: 'text',
            key: Key('21s12d2')),
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Wassup man!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('d2d23')),
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Wassup man!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('d2d23')),
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Wassup man!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('d2d23')),
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Wassup man!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('d2d23')),
        MessageBubble(
            imageURL: '',
            senderName: 'Wenrui',
            msgText: 'Wassup man!',
            msgTime: '21:00',
            isMe: true,
            msgType: 'text',
            key: Key('d2d23')),
      ],
    );
  }
}
