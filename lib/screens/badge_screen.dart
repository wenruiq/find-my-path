import 'package:flutter/material.dart';

//* Displays a list of all of the user's badges
class BadgeScreen extends StatelessWidget {
  static const routeName = '/badge';

  const BadgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rate Your Volunteer"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              //TODO: Add popup confirmation dialog
              onPressed: () => {},
            ),
          ],
        ),
        body: const Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
