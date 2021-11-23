import "package:flutter/foundation.dart";

//* Probably need some modifications
//* Created just for testing
class LocationModel extends ChangeNotifier {
  final Map<String, double> _currentLocationLT = {'lat': 0, 'long': 0};
  String currentLocationText = "";

  get currenLocationLT => _currentLocationLT;
  get lat => _currentLocationLT['lat'];
  get long => _currentLocationLT['long'];

  set setCurrentLocationLT(Map<String, double> latLong) {
    _currentLocationLT['lat'] = latLong['lat'] as double;
    _currentLocationLT['long'] = latLong['long'] as double;

    notifyListeners();
  }

  set setCurrentLocationText(String text) {
    currentLocationText = text;
  }
}
