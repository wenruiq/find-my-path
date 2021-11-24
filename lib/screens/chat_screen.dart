import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import "package:provider/provider.dart";

import "../providers/request_model.dart";
import "../providers/user_model.dart";
import "../screens/loading_screen.dart";
import "../widgets/util/loading.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  //* Need this to handle messages sent by myself
  void _handleSendPressed(types.PartialText message) async {
    Map<String, dynamic> userData = Provider.of<UserModel>(context, listen: false).data;
    Map<String, dynamic> requestData = Provider.of<RequestModel>(context, listen: false).data;
    String requestID = requestData['rid'];
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("requests").doc(requestID).collection('messages').doc();
    String docID = docRef.id;
    Map<String, dynamic> messageData = {
      'author': {'id': userData['uid'], 'firstName': userData['displayName']},
      'createdAt': DateTime.now(),
      'text': message.text,
      'id': docID,
      'type': 'text'
    };
    await docRef.set(messageData);
  }

  //* Convert Firebase List<DocumentSnapshot> to List<types.Message> for display
  List<types.Message> processFirebaseMessages(List<DocumentSnapshot> messagesList) {
    List<types.Message> messagesListProcessed = messagesList.map((DocumentSnapshot messageDoc) {
      Map<String, dynamic> dataMap = messageDoc.data() as Map<String, dynamic>;
      final author = types.User(id: dataMap['author']['id'], firstName: dataMap['author']['firstName']);
      if (dataMap['type'] == 'text') {
        int createdAt = dataMap['createdAt'].toDate().millisecondsSinceEpoch;
        String id = dataMap['id'];
        String text = dataMap['text'];
        return types.TextMessage(author: author, createdAt: createdAt, id: id, text: text);
      }
      //TODO: Handle other types of messages
      return types.TextMessage(
          author: author,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "123456",
          text: "This message has a type that's not handled.");
    }).toList();
    return messagesListProcessed;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> myUserData = Provider.of<UserModel>(context, listen: false).data;
    bool imVolunteer = myUserData['isVolunteer'];
    final _user = types.User(id: myUserData['uid'], firstName: myUserData['displayName']);
    Map<String, dynamic> requestData = Provider.of<RequestModel>(context, listen: false).data;
    String requestID = requestData['rid'];
    DocumentReference requestRef = FirebaseFirestore.instance.collection("requests").doc(requestID);
    //* FutureBuilder to get latest assignment data before page loads
    return FutureBuilder(
      future: requestRef.get(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          //* Latest data obtained
          dynamic snapshotData = snapshot.data;
          Map<String, dynamic> latestRequestData = snapshotData.data();
          print("Latest Request Data:");
          print(latestRequestData);
          String hisDisplayName =
              imVolunteer ? latestRequestData['VI_displayName'] : latestRequestData['VO_displayName'];
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(hisDisplayName),
                )),
            //* StreamBuilder to listen to new messages
            body: StreamBuilder(
              stream: requestRef.collection("messages").orderBy("createdAt", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //* Process data from Firebase
                  QuerySnapshot messagesQuerySnapshot = snapshot.data as QuerySnapshot;
                  List<DocumentSnapshot> messagesList = messagesQuerySnapshot.docs;
                  //* Convert data to List<types.Message>
                  //* Chat() Widget uses this List<types.Message> to build messages for display
                  List<types.Message> messagesListProcessed = processFirebaseMessages(messagesList);
                  return SafeArea(
                    bottom: false,
                    child: Chat(
                      messages: messagesListProcessed,
                      onSendPressed: _handleSendPressed,
                      user: _user,
                      showUserNames: true,
                      theme: DefaultChatTheme(
                        inputBackgroundColor: Colors.grey.shade100,
                        inputTextColor: Colors.black,
                        inputTextCursorColor: Colors.black,
                        primaryColor: const Color(0xff4a67a0),
                        userAvatarNameColors: [Theme.of(context).primaryColor],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
