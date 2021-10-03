import 'package:flutter/material.dart';

class AssignmentControl extends StatelessWidget {
  const AssignmentControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        child: Column(
          children: <Widget>[
            //* View All Available Requests
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/assignments",
                  arguments: {"title": "Available Assignments"}),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Accept an assignment',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.chevron_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
              height: 1,
            ),
            //* View Accepted Requests
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/assignments",
                  arguments: {"title": "Past Assignments"}),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Past assignments',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.chevron_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            // const Divider(
            //   indent: 10,
            //   endIndent: 10,
            //   height: 1,
            // ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     //* Ongoing Icon
            //     InkWell(
            //       onTap: () => Navigator.pushNamed(context, "/assignments",
            //           arguments: {"title": "My Assignments"}),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 12.0, horizontal: 25),
            //         child: Column(
            //           children: const [
            //             Icon(Icons.event_available,
            //                 color: Colors.black, size: 42),
            //             Text(
            //               "Ongoing",
            //               style: TextStyle(fontSize: 16),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     //* History Icon
            //     InkWell(
            //       onTap: () => Navigator.pushNamed(context, "/assignments",
            //           arguments: {"title": "Past Assignments"}),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 12.0, horizontal: 25),
            //         child: Column(
            //           children: const [
            //             Icon(Icons.history, color: Colors.black, size: 42),
            //             Text(
            //               "History",
            //               style: TextStyle(fontSize: 16),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}