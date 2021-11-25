import 'dart:async';
import "dart:io";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import "package:provider/provider.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import 'package:ionicons/ionicons.dart';
import "package:transparent_image/transparent_image.dart";
import 'package:permission_handler/permission_handler.dart';

import "../providers/request_model.dart";
import "../providers/user_model.dart";
import "../screens/loading_screen.dart";
import "../widgets/stream_indicator/pulsing_indicator.dart";
import "../../args/hero_image_screen_args.dart";
import "../widgets/location/live_location_map.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamSubscription _statusSubscription;
  late StreamSubscription _callSubscription;

  @override
  void initState() {
    super.initState();

    //TODO: Chat Screen seems to load multiple times from queryLoading -> chat screen (logged 3 builds), need find out why
    //* Handles navigation when the other party exits the room
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      String requestID = Provider.of<RequestModel>(context, listen: false).rid;
      String callID = Provider.of<RequestModel>(context, listen: false).cid;
      String userID = Provider.of<UserModel>(context, listen: false).uid;
      bool imVolunteer = Provider.of<UserModel>(context, listen: false).isVolunteer;

      _statusSubscription =
          FirebaseFirestore.instance.collection('requests').doc(requestID).snapshots().listen((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data['status'] == "Completed") {
          if (!imVolunteer) {
            Navigator.pushNamedAndRemoveUntil(context, '/review', ModalRoute.withName('/'));
          } else if (imVolunteer) {
            Navigator.of(context).pop();
          }
        }
      });

      //* Video Call Updates Subscription
      _callSubscription = FirebaseFirestore.instance
          .collection('requests')
          .doc(requestID)
          .collection('call')
          .doc(callID)
          .snapshots()
          .listen((snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data['isCalling']) {
          if (data['receiverID'] == userID) {
            Navigator.pushNamed(context, "/callpickup", arguments: {
              'callerName': data['callerName'],
            });
          } else {
            print("Navigated to test call screen");
            Navigator.pushNamed(context, '/testcallscreen');
          }
        }

        //TODO: Send a "Call Accepted / Call Declined message in chat room"
        if (data['isDeclined']) {
          print("Call declined");
        }
      });
    });
  }

  //* Dispose subscription
  @override
  void dispose() {
    _statusSubscription.cancel();
    _callSubscription.cancel();
    super.dispose();
  }

  //* Handle Video Call
  void _handleVideoPressed(
      String requestID, String callID, String callerID, String callerName, String receiverID) async {
    DocumentReference videoCallRef =
        FirebaseFirestore.instance.collection('requests').doc(requestID).collection('call').doc(callID);

    await videoCallRef.update({
      'callerID': callerID,
      'callerName': callerName,
      'receiverID': receiverID,
      "isCalling": true,
      "isDeclined": false,
    });
  }

  //* Get Video Call Permissions
  Future<bool> _handleVideoCallPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var microphoneStatus = await Permission.microphone.status;

    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
      ].request();
    }

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      return true;
    }

    return false;
  }

  //* Handle Exit Chat Room
  Future<bool> _handleExit(
      String myID, bool imVolunteer, String requestID, Map<String, dynamic> latestRequestData) async {
    //* Show dialog and get true/false
    var isExit = await showExitPopup();
    if (isExit) {
      //* If role is VI, go to review screen
      if (!imVolunteer) {
        Navigator.pushNamedAndRemoveUntil(context, '/review', ModalRoute.withName('/'));
      } else if (imVolunteer) {
        Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
      }
      //* Update Firestore status "Completed"
      DocumentReference requestRef = FirebaseFirestore.instance.collection('requests').doc(requestID);
      await requestRef.update({'status': 'Completed'});

      //* Update Firestore history
      DocumentReference historyRef =
          FirebaseFirestore.instance.collection('users').doc(latestRequestData['VO_ID']).collection('requests').doc();
      await historyRef.set({
        'VI_displayName': latestRequestData['VI_displayName'],
        'currentLocationText': latestRequestData['currentLocationText'],
        'endLocationText': latestRequestData['endLocationText'],
        'VO_ID': latestRequestData['VO_ID']
      });

      return true;
    }
    return false;
  }

  //* Exit Confirm Dialog (returns true/false based on selection)
  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Chat'),
            content: const Text('End this session and exit the chat room?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              ),
            ],
            backgroundColor: Colors.white,
          ),
        ) ??
        false;
  }

  //* Handle sending text messages
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

  //* Handle sending image messages
  void _handleSendImage(String requestID, Map<String, dynamic> latestRequestData) async {
    final XFile? _imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    DocumentReference docRef =
        FirebaseFirestore.instance.collection("requests").doc(requestID).collection("messages").doc();
    String docID = docRef.id;

    if (_imageFile != null) {
      try {
        //* Upload to FirebaseStorage
        File file = File(_imageFile.path);
        FirebaseStorage storageInstance = FirebaseStorage.instance;
        Reference ref = storageInstance.ref().child('message_photos').child(DateTime.now().toIso8601String() + '.png');
        await ref.putFile(file);
        //* Add Image Message to Request document
        final url = await ref.getDownloadURL();
        final bytes = await _imageFile.readAsBytes();
        final image = await decodeImageFromList(bytes);
        Map<String, dynamic> userData = Provider.of<UserModel>(context, listen: false).data;

        await docRef.set({
          'author': {'id': userData['uid'], 'firstName': userData['displayName']},
          'createdAt': DateTime.now(),
          'height': image.height.toDouble(),
          'id': docID,
          'name': _imageFile.name,
          'size': bytes.length,
          'uri': url,
          'width': image.width.toDouble(),
          'type': 'image'
        });
      } on FirebaseException catch (err) {
        if (err.message == null) {
          throw Exception("Firebase error uploading image message at chat_screen.dart.");
        } else {
          throw Exception(err.message);
        }
      } catch (err) {
        throw Exception("Error uploading image message at chat_screen.dart.");
      }
    }
  }

  //* Convert Firebase List<DocumentSnapshot> to List<types.Message> for display
  List<types.Message> processFirebaseMessages(List<DocumentSnapshot> messagesList) {
    List<types.Message> messagesListProcessed = messagesList.map((DocumentSnapshot messageDoc) {
      Map<String, dynamic> dataMap = messageDoc.data() as Map<String, dynamic>;
      final author = types.User(id: dataMap['author']['id'], firstName: dataMap['author']['firstName'] + " says:");
      int createdAt = dataMap['createdAt'].toDate().millisecondsSinceEpoch;
      String id = dataMap['id'];
      if (dataMap['type'] == 'text') {
        String text = dataMap['text'];
        return types.TextMessage(author: author, createdAt: createdAt, id: id, text: text);
      }
      if (dataMap['type'] == 'image') {
        double height = dataMap['height'];
        String name = dataMap['name'];
        int size = dataMap['size'];
        String uri = dataMap['uri'];
        double width = dataMap['width'];
        return types.ImageMessage(
          author: author,
          createdAt: createdAt,
          height: height,
          id: id,
          name: name,
          size: size,
          uri: uri,
          width: width,
        );
      }
      return types.TextMessage(
          author: author,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "123456",
          text: "This message has a type that's not handled.");
    }).toList();
    return messagesListProcessed;
  }

  int currentTab = 0;
  bool atMap = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> myUserData = Provider.of<UserModel>(context, listen: false).data;
    String myID = myUserData['uid'];
    String myName = myUserData['displayName'];
    bool imVolunteer = myUserData['isVolunteer'];
    final _user = types.User(id: myUserData['uid'], firstName: myUserData['displayName']);
    Map<String, dynamic> requestData = Provider.of<RequestModel>(context, listen: false).data;
    String requestID = requestData['rid'];

    //* Variable Setting for video call
    String callReceiverID = "";
    String callID = requestData['cid'];
    String voID = requestData['voID'];
    String viID = requestData['viID'];
    if (myID == voID) {
      callReceiverID = viID;
    } else {
      callReceiverID = voID;
    }

    DocumentReference requestRef = FirebaseFirestore.instance.collection("requests").doc(requestID);
    //* FutureBuilder to get latest request data before page loads
    return FutureBuilder(
      future: requestRef.get(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          //* Latest request data
          dynamic snapshotData = snapshot.data;
          Map<String, dynamic> latestRequestData = snapshotData.data();
          String hisDisplayName =
              imVolunteer ? latestRequestData['VI_displayName'] : latestRequestData['VO_displayName'];
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Semantics(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(hisDisplayName),
                  ),
                  label: "Volunteer's name",
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                      size: 30,
                      semanticLabel: "Button to start video call",
                    ),
                    onPressed: () async => await _handleVideoCallPermissions()
                        ? _handleVideoPressed(requestID, callID, myID, myName, callReceiverID)
                        : {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.white,
                      size: 26,
                      semanticLabel: "Button to end session and exit the room permanently",
                    ),
                    onPressed: () => _handleExit(myID, imVolunteer, requestID, latestRequestData),
                  ),
                ],
              ),
              //* StreamBuilder to listen to new messages
              body: StreamBuilder(
                stream: requestRef.collection("messages").orderBy("createdAt", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //* Process data from Firebase
                    QuerySnapshot messagesQuerySnapshot = snapshot.data as QuerySnapshot;
                    List<DocumentSnapshot> messagesList = messagesQuerySnapshot.docs;
                    //* Convert data to List<types.Message>
                    //* messagesListProcessed is used to build messages
                    List<types.Message> messagesListProcessed = processFirebaseMessages(messagesList);
                    return SafeArea(
                      bottom: false,
                      child: Stack(children: [
                        IndexedStack(
                          index: currentTab,
                          children: <Widget>[
                            Chat(
                              messages: messagesListProcessed,
                              onSendPressed: _handleSendPressed,
                              user: _user,
                              showUserNames: true,
                              onAttachmentPressed: () => _handleSendImage(requestID, latestRequestData),
                              theme: DefaultChatTheme(
                                inputBackgroundColor: Colors.grey.shade100,
                                inputTextColor: Colors.black,
                                inputTextCursorColor: Colors.black,
                                primaryColor: const Color(0xff4a67a0),
                                userAvatarNameColors: [Theme.of(context).primaryColor],
                                sendButtonIcon: Icon(
                                  Icons.send_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 26.0,
                                  semanticLabel: 'Send the message',
                                ),
                                attachmentButtonIcon: Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Theme.of(context).primaryColor,
                                  size: 26.0,
                                  semanticLabel: 'Take a photo and send it to chat',
                                ),
                                inputTextStyle: const TextStyle(fontSize: 20),
                              ),
                              imageMessageBuilder: (msg, {messageWidth = 300}) {
                                String id = msg.id;
                                String uri = msg.uri;
                                return Semantics(
                                  label: "A photo sent to the chat",
                                  child: GestureDetector(
                                    child: Hero(
                                      tag: id,
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: uri,
                                        height: 250,
                                        width: 250,
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/heroImage',
                                          arguments: HeroImageScreenArgs(id, '', uri));
                                    },
                                  ),
                                );
                              },
                            ),
                            //* Map implementation here
                            const LiveLocationMap(),
                          ],
                        ),
                        Semantics(
                          label: atMap ? "Button to go back to chat room" : "Button to show live location on map",
                          child: Align(
                            child: PulsingIndicator(
                              icon: Ionicons.radio_outline,
                              message: atMap ? "Return to Chat Room" : "Live Location Shared",
                              bgColor: Colors.green.shade400,
                              textColor: Colors.white,
                              onTapFn: () => {
                                setState(() {
                                  currentTab = currentTab == 1 ? 0 : 1;
                                  atMap = atMap ? false : true;
                                })
                              },
                            ),
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ]),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
