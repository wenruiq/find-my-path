import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

import '../widgets/home/vo_rating.dart';
import '../widgets/home/vo_availability_button.dart';
import '../widgets/home/vo_assignment_control.dart';

class HomeScreenVO extends StatelessWidget {
  const HomeScreenVO({Key? key}) : super(key: key);
  static const routeName = '/homeVO';

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: Add user's name to title
        title: const Text(
          "Welcome back, Harvey!",
          style: TextStyle(fontSize: 18),
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
                SizedBox(
                  height: 20,
                ),
                //* User's Display Photo
                ClipOval(
                  child: Image.network(
                    'https://i.redd.it/z3xftphdln041.png',
                    height: 190,
                    width: 190,
                    fit: BoxFit.cover,
                  ),
                ),
                //* User's Name
                //TODO: Change to user's display name
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Harvey Specter",
                    style: TextStyle(fontSize: 28),
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
            const AvailabilityButton(),
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
