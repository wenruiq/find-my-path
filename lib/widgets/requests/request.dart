import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_dialog.dart';

import '../../providers/user_model.dart';
import 'request_icon.dart';

//* This widget renders a ListTile for an assignment from AssignmentsList
//* Contains interactions with firebase (& provider?) when volunteer clicks accept
class Request extends StatefulWidget {
  final Map<String, dynamic> requestDetails;
  final String type;

  //* Assignment Detail passed from AssignmentsList
  const Request({
    required this.requestDetails,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
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
    String aid = widget.requestDetails["aid"];
    String viName = widget.requestDetails['VI_displayName'] ?? "";
    String currentLocation = widget.requestDetails['currentLocationText'] ?? "";
    String endLocation = widget.requestDetails['endLocationText'] ?? "";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestDialog(
              aid: aid,
              viName: viName,
              currentLoc: currentLocation,
              endLoc: endLocation,
              updateFirestore: updateFirestore);
        });
  }

  @override
  Widget build(BuildContext context) {
    //* assignmentID for firebase interaction, other variables for display, ?? checks for null
    String aid = widget.requestDetails["aid"];
    String viName = widget.requestDetails['VI_displayName'] ?? "";
    String currentLocation = widget.requestDetails['currentLocationText'] ?? "";
    String endLocation = widget.requestDetails['endLocationText'] ?? "";

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //* Defines the gap between leading and the title/subtitle section
              minLeadingWidth: 20,
              leading: RequestIcon(name: viName),
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
              trailing: widget.type == "request_stream"
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
