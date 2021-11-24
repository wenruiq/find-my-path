import 'package:flutter/material.dart';

//TODO: Change this UI

class RequestsControl extends StatelessWidget {
  const RequestsControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
        child: Column(
          children: <Widget>[
            //* View All Available Requests
            InkWell(
              onTap: () => Navigator.pushNamed(context, "/requests",
                  arguments: {"type": "request_stream", "title": "Pending Requests"}),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'View Pending Requests',
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
              onTap: () =>
                  Navigator.pushNamed(context, "/requests", arguments: {"type": "request_history", "title": "History"}),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'View History',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.chevron_right, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
