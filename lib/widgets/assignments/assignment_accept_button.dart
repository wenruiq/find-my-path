import 'package:flutter/material.dart';

class AssignmentAcceptButton extends StatelessWidget {
  const AssignmentAcceptButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      //TODO: interact with firebase with this function, probably should have the id of the assignment passed here
      onPressed: () {},
      child: const Text("Accept"),
    );
  }
}
