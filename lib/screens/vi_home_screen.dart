import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

import '../widgets/home/vi_button.dart';

class HomeScreenVI extends StatelessWidget {
  const HomeScreenVI({Key? key}) : super(key: key);
  static const routeName = '/homeVI';

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Menu"),
      ),
      body: Column(
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
    );
  }
}
