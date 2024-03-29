import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/scheduler.dart';
import "package:provider/provider.dart";

import '../widgets/util/loading.dart';
import "../args/query_loading_screen_args.dart";
import "../providers/request_model.dart";

//* This screen handles navigation to chatroom if status -> "Ongoing";
class QueryLoadingScreen extends StatefulWidget {
  const QueryLoadingScreen({Key? key}) : super(key: key);
  static const routeName = '/queryloading';

  @override
  _QueryLoadingScreenState createState() => _QueryLoadingScreenState();
}

class _QueryLoadingScreenState extends State<QueryLoadingScreen> {
  //TODO: delete
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Query loading loaded");
  }

  void cancelRequest(String rid) async {
    Navigator.pop(context);
    DocumentReference requestRef = FirebaseFirestore.instance.collection("requests").doc(rid);
    //* Comment out this line if you want to cancel without deleting
    await requestRef.delete();
  }

  //* Navigate user to chat room when status = "Ongoing"
  void navigateToChatRoom(Map<String, dynamic> requestData, String requestID) {
    //* Ensure this runs after build completes
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      //* Update provider
      Provider.of<RequestModel>(context, listen: false).setRequestData = {'rid': requestID, ...requestData};
      Navigator.pushNamedAndRemoveUntil(context, '/chat', ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as QueryLoadingScreenArgs;
    String requestID = args.requestID;
    return Semantics(
      label: "Searching for a volunteer screen, press cancel at the bottom of the screen to go back to request form",
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, centerTitle: true, title: const Text("Finding...")),
        body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('requests').doc(requestID).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.exists) {
                    String status = snapshot.data!['status'];
                    if (status == "Ongoing") {
                      navigateToChatRoom(snapshot.data!.data() as Map<String, dynamic>, requestID);
                    }
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
                        onPressed: () => cancelRequest(requestID),
                        child: const Text(
                          "Cancel Request",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ]);
              }),
        ),
      ),
    );
  }
}
