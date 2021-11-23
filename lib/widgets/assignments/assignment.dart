import 'package:flutter/material.dart';

import './assignment_icon.dart';
import './assignment_accept_button.dart';

class Assignment extends StatelessWidget {
  final Object assignmentDetails;

  const Assignment({
    required this.assignmentDetails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var name = assignmentDetails.name;

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ListTile(
              leading: AssignmentIcon(name: "CA"),
              title: Text("User's Starting Location"),
              subtitle: Text("User's Destination"),
              //TODO: insert trailing CTA for accept assignment
              trailing: AssignmentAcceptButton(),
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
