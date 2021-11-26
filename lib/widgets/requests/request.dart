import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_dialog.dart';

import '../../providers/user_model.dart';
import '../../providers/request_model.dart';
import 'request_icon.dart';

//* This widget renders a ListTile for an request from requestsList
//* Contains interactions with firebase (& provider?) when volunteer clicks accept
class Request extends StatefulWidget {
  final Map<String, dynamic> requestDetails;
  final String type;

  //* Request Detail passed from requestsList
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
  void onView() {
    showAlertDialog(context);
  }

  void updateFirestoreAndProvider(String rid) async {
    // //* Close Dialog Box
    // Navigator.pop(context);

    //* Retrieve volunteer ID and Name for use, set Start Time
    String volunteerId = Provider.of<UserModel>(context, listen: false).uid;
    String volunteerName = Provider.of<UserModel>(context, listen: false).displayName;

    //* Update Provider
    Provider.of<RequestModel>(context, listen: false).setRequestData = {
      ...widget.requestDetails,
      'VO_ID': volunteerId,
      "VO_displayName": volunteerName,
      'status': 'Ongoing',
    };
    Navigator.pushNamedAndRemoveUntil(context, '/chat', ModalRoute.withName('/'));

    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('requests').doc(rid);
      await docRef.update({
        'status': 'Ongoing',
        'VO_ID': volunteerId,
        'VO_displayName': volunteerName,
      });
    } on FirebaseException catch (err) {
      if (err.message == null) {
        throw Exception("Firebase Error updating request after accepting.");
      } else {
        throw Exception(err.message);
      }
    } catch (err) {
      throw Exception("Error updating request after accepting.");
    }
  }

  //* Shows alert dialog when user clicks accept, fires firebase call when user confirms action
  void showAlertDialog(BuildContext context) {
    String rid = widget.requestDetails["rid"];
    String viName = widget.requestDetails['VI_displayName'] ?? "";
    String currentLocation = widget.requestDetails['currentLocationText'] ?? "";
    String endLocation = widget.requestDetails['endLocationText'] ?? "";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestDialog(
              rid: rid,
              viName: viName,
              currentLoc: currentLocation,
              endLoc: endLocation,
              updateFirestoreAndProvider: updateFirestoreAndProvider);
        });
  }

  @override
  Widget build(BuildContext context) {
    //* requestID for firebase interaction, other variables for display, ?? checks for null
    String viName = widget.requestDetails['VI_displayName'] ?? "N/A";
    String currentLocation = widget.requestDetails['currentLocationText'] ?? "N/A";
    String endLocation = widget.requestDetails['endLocationText'] ?? "N/A";

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              label: "Pathfinding request by $viName: from $currentLocation to $endLocation",
              child: ListTile(
                //* Defines the gap between leading and the title/subtitle section
                minLeadingWidth: 20,
                leading: ExcludeSemantics(child: RequestIcon(name: viName)),
                title: ExcludeSemantics(
                  child: Text(
                    viName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: ExcludeSemantics(
                  child: Padding(
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
                ),
                trailing: widget.type == "request_stream"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: OutlinedButton(
                          onPressed: () => onView(),
                          child: Semantics(
                            label: "Double tap to view this request in detail",
                            child: const Text("View"),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      )
                    : null,
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
