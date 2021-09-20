import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

class HomeScreenVO extends StatelessWidget {
  const HomeScreenVO({Key? key}) : super(key: key);
  static const routeName = '/homescreenvo';

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: Add user's name to title
        title: Text("Welcome back, User!"),
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
              //* Todo: change this to make the item display below the ...
              DropdownMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //* This is the profile info column
            Column(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    'https://i.redd.it/z3xftphdln041.png',
                    height: 190,
                    width: 190,
                    fit: BoxFit.cover,
                  ),
                ),
                //TODO: Change to user's display name
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Harvey Specter",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
            //* This is the assignments box column
            Column(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: Size(400, 50),
                  ),
                  onPressed: () {},
                  child: const Text('Disabled'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
