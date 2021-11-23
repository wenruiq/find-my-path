import 'package:flutter/material.dart';

class AssignmentIcon extends StatelessWidget {
  final String name;

  const AssignmentIcon({required this.name, Key? key}) : super(key: key);

  String getInitials(String name) =>
      name.isNotEmpty ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join().toUpperCase() : "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          child: Text(getInitials(name),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
    );
  }
}
