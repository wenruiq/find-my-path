import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

import '../widgets/assignments/assignments_list.dart';

class AssignmentsScreen extends StatefulWidget {
  static const routeName = '/assignments';
  final String type;

  const AssignmentsScreen({
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

void initAssignmentStream() {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference assignments =
      FirebaseFirestore.instance.collection('assignments');
  assignments.snapshots().listen((data) {
    print(data);
  });
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late List<Object> _demoData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => initAssignmentStream());
    _demoData = [
      {"id": 1, "name": "Harvey", "endLocation": "Orchard"},
      {"id": 2, "name": "Louis", "endLocation": "Changi"},
      {"id": 3, "name": "Mike", "endLocation": "Disney Land"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    String title = "Assignments";

    //* Sets NavBar title based on source of routing
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    title = arguments['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _demoData.addAll(['1']);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Retrieved Available Assignments'),
              ),
            );
          });
        },
        child: AssignmentsList(data: _demoData),
      ),
    );
  }
}
