import "dart:io";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:provider/provider.dart";
import 'package:location/location.dart';

import "../widgets/util/dismiss_keyboard.dart";
import "../widgets/query/query_form.dart";
import "../args/query_loading_screen_args.dart";
import "../providers/user_model.dart";
import '../providers/location_model.dart';

//* This screen is the form that VI needs to fill up to get a match
class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);
  static const routeName = '/query';

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  @override
  void initState() {
    super.initState();
    //* Initialize flutter location service
    initLocationService();
  }

  //* Get current location and pass to provider
  void initLocationService() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    Provider.of<LocationModel>(context, listen: false).setCurrentLocationLT = {
      'lat': _locationData.latitude as double,
      'long': _locationData.longitude as double
    };
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
      DocumentReference docRef = FirebaseFirestore.instance.collection("requests").doc();
      print("Creating request with ID: " + docRef.id);
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
        'status': status,
      });

      if (imageFile != null) {
        //* Upload to FirebaseStorage
        File file = File(imageFile.path);
        FirebaseStorage storageInstance = FirebaseStorage.instance;
        Reference ref = storageInstance.ref().child('query_photos').child(date.toIso8601String() + '.png');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        //* Add imageURL to request document
        await docRef.update({'imageURL': url});
        //* Add image message to auto send attached image
        DocumentReference msgDocRef = docRef.collection("messages").doc();
        String msgDocID = msgDocRef.id;
        final bytes = await imageFile.readAsBytes();
        final image = await decodeImageFromList(bytes);
        Map<String, dynamic> userData = Provider.of<UserModel>(context, listen: false).data;
        Map<String, String> author = {'id': userData['uid'], 'firstName': userData['displayName']};
        await msgDocRef.set({
          'author': author,
          'createdAt': DateTime.now(),
          'height': image.height.toDouble(),
          'id': msgDocID,
          'name': imageFile.name,
          'size': bytes.length,
          'uri': url,
          'width': image.width.toDouble(),
          'type': 'image'
        });
        DocumentReference msgDocRef2 = docRef.collection("messages").doc();
        String msgDocID2 = msgDocRef.id;
        String text = "Hi! Could you please guide me from '$currentLocationText' to '$endLocationText'?";
        await msgDocRef2
            .set({'author': author, 'createdAt': DateTime.now(), 'text': text, 'id': msgDocID2, 'type': 'text'});
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
