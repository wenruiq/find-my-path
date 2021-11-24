import 'package:flutter/material.dart';

class BadgeScreen extends StatelessWidget {
  static const routeName = '/badge';

  const BadgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ratings"),
      ),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}
