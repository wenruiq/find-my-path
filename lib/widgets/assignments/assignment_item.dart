import 'package:flutter/material.dart';

class AssignmentItem extends StatelessWidget {
  final Object assignmentDetails;

  const AssignmentItem({
    required this.assignmentDetails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var name = assignmentDetails.name;

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.verified_user),
              title: Text("ABC"),
              subtitle: Text("User's Destination"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text("View Assignment"),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
