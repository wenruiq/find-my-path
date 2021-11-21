import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:provider/provider.dart';

import '../widgets/home/vo_rating.dart';
import '../widgets/home/vo_availability_button.dart';
import '../widgets/home/vo_assignment_control.dart';
import '../widgets/home/vo_assignment_dialog.dart';
import '../providers/user_model.dart';

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

  void _updateUserProvider() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(uid).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    Provider.of<UserModel>(context, listen: false).updateUserData({'uid': uid, ...userData});
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  // static Route<Object?> _dialogBuilder(BuildContext ctx, Object? arguments) {
  //   return DialogRoute<void>(
  //     context: ctx,
  //     builder: (BuildContext context) => const AssignmentDialog(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //* Get user data from provider
    var userData = Provider.of<UserModel>(context).data;
    print(userData);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome back, ${userData['displayName']}!",
          style: const TextStyle(fontSize: 18),
        ),
        //* Logout Action in Nav Bar
        //TODO: make logout button appear more normal
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            //* Sets the background color of the dropdown item
            dropdownColor: Colors.white,
            items: [
              DropdownMenuItem(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 15),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                _logout();
              }
            },
          ),
        ],
      ),
      body: Center(
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
                //* imageURL
                ClipOval(
                  child: Image.network(
                    'https://i.redd.it/z3xftphdln041.png',
                    height: 190,
                    width: 190,
                    fit: BoxFit.cover,
                  ),
                ),
                //* displayName
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "${userData['displayName']}",
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(height: 5),
                //* User's Star Ratings
                const Rating(
                  rating: 5,
                  reviewCount: 7,
                ),
              ],
            ),
            //* This is the assignments box listtile
            const AssignmentControl(),
            //* This is the availability toggle button
            const AvailabilityButton(
              onClick: null,
            ),
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
    );
  }
}
