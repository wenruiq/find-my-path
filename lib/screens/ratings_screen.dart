import 'package:flutter/material.dart';

import '../widgets/assignments/assignment_icon.dart';

class RatingScreen extends StatelessWidget {
  static const routeName = '/rating';

  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ratings"),
      ),
      body: const Center(
        child: AssignmentIcon(name: "Alex"),
      ),
    );
  }
}
