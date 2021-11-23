import 'package:flutter/material.dart';

import './assignment_icon.dart';

//* This widget renders a ListTile for an assignment from AssignmentsList
//* Contains interactions with firebase (& provider?) when volunteer clicks accept
class Assignment extends StatefulWidget {
  final Map<String, dynamic> assignmentDetails;

  //* Assignment Detail passed from AssignmentsList
  const Assignment({
    required this.assignmentDetails,
    Key? key,
  }) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  //* Displays alert dialog when user clicks accept
  void _onAccept(String aid) {
    print(context);
  }

  //* Shows alert dialog when user clicks accept, fires firebase call when user confirms action
  void showAlertDialog(BuildContext context, Function callback, String viName, String startLoc, String endLoc) {
    //* Set up buttons
    Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    //* Executes callback if confirm
    Widget confirmButton = TextButton(onPressed: () => callback(), child: const Text("Confirm"));

    AlertDialog alert = AlertDialog(
      title: Text("Accept Assignment"),
      //TODO: Update content to be more useful
      content: Text("New Content"),
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
              trailing: OutlinedButton(
                //TODO: interact with firebase with this function, probably should have the id of the assignment passed here
                onPressed: () => _onAccept(aid),
                child: const Text("Accept"),
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
