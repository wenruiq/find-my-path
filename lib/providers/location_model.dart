import "package:flutter/foundation.dart";

//* Probably need some modifications
//* Created just for testing
class LocationModel extends ChangeNotifier {
  final Map<String, double> _currentLocation = {'lat': 0, 'long': 0};

  get curLo => _currentLocation;
  get lat => _currentLocation['lat'];
  get long => _currentLocation['long'];

  set setCurrentLocation(Map<String, double> latLong) {
    _currentLocation['lat'] = latLong['lat'] as double;
    _currentLocation['long'] = latLong['long'] as double;

    notifyListeners();
  }
}
