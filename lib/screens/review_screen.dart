import "package:flutter/material.dart";

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  static const routeName = "/review";

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Review Screen"),
        ),
        body: const SafeArea(
          child: Center(
            child: Text("ha???"),
          ),
        ));
  }
}
