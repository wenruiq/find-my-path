import 'package:find_my_path/providers/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/user_model.dart';
import '../widgets/assignments/assignments_list.dart';

//* Screen shown when user clicks a Call-To-Action from AssignmentControl from HomeScreenVO
//* Handles data streaming from the volunteer's assignments history or the overall assignments collection
class AssignmentsScreen extends StatefulWidget {
  static const routeName = '/assignments';

  const AssignmentsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _feed;
    late List<Map<String, dynamic>> _assignmentsData;
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    //* Sets NavBar title based on source of routing from AssignmentControl buttons
    String title = arguments['title'];
    String type = arguments['type'];

    //* Type can be assignment_stream or assignment_history
    if (type == "assignment_stream") {
      //* Set _feed to stream of assignments that have status = "Pending"
      _feed = FirebaseFirestore.instance.collection('assignments').where("status", isEqualTo: "Pending").snapshots();
    } else {
      var volunteerID = Provider.of<UserModel>(context).uid;
      _feed = FirebaseFirestore.instance
          .collection('users/${volunteerID}/assignments')
          .where("VO_ID", isEqualTo: volunteerID)
          .where("status", isEqualTo: "Completed")
          .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _feed,
          builder: (_, snapshot) {
            //* Handles if stream snapshot errors out, displays meaningful message in center of screen
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error connecting to database, please try again later."),
              );
            }

            //* Handles if stream snapshot is loading, displays spinner in center of screen
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //* active connectionState when stream is established
            if (snapshot.connectionState == ConnectionState.active) {
              //* Converts streamed snapshot into list of Map<String, dynamic> containing assignment details
              _assignmentsData = snapshot.data!.docs.map((DocumentSnapshot document) {
                dynamic data = document.data()!;
                final Map<String, dynamic> toReturn = data;
                //* stores assignmentID into the newly generated list
                toReturn["aid"] = document.id;
                return toReturn;
              }).toList();
            }

            //* Intercept if data is empty and render a text message instead of building assignmentsList
            if (_assignmentsData.isEmpty) {
              return const Center(
                child: Text("No Assignments Found"),
              );
            }

            //* Pass data to assignmentsList to render if there's data, type is either assignment_history or assignment_stream
            return AssignmentsList(
              data: _assignmentsData,
              type: type,
            );
          },
        ),
      ),
    );
  }
}
