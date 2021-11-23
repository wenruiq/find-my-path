import 'package:flutter/material.dart';

import './assignment_icon.dart';
import './assignment_accept_button.dart';

class Assignment extends StatelessWidget {
  final Map<String, dynamic> assignmentDetails;

  const Assignment({
    required this.assignmentDetails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("This is assignment details");
    print(assignmentDetails);
    print(assignmentDetails.runtimeType);
    print("This is VI displayName");
    print(assignmentDetails['VI_displayName']);

    String viName = assignmentDetails['VI_displayName'] ?? "";
    String currentLocation = assignmentDetails['currentLocationText'] ?? "";
    String endLocation = assignmentDetails['endLocationText'] ?? "";

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              minLeadingWidth: 20,
              leading: AssignmentIcon(name: viName),
              title: Text(viName),
              // subtitle: Text("User's Destination abcdefghhijadgbadjg"),
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
                    SizedBox(height: 4),
                    Text(
                      "To: " + endLocation,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              //TODO: insert trailing CTA for accept assignment
              trailing: AssignmentAcceptButton(),
              isThreeLine: true,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     TextButton(
            //       child: const Text("Accept Assignment"),
            //       onPressed: () {},
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
