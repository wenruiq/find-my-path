import 'package:find_my_path/widgets/stream_indicator/pulsing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

import '../widgets/assignments/assignments_list.dart';

class AssignmentsScreen extends StatefulWidget {
  static const routeName = '/assignments';

  const AssignmentsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  //* Create FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _feed;
    List<Map<String, dynamic>> _assignmentsData = [];
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    //* Sets NavBar title based on source of routing
    String title = arguments['title'];
    String type = arguments['type'];

    if (type == "assignment_stream") {
      print("Feed is assignments");
      _feed = FirebaseFirestore.instance.collection('assignments').where("status", isEqualTo: "Pending").snapshots();
    } else {
      _feed = FirebaseFirestore.instance
          .collection('assignments')
          .where("VO_ID", isEqualTo: "MyUID")
          .where("status", isEqualTo: "Completed")
          .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _feed,
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error connecting to database, please try again later"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.active) {

                  _assignmentsData = snapshot.data!.docs.map((DocumentSnapshot document) {
                    return document.data()! as Map<String, dynamic>;
                  }).toList();
                }

                if (_assignmentsData.isEmpty) {
                  return Center(
                    child: Text("No Assignments Found"),
                  );
                }

                return AssignmentsList(
                  data: _assignmentsData,
                  type: type,
                );
              },
            ),
          ),
        ],
      ),

      // RefreshIndicator(
      //   triggerMode: RefreshIndicatorTriggerMode.anywhere,
      //   onRefresh: () {
      //     return Future.delayed(const Duration(seconds: 1), () {
      //       setState(() {
      //         _demoData.addAll(['wow', 'wew']);
      //       });

      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(
      //           content: Text('Refreshed LUL'),
      //         ),
      //       );
      //     });
      //   },
      //   child: AssignmentsList(data: _demoData),
      // ),
    );
  }
}
