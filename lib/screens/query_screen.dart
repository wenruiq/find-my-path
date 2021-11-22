import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "../widgets/util/dismiss_keyboard.dart";
import "../widgets/query/query_form.dart";

//* This screen is the form that VI needs to fill up to get a match
class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);
  static const routeName = '/query';

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  //* Submit form loading state;
  var _isLoading = false;
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  //* Callback to be passed to query_form.dart
  void _submitQueryForm(
      {required String voID,
      required String viID,
      required String voDisplayName,
      required String viDisplayName,
      required DateTime date,
      required String imageURL,
      required Map<String, double> currenLocationLT,
      required Map<String, double> endLocationLT,
      required String currentLocationText,
      required String endLocationText,
      required String status}) async {
    //TODO: Submit form
    return;
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Enter Details"),
          ),
          body: SafeArea(child: QueryForm(submitFn: _submitQueryForm, isLoading: _isLoading))),
    );
  }
}
