import 'package:flutter/material.dart';

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
        child: Text("lol"),
      ),
    );
  }
}
