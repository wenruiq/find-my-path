import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "../widgets/util/dismiss_keyboard.dart";
import "../widgets/query/current_location.dart";

//* This screen is the form that VI needs to fill up to get a match
class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);
  static const routeName = '/query';

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference assignments =
      FirebaseFirestore.instance.collection('assignments');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  late FocusNode myFocusNode;

  String _uid = '123';
  String _displayName = "abc";

  var _isLoading = false;
  var _endLocation = "";

  final TextEditingController _endLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _uid = _auth.currentUser!.uid;
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void _trySubmit() {
    _formKey.currentState!.save();
    _submitQueryForm(endLocation: _endLocation.trim());
  }

  void _submitQueryForm({required String endLocation}) async {
    setState(() {
      _setLoading(true);
    });

    await users.doc(_uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _displayName = documentSnapshot.get('displayName');
      }
    });

    //* To be updated to be filled with all real info
    var assignmentInfo = {
      "VI_ID": _uid,
      "VI_displayName": _displayName,
      "VO_ID": "123",
      "VO_displayName": "Harvey",
      "date": DateTime.now(),
      "imageURL":
          "https://images.unsplash.com/photo-1572281158640-30040dd70cbe?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=3024&q=80",
      "currentLocation": {
        "long": 103.85016229678607,
        "lat": 1.2963557161277992,
        "name": "Singapore Management University"
      },
      "endLocation": {
        "long": 103.85113602626875,
        "lat": 1.3006504987053975,
        "name": endLocation
      },
      "status": "In Progress",
      "timeTaken": null,
    };

    await assignments
        .add(assignmentInfo)
        .then((value) => print("Assignment added to Firestore"))
        .catchError((error) => print("Failed to add assignment: $error"));

    setState(() {
      _setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Enter Details"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CurrentLocation(),
              const SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //* Destination Input
                      Text(
                        "Where do you want to go?",
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextFormField(
                          key: const ValueKey('endLocation'),
                          controller: _endLocationController,
                          decoration: const InputDecoration(
                              hintText: "Enter your destination"),
                          onSaved: (value) {
                            _endLocation = value.toString();
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      //* Photo Upload Box
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Attach A Photo (Optional)",
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: OutlinedButton.icon(
                            icon: Icon(
                              Icons.upload_file,
                              size: 60,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, "/homeVO"),
                            label: const Text(
                              "Take A Photo",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      FormState().save();
                      _trySubmit();
                      Navigator.pushNamed(context, "/queryloading");
                    },
                    child: const Text(
                      "Send Request",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
