import 'package:find_my_path/widgets/assignments/assignment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../stream_indicator/pulsing_indicator.dart';
import './assignment.dart';

class AssignmentsList extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String type;

  const AssignmentsList({
    required this.data,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dataLength = data.isEmpty ? "No Assignment" : '${data.length} Assignments';

    if (data.length == 1) {
      dataLength = "1 Assignment";
    }

    return Column(
      children: [
        if (type == "assignment_stream")
          PulsingIndicator(
            icon: Ionicons.radio_outline,
            message: dataLength + " Available",
          ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return Assignment(
                assignmentDetails: data[index],
              );
            },
            // physics: const AlwaysScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }
}
