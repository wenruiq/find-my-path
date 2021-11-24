import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/user_model.dart';
import './assignment_icon.dart';

//* This widget renders a ListTile for an assignment from AssignmentsList
//* Contains interactions with firebase (& provider?) when volunteer clicks accept
class Assignment extends StatefulWidget {
  final Map<String, dynamic> assignmentDetails;
  final String type;

  //* Assignment Detail passed from AssignmentsList
  const Assignment({
    required this.assignmentDetails,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  //* Displays alert dialog when user clicks accept
  void _onAccept() {
    showAlertDialog(context);
  }

  void updateFirestore(String aid) async {
    Navigator.pop(context);
    String volunteerId = Provider.of<UserModel>(context, listen: false).uid;
    String volunteerName = Provider.of<UserModel>(context, listen: false).displayName;

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('assignments').doc(aid);
      await docRef.update({
        'status': 'Ongoing',
        'VO_ID': volunteerId,
        'VO_displayName': volunteerName,
        //* Record Start Time so can calculate timeTaken
        'acceptTime': DateTime.now(),
      });
      //TODO: update snackbar into transition screen then to chat screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Assignment Accepted"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (err) {
      if (err.message == null) {
        throw Exception("Firebase Error updating assignment after accepting.");
      } else {
        throw Exception(err.message);
      }
    } catch (err) {
      throw Exception("Error updating assignment after accepting.");
    }
  }

  //* Shows alert dialog when user clicks accept, fires firebase call when user confirms action
  void showAlertDialog(BuildContext context) {
    String aid = widget.assignmentDetails["aid"];
    String viName = widget.assignmentDetails['VI_displayName'] ?? "";
    String currentLocation = widget.assignmentDetails['currentLocationText'] ?? "";
    String endLocation = widget.assignmentDetails['endLocationText'] ?? "";

    //* Set up buttons
    Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    //* Executes callback if confirm
    Widget confirmButton = TextButton(onPressed: () => updateFirestore(aid), child: const Text("Confirm"));

    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text(
        "Accept Assignment",
        textAlign: TextAlign.center,
      ),
      //TODO: Update content to be more useful
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("aid: " + aid),
          Text("VI Name: " + viName),
          Text("Start: " + currentLocation),
          Text("End: " + endLocation),
        ],
      ),
      actions: [cancelButton, confirmButton],
      backgroundColor: Colors.white,
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    //* assignmentID for firebase interaction, other variables for display, ?? checks for null
    String aid = widget.assignmentDetails["aid"];
    String viName = widget.assignmentDetails['VI_displayName'] ?? "";
    String currentLocation = widget.assignmentDetails['currentLocationText'] ?? "";
    String endLocation = widget.assignmentDetails['endLocationText'] ?? "";

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //* Defines the gap between leading and the title/subtitle section
              minLeadingWidth: 20,
              leading: AssignmentIcon(name: viName),
              title: Text(
                viName,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "From: " + currentLocation,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "To: " + endLocation,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              //TODO: styling can be improved (e.g. button long press effect, the slight misalignment from center)
              trailing: widget.type == "assignment_stream"
                  ? OutlinedButton(
                      //TODO: interact with firebase with this function, probably should have the id of the assignment passed here
                      onPressed: () => _onAccept(),
                      child: const Text("Accept"),
                    )
                  : null,
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
