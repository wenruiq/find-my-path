import 'package:flutter/material.dart';

//* This widget is the circle containing the VI's initials on the left of items in AssignmentsList / Assignment
class AssignmentIcon extends StatelessWidget {
  final String name;

  //* Requires VI's name from Assignment
  const AssignmentIcon({required this.name, Key? key}) : super(key: key);

  //* Converts any names into 0-2 capitalized initial alphabets e.g. Robert Zane -> RZ
  String getInitials(String name) =>
      name.isNotEmpty ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase() : "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //* 60 looks the most normal when placed in Assignment
      width: 60,
      height: 60,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            getInitials(name),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
