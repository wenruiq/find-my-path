import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";

import "../widgets/util/dismiss_keyboard.dart";
import "../widgets/query/query_form.dart";
import "../args/query_loading_screen_args.dart";

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
  void _submitQueryForm({
    required String viID,
    required String viDisplayName,
    required DateTime date,
    required Map<String, double> currentLocationLT,
    required Map<String, double> endLocationLT,
    required String currentLocationText,
    required String endLocationText,
    required String status,
    required BuildContext context,
    XFile? imageFile,
  }) async {
    try {
      //* Create Firestore entry
      DocumentReference docRef = FirebaseFirestore.instance.collection("assignments").doc();
      print("Creating assignment with ID: " + docRef.id);
      //* Navigate to query loading
      Navigator.pushNamed(context, '/queryloading', arguments: QueryLoadingScreenArgs(docRef.id));
      await docRef.set({
        'VI_ID': viID,
        'VI_displayName': viDisplayName,
        'date': date,
        'currentLocationLT': currentLocationLT,
        'endLocationLT': endLocationLT,
        'currentLocationText': currentLocationText,
        'endLocationText': endLocationText,
        'status': status
      });

      if (imageFile != null) {
        //* Upload to FirebaseStorage
        File file = File(imageFile.path);
        FirebaseStorage storageInstance = FirebaseStorage.instance;
        Reference ref = storageInstance.ref().child('query_photos').child(date.toIso8601String() + '.png');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        //* Add imageURL to assignment document
        await docRef.update({'imageURL': url});
      }
    } on FirebaseException catch (err) {
      if (err.message == null) {
        throw Exception("Firebase Error submitting query form.");
      } else {
        throw Exception(err.message);
      }
    } catch (err) {
      throw Exception("Error submitting query form.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Enter Details"),
          ),
          body: SafeArea(
              child: QueryForm(
            submitFn: _submitQueryForm,
          ))),
    );
  }
}
