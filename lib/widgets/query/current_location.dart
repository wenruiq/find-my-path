import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as flutter_location;

import 'package:find_my_path/providers/location_model.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key );

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GooglePlace googlePlace;

  @override
  void initState() {
    super.initState();

    // // //* Trick to run async await in initState
    // Future.delayed(Duration.zero, () async {
    //   await dotenv.load(fileName: ".env");
    // });

    initLocationService();
  }

  //TODO: Only for testing, need to discuss location handling
  //* Flutter location package, request permission & get cur. location
  void initLocationService() async {
    flutter_location.Location location = flutter_location.Location();

    bool _serviceEnabled;
    flutter_location.PermissionStatus _permissionGranted;
    flutter_location.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == flutter_location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != flutter_location.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    //* Update current location to provider
    Provider.of<LocationModel>(context, listen: false).setCurrentLocationLT = {
      'lat': _locationData.latitude as double,
      'long': _locationData.longitude as double
    };
  }

  //* Returns a Future which allow us to use FutureBuilder to handle loading state
  Future<String> getCurrentLocationText({required double lat, required double long}) async {
    //* Use the google_place package to perform API queries
    String apiKey = dotenv.env['GOOGLE_API_KEY'] as String;
    googlePlace = GooglePlace(apiKey);
    //* Radius set to 50m for precision (might need changes)
    var result = await googlePlace.search.getNearBySearch(Location(lat: lat, lng: long), 50);

    //* First result always "Singapore", so get second result
    var currentLocationText = result!.results![1].name as String;
    //* Update provider with location text
    Provider.of<LocationModel>(context, listen: false).setCurrentLocationText = currentLocationText;
    return currentLocationText;
  }

  @override
  Widget build(BuildContext context) {
    //* Get current Lat/Lng from provider
    double lat = Provider.of<LocationModel>(context).lat;
    double long = Provider.of<LocationModel>(context).long;
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 10),
              child: Icon(
                Icons.location_pin,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        //* Wrapping Wrap with Flexible so it works properly as a children of Row
        //* This has to do with Row taking infinite width by default
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: <Widget>[
              Text(
                "Current Location: ",
                style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              FutureBuilder<String>(
                  future: getCurrentLocationText(lat: lat, long: long),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data as String,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Unknown",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      );
                    } else {
                      return const SizedBox(height: 20, width: 20, child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
