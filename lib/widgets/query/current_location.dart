import 'package:flutter/material.dart';

class CurrentLocation extends StatefulWidget {
  //TODO: receive user's geolocation long and lat to get current location
  //TODO: probably need a spinner/loading status while waiting for that too
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Icon(
            Icons.location_pin,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              "Current Location:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[900],
              ),
            ),
            //TODO: Change this to current location of user
            Text(
              "Singapore Management University",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
