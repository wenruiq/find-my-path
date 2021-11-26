import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:provider/provider.dart';

import "../providers/request_model.dart";

import '../widgets/badges/badge.dart';

//* Page for the VI to give VO badges
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  static const routeName = "/review";

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final List<String> badgeTypes = [
    "friendly",
    "listener",
    "expert",
    "personality",
  ];

  final Map<String, bool> badgeStatus = {
    "friendly": false,
    "listener": false,
    "expert": false,
    "personality": false,
  };

  void _toggleAvailability(int index) {
    String type = badgeTypes[index];
    bool status = badgeStatus[type] as bool;

    setState(() {
      badgeStatus[type] = !status;
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave Page?'),
            content: const Text('End this session without leaving a review for your volunteer?'),
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

  Future<bool> _handleExit() async {
    var isExit = await showExitPopup();

    if (isExit) {
      //* Go back to home page
      Navigator.popUntil(context, ModalRoute.withName('/'));
      return true;
    }
    return false;
  }

  void _trySubmit(String voID) async {
    print("Submitting review to firebase");

    bool listenerStatus = badgeStatus["listener"] as bool;
    bool expertStatus = badgeStatus["expert"] as bool;
    bool friendlyStatus = badgeStatus["friendly"] as bool;
    bool personalityStatus = badgeStatus["personality"] as bool;

    //* Uncomment this to navigate away
    Navigator.popUntil(context, ModalRoute.withName('/'));
    //* Update firebase with state data
    DocumentReference volunteerRef = FirebaseFirestore.instance.collection('users').doc(voID);

    await volunteerRef.update({
      "badges.friendly": FieldValue.increment(friendlyStatus ? 1 : 0),
      "badges.listener": FieldValue.increment(listenerStatus ? 1 : 0),
      "badges.expert": FieldValue.increment(expertStatus ? 1 : 0),
      "badges.personality": FieldValue.increment(personalityStatus ? 1 : 0),
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> requestData = Provider.of<RequestModel>(context, listen: false).data;
    String volunteerID = requestData['voID'];
    String volunteerName = requestData['voDisplayName'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rate Your Volunteer"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 26,
                semanticLabel: "Button to leave review screen and return to home page",
              ),
              //TODO: Add popup confirmation dialog
              onPressed: () => _handleExit(),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            widthFactor: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.1,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Give Compliments?",
                        semanticsLabel:
                            "You can select compliments from a horizontally scrolling selection of badges to give your volunteer $volunteerName here",
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Select compliments for your volunteer $volunteerName below",
                            semanticsLabel:
                                "Select compliments for your volunteer $volunteerName below scroll horizontally for more options",
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: List.generate(4, (index) {
                      String selected = badgeTypes[index];
                      bool status = badgeStatus[selected] as bool;
                      return InkResponse(
                        onTap: () => _toggleAvailability(index),
                        child: Badge(
                          type: selected,
                          available: status,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.13,
                  child: ElevatedButton(
                    onPressed: () {
                      _trySubmit(volunteerID);
                    },
                    child: const Text(
                      "Submit",
                      semanticsLabel: "Submit Compliments And Return To Home Screen",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
