import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/util/loading.dart';
import '../screens/chat_screen.dart';

//* This screen receives all the form info from query_screen
//* and perform the logic required to get a match and enter a chat room

//* REF:
//* api.flutter.dev/flutter/widgets/FutureBuilder-class.html
//* pub.dev/packages/http

class QueryLoadingScreen extends StatefulWidget {
  const QueryLoadingScreen({Key? key}) : super(key: key);
  static const routeName = '/queryloading';

  @override
  _QueryLoadingScreenState createState() => _QueryLoadingScreenState();
}

class _QueryLoadingScreenState extends State<QueryLoadingScreen> {
  bool _loading = true;

  //* PLACEHOLDER CODE TO TEST LOADING / LOADED SCREENS
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 1),
    () => 'Data Loaded',
  );

  void initPage() async {
    await _calculation;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    initPage();
    return Scaffold(
      appBar: _loading ? AppBar() : null,
      body: _loading ? const Loading() : const ChatScreen(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //       future: http.get(
  //         Uri.parse('http://google.com.sg'),
  //       ),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           if (snapshot.hasError) {
  //             //return something to handle error
  //           }
  //           return Text('yay');
  //         } else {
  //           return Text('loading..');
  //         }
  //       });
}
