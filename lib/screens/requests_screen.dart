import 'package:find_my_path/providers/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/user_model.dart';
import '../widgets/requests/requests_list.dart';

//* Screen shown when user clicks a Call-To-Action from AssignmentControl from HomeScreenVO
//* Handles data streaming from the volunteer's assignments history or the overall assignments collection
class RequestsScreen extends StatefulWidget {
  static const routeName = '/requests';

  const RequestsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _feed;
    late List<Map<String, dynamic>> _requestsData;
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    //* Sets NavBar title based on source of routing from AssignmentControl buttons
    String title = arguments['title'];
    String type = arguments['type'];

    //* Type can be request_stream or request_history
    if (type == "request_stream") {
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
              _requestsData = snapshot.data!.docs.map((DocumentSnapshot document) {
                dynamic data = document.data()!;
                final Map<String, dynamic> toReturn = data;
                //* stores assignmentID into the newly generated list
                toReturn["aid"] = document.id;
                return toReturn;
              }).toList();
            }

            //* Intercept if data is empty and render a text message instead of building assignmentsList
            if (_requestsData.isEmpty && type != "request_stream") {
              String text = "No Assignments Found";

              return Center(
                child: Text(text),
              );
            }

            //* Pass data to assignmentsList to render if there's data, type is either request_history or request_stream
            return RequestsList(
              data: _requestsData,
              type: type,
            );
          },
        ),
      ),
    );
  }
}
