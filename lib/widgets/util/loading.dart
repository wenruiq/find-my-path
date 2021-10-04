import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//* This is the transition loading screen for pages that require processing

//TODO: check how loading looks on a real device - currently it covers the phone top UI, looks kinda weird

//TODO: customize to take in a String and display as loading text below loader

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCube(color: Theme.of(context).primaryColor, size: 80),
            const SizedBox(
              height: 80,
            ),
            const Text("Finding A Volunteer ...",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
