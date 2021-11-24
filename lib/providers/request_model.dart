import 'package:flutter/foundation.dart';

//* Pass data of ongoing request
class RequestModel with ChangeNotifier {
  final Map<String, dynamic> _request = {
    'rid': '',
    'viID': '',
    'viDisplayName': '',
    'voID': '',
    'voDisplayName': '',
    'currentLocationLT': {'lat': 0, 'long': 0},
    'currentLocationText': '',
    'endLocationLT': {'lat': 0, 'long': 0},
    'endLocationText': '',
    'date': DateTime.now(),
    'status': '',
  };

  //* Get all
  Map<String, dynamic> get data => _request;

  //* Specific getters
  String get rid => _request['rid'];
  String get viID => _request['viID'];
  String get viDisplayName => _request['viDisplayName'];
  String get voID => _request['voID'];
  String get voDisplayName => _request['voDisplayName'];
  Map<String, double> get currentLocationLT => _request['currentLocationLT'];
  String get currentLocationText => _request['currentLocationText'];
  Map<String, double> get endLocationLT => _request['endLocationLT'];
  String get endLocationText => _request['endLocationText'];
  DateTime get date => _request['date'];
  String get status => _request['status'];

  //* Set all data
  set setRequestData(Map<String, dynamic> requestData) {
    if (requestData.containsKey('rid')) {
      _request['rid'] = requestData['rid'];
    }
    if (requestData.containsKey('VI_ID')) {
      _request['viID'] = requestData['VI_ID'];
    }
    if (requestData.containsKey('VI_displayName')) {
      _request['viDisplayName'] = requestData['VI_displayName'];
    }
    if (requestData.containsKey('VO_ID')) {
      _request['voID'] = requestData['VO_ID'];
    }
    if (requestData.containsKey('VO_displayName')) {
      _request['voDisplayName'] = requestData['VO_displayName'];
    }
    if (requestData.containsKey('currentLocationLT')) {
      _request['currentLocationLT'] = requestData['currentLocationLT'];
    }
    if (requestData.containsKey('currentLocationText')) {
      _request['currentLocationText'] = requestData['currentLocationText'];
    }
    if (requestData.containsKey('endLocationLT')) {
      _request['endLocationLT'] = requestData['endLocationLT'];
    }
    if (requestData.containsKey('endLocationText')) {
      _request['endLocationText'] = requestData['endLocationText'];
    }
    if (requestData.containsKey('date')) {
      _request['date'] = requestData['date'];
    }
    if (requestData.containsKey('status')) {
      _request['status'] = requestData['status'];
    }

    notifyListeners();
  }

  //* Specific setters

}
