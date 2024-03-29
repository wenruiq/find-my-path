import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:provider/provider.dart';

import '../widgets/home/vo_badges_bar.dart';
import '../widgets/home/vo_availability_button.dart';
import '../widgets/requests/requests_control.dart';
import '../providers/user_model.dart';

import '../widgets/util/slide_route.dart';
import '../screens/video_call_pickup_screen.dart';

class HomeScreenVO extends StatefulWidget {
  const HomeScreenVO({Key? key}) : super(key: key);
  static const routeName = '/homeVO';

  @override
  State<HomeScreenVO> createState() => _HomeScreenVOState();
}

class _HomeScreenVOState extends State<HomeScreenVO> {
  @override
  void initState() {
    super.initState();
    //* "Saves" user data to the provider so we can get it anywhere we want
    _updateUserProvider();
  }

  //* Need to fire this once to save user data to provider
  void _updateUserProvider() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(uid).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    Provider.of<UserModel>(context, listen: false).setUserData = {'uid': uid, ...userData};

    //TODO: delete after clearing badges usage
    print("This is user data");
    print(userData);
    var badges = Provider.of<UserModel>(context, listen: false).badges;
    print("Badges info: ");
    print(badges["listener"]);
  }

  void _logoutConfirmation() {
    void logout() {
      Navigator.pop(context);
      FirebaseAuth.instance.signOut();
    }

    showAlertDialog(context, "Logout", "Are you sure you want to logout?", logout);
  }

  //* Shows Alert Dialog to confirm actions
  void showAlertDialog(BuildContext context, String title, String content, Function callback) {
    //* Set up buttons
    Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    //* Executes callback if confirm
    Widget confirmButton = TextButton(onPressed: () => callback(), child: const Text("Confirm"));

    //* Set up alert
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [cancelButton, confirmButton],
      backgroundColor: Colors.white,
    );

    //* Show dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  //* Handles appBar actions, can have more cases, now only logout
  void onSelected(BuildContext context, String item) {
    switch (item) {
      case 'logout':
        _logoutConfirmation();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //* Listen to displayName from notifier
    //* There are other getters, check out /providers/user_model.dart
    var displayName = Provider.of<UserModel>(context).displayName;
    Map<String, dynamic> badges = Provider.of<UserModel>(context, listen: false).badges;

    //* Listen to isAvailable to handle notification subscription
    var isAvailable = Provider.of<UserModel>(context).isAvailable;
    FirebaseMessaging firebaseMessagingInstance = FirebaseMessaging.instance;
    if (isAvailable) {
      firebaseMessagingInstance.subscribeToTopic('requests');
    } else {
      firebaseMessagingInstance.unsubscribeFromTopic('requests');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome back, $displayName!",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          PopupMenuButton<String>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          Icon(Icons.exit_to_app, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Logout'),
                        ],
                      ),
                    )
                  ]),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //* This is the profile info column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  //* Display Photo
                  //TODO: Replace this with upload profile pic after implementing video call properly
                  InkResponse(
                    onTap: () => {},
                    // onTap: () => Navigator.push(
                    //   context,
                    //   SlideRoute(
                    //     routeName: '/callpickup',
                    //     page: const VideoCallPickupScreen(),
                    //   ),
                    // ),
                    child: ClipOval(
                      //TODO: Update this with real user display photo
                      child: Image.network(
                        'https://i.redd.it/z3xftphdln041.png',
                        height: 190,
                        width: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  //* displayName
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 5),
                    child: Text(
                      displayName,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //* Star Rating
                  BadgesBar(
                    badges: badges,
                  ),
                ],
              ),
              //* requests ListTiles
              const RequestsControl(),

              //* Availability Toggle
              const AvailabilityButton(),

              //* App Version Display
              SizedBox(
                child: Column(
                  children: const [
                    Text(
                      "Find My Path",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "v1.0.0",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
