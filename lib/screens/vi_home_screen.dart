import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

import '../widgets/home/vi_button.dart';
import '../providers/user_model.dart';

class HomeScreenVI extends StatefulWidget {
  const HomeScreenVI({Key? key}) : super(key: key);
  static const routeName = '/homeVI';

  @override
  State<HomeScreenVI> createState() => _HomeScreenVIState();
}

class _HomeScreenVIState extends State<HomeScreenVI> {
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

  @override
  Widget build(BuildContext context) {
    //TODO: Remove this if don't need.
    //* Get user data from provider
    var userData = Provider.of<UserModel>(context).data;
    print(userData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("FindMyPath",
            style: TextStyle(
              fontFamily: "OleoScript",
              color: Colors.white,
              fontSize: 25,
            )),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraint.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonVI(
                  icon: Icons.forum_outlined,
                  tooltip: 'Search For A Volunteer',
                  label: "Ask For Help",
                  onButtonPress: () => Navigator.pushNamed(context, "/query"),
                ),
                ButtonVI(
                  icon: Icons.logout,
                  tooltip: 'Logout',
                  label: "Logout",
                  onButtonPress: _logout,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
