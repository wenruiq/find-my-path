import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import '../util/loading.dart';
import '../../providers/request_model.dart';
import '../../providers/user_model.dart';

const double cameraZoom = 16;
const double cameraTilt = 80;
const double cameraBearing = 30;

class LiveLocationMap extends StatefulWidget {
  const LiveLocationMap({Key? key}) : super(key: key);

  @override
  _LiveLocationMapState createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<LiveLocationMap> {
  late StreamSubscription _myLocationChangeSubscription;
  late StreamSubscription _hisLocationChangeSubscription;

  GoogleMapController? mapController;
  Map<MarkerId, Marker> markers = {};

  //* For drawn routes on the map
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  //* API KEY
  String apiKey = dotenv.env['GOOGLE_API_KEY'] as String;

  //* For custom mark pin icons
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  //* User's location as he/she moves
  LocationData? currentLocation;
  LocationData? endLocation;

  //* Wrapper around the location API
  late Location location;

  int _counter = 0;
  DatabaseError? _error;

  @override
  void initState() {
    super.initState();

    //* Load .env to get API KEY later
    // Future.delayed(Duration.zero, () async {
    //   await dotenv.load(fileName: ".env");
    // });

    //* Create an instance of location
    location = Location();
    polylinePoints = PolylinePoints();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //* Realtime Database
      // DatabaseReference testRef = FirebaseDatabase.instance.reference();
      // _hisLocationChangeSubscription = testRef.onValue.listen((Event event) {
      //   print("received change@@@@@@@@@@@@@@22");
      //   setState(() {
      //     _error = null;
      //     _counter = event.snapshot.value ?? 0;
      //   });
      // }, onError: (Object o) {
      //   final DatabaseError error = o as DatabaseError;
      //   setState(() {
      //     _error = error;
      //   });
      // });

      //TODO: VO needs to listen to realtimedatabase not his own location
      //* Subscribe to changes in the user's location
      //* by listening to the location's onLocationChanged event
      _myLocationChangeSubscription = location.onLocationChanged.listen((LocationData cLoc) {
        //* cLoc contains the user's current location in real time
        currentLocation = cLoc;
        //* Update pin on map since location changed
        updatePinOnMap();
      });
    });

    //* Set custom marker pins
    setSourceAndDestinationIcons();

    //* Set initial location (both current & end)
    setInitialLocation();
  }

  //* Dispose subscription
  @override
  void dispose() {
    _myLocationChangeSubscription.cancel();
    super.dispose();
  }

  //* Need this to use custom icons when showing pins on map
  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(devicePixelRatio: 2.0), 'assets/icons/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0), 'assets/icons/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    //* Set endLocation using info from provider
    Map<String, dynamic> requestData = Provider.of<RequestModel>(context, listen: false).data;
    double endLat = requestData['endLocationLT']['lat'];
    double endLong = requestData['endLocationLT']['long'];
    LocationData endLocationData = LocationData.fromMap({"latitude": endLat, "longitude": endLong});
    double startLat = requestData['currentLocationLT']['lat'];
    double startLong = requestData['currentLocationLT']['long'];
    LocationData currentLocationData = LocationData.fromMap({"latitude": startLat, "longitude": startLong});

    if (mounted) {
      setState(() {
        currentLocation = currentLocationData;
        endLocation = endLocationData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (endLocation == null || currentLocation == null) {
      setInitialLocation();
      return const Loading(
        description: "Loading Google Maps",
      );
    } else {
      //* Set initial camera position using currentLocation (which holds starting location)
      CameraPosition initialCameraPosition = CameraPosition(
        target: LatLng(
          currentLocation!.latitude as double,
          currentLocation!.longitude as double,
        ),
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
      );
      return Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Flexible(
            child: GoogleMap(
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: _onMapCreated,
            ),
          ),
        ],
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await controller.setMapStyle(Utils.mapStyles);
    showPinsOnMap();
  }

  //* This step is just to show 2 pins on map, source and endlocation
  //* as well as draw the route in between
  void showPinsOnMap() {
    if (currentLocation != null && endLocation != null) {
      //* Get LagLng for source & endlocation to know where to place the pins
      var pinPosition = LatLng(currentLocation!.latitude as double, currentLocation!.longitude as double);
      var destPosition = LatLng(endLocation!.latitude as double, endLocation!.longitude as double);

      //* Place the pins
      _addMarker(pinPosition, "sourcePin", sourceIcon);
      _addMarker(destPosition, "destPin", destinationIcon);

      //* Draw route line on map
      setPolylines();
    }
  }

  //* Helper function to add polyline
  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 40, 122, 198),
      points: polylineCoordinates,
      width: 2,
    );
    polylines[id] = polyline;
    if (mounted) {
      setState(() {});
    }
  }

  //* This draws polylines on map
  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(
          currentLocation!.latitude as double,
          currentLocation!.longitude as double,
        ),
        PointLatLng(
          endLocation!.latitude as double,
          endLocation!.longitude as double,
        ));

    if (result.points.isNotEmpty) {
      List<PointLatLng> points = result.points;
      for (PointLatLng point in points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    _addPolyLine();
  }

  void updatePinOnMap() async {
    if (currentLocation != null && mapController != null) {
      print("@@ Updating pin on map cuz location changed... @@");
      //* Create a new CameraPosition instance every time the location changes,
      //* so the camera follows the pin as it moves with an animation
      CameraPosition cPosition = CameraPosition(
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
        target: LatLng(currentLocation!.latitude as double, currentLocation!.longitude as double),
      );
      //* Move camera with the new CameraPosition above
      mapController?.animateCamera(CameraUpdate.newCameraPosition(cPosition));

      //* Set state so Flutter knows widget update is due
      if (mounted) {
        setState(() {
          //* Create a new pin position with latest location
          var pinPosition = LatLng(currentLocation!.latitude as double, currentLocation!.longitude as double);
          //* Remove old pin and add new
          markers.removeWhere((m, v) => m.value == 'sourcePin');
          _addMarker(pinPosition, "sourcePin", sourceIcon);
        });
      }
    }
  }

  //* Helper function to add markers
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}

//* This is used for styling
class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
