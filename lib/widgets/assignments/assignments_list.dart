import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentsList extends StatelessWidget {
  final List<String> data;

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
          child: Text(data[index]),
        );
      },
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
