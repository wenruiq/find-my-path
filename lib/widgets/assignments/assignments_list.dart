import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'assignment_item.dart';

class AssignmentsList extends StatelessWidget {
  final List<Object> data;

  const AssignmentsList({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (ctx, index) {
        return Card(
          child: AssignmentItem(
            assignmentDetails: data[index],
          ),
        );
      },
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
