import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.description}) : super(key: key);

  final String description;

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
            Text(description,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26, color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }
}
