import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import '../widgets/util/loading.dart';
import "../args/query_loading_screen_args.dart";

class QueryLoadingScreen extends StatefulWidget {
  const QueryLoadingScreen({Key? key}) : super(key: key);
  static const routeName = '/queryloading';

  @override
  _QueryLoadingScreenState createState() => _QueryLoadingScreenState();
}

class _QueryLoadingScreenState extends State<QueryLoadingScreen> {
  void cancelRequest(String aid) async {
    Navigator.pop(context);
    DocumentReference assignmentRef = FirebaseFirestore.instance.collection("assignments").doc(aid);
    await assignmentRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as QueryLoadingScreenArgs;
    String assignmentID = args.assignmentID;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, centerTitle: true, title: const Text("Finding...")),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('assignments').doc(assignmentID).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                String status = snapshot.data!['status'];
                print("Assignment status: " + status);
              }
            }
            //* Show loader no matter what
            return Stack(children: <Widget>[
              const Loading(description: "Finding A Volunteer..."),
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.13,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onSurface: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    ),
                    onPressed: () => cancelRequest(assignmentID),
                    child: const Text(
                      "Cancel Request",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ]);
          }),
    );
  }
}
