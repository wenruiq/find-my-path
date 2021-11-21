import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../widgets/home/vi_button.dart';
import '../providers/user_model.dart';
import '../providers/location_model.dart';

class HomeScreenVI extends StatefulWidget {
  const HomeScreenVI({Key? key}) : super(key: key);
  static const routeName = '/homeVI';

  @override
  State<HomeScreenVI> createState() => _HomeScreenVIState();
}

class _HomeScreenVIState extends State<HomeScreenVI> {
  @override
  void initState() {
    super.initState();

    //* "Saves" user data to the provider so we can get it anywhere we want
    _updateUserProvider();

    //* Initialize flutter location service
    initLocationService();
  }

  //TODO: Only for testing, need to discuss location handling
  //* Flutter location package, request permission & get cur. location
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

    //* Update current location to provider
    //TODO: This is only for testing, we need this to be always up to date
    Provider.of<LocationModel>(context, listen: false).setCurrentLocation = {
      'lat': _locationData.longitude as double,
      'long': _locationData.latitude as double
    };
  }

  void _updateUserProvider() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(uid).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    Provider.of<UserModel>(context, listen: false).setUserData = {'uid': uid, ...userData};
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Remove if not needed
    //* Get user data from provider
    var userData = Provider.of<UserModel>(context).data;
    print(userData);

    //TODO: Remove if not needed
    //* Get current location {lat: double, long: double}
    var curlo = Provider.of<LocationModel>(context).curLo;
    print(curlo);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("FindMyPath",
            style: TextStyle(
              fontFamily: "OleoScript",
              color: Colors.white,
              fontSize: 25,
            )),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraint.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonVI(
                  icon: Icons.forum_outlined,
                  tooltip: 'Search For A Volunteer',
                  label: "Ask For Help",
                  onButtonPress: () => Navigator.pushNamed(context, "/query"),
                ),
                ButtonVI(
                  icon: Icons.logout,
                  tooltip: 'Logout',
                  label: "Logout",
                  onButtonPress: _logout,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
