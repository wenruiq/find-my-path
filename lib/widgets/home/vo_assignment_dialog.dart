import 'package:flutter/material.dart';
import "dart:io";

//TODO: Change this implementation to make it work

class AssignmentDialog extends StatelessWidget {
  const AssignmentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //* Assignment Title
      title: Center(
        child: Text(
          "New Assignment",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
        ),
      ),
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.only(top: 14.0),

      //* Assignment Contents
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.7,
        //* This column splits the main content from the accept & decline buttons
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //* This expanded column contains all details about the assignment
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //* Assignment Image
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(
                        'assets/images/assignmentPlaceholder.png',
                        fit: BoxFit.contain),
                  ),
                  //* VI details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Requestor: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        //TODO: Change to real assignment VI_displayName
                        "Craig",
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  //* Start location details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Start: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          //TODO: Change to real assignment currentLocation.name
                          "Singapore Management University",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  //* End location details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Destination: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          //TODO: Change to real assignment endLocation.name
                          "Orchard Center",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //* These are the assignment controls
            SimpleDialogOption(
                // onPressed: () {}, child: const Text("Accept")),
                onPressed: () {},
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/base/chat"),
                      child: const Text('Accept Assignment')),
                )),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
