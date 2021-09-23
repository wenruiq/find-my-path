import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';

class HomeScreenVO extends StatelessWidget {
  HomeScreenVO({Key? key}) : super(key: key);
  static const routeName = '/homeVO';

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  final _listOptions = <List<Widget>>[
    <Widget>[
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
        child: Text(
          'View all available requests',
          style: TextStyle(fontSize: 16),
        ),
      ),
      const Icon(Icons.chevron_right, color: Colors.black),
    ],
    <Widget>[
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
        child: Text(
          'Accepted requests',
          style: TextStyle(fontSize: 16),
        ),
      ),
      Row(
        children: const [
          Text(
            "View All",
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.chevron_right, color: Colors.black),
        ],
      )
    ],
    <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: const [
            Icon(Icons.event_available, color: Colors.black, size: 42),
            Text(
              "Ongoing",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: const [
            Icon(Icons.history, color: Colors.black, size: 42),
            Text(
              "History",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //TODO: Add user's name to title
        title: const Text(
          "Welcome back, Harvey!",
          style: TextStyle(fontSize: 18),
        ),
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
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Harvey Specter",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                //* Status Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  //TODO: Convert dropdown status to stateful widget
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Status: ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Available",
                        style: TextStyle(color: Colors.green),
                      ),
                      Icon(
                        Icons.expand_more,
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                //* User's Star Ratings
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 2.5, right: 5),
                      child: Text(
                        "4.0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star_rate,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Icon(
                      Icons.star_rate,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Icon(
                      Icons.star_rate,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Icon(
                      Icons.star_rate,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Icon(
                      Icons.star_rate_outlined,
                      size: 18,
                      color: Colors.amber,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 4),
                      child: Text(
                        "(7)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            //* This is the assignments box listtile
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listOptions.length,
                  itemBuilder: (builder, index) {
                    double topWidth = index != 0 ? 0.5 : 0;
                    var alignment = index == _listOptions.length - 1
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceBetween;

                    return Column(
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide.none,
                              right: BorderSide.none,
                              top: BorderSide(
                                color: Colors.grey,
                                width: topWidth,
                              ),
                              bottom: BorderSide.none,
                            ),
                          ),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: alignment,
                              children: _listOptions[index],
                            ),
                            // ListTile(
                            //   title: Text(
                            //     _listOptions[index],
                            //     style: TextStyle(fontSize: 14),
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              child: Column(
                children: [
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
