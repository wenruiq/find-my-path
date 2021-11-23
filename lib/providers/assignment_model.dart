import 'package:flutter/foundation.dart';

//* Pass data of ongoing assignment
class AssignmentModel with ChangeNotifier {
  final Map<String, dynamic> _assignment = {
    'aid': '',
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
  Map<String, dynamic> get data => _assignment;

  //* Specific getters
  String get aid => _assignment['aid'];
  String get viID => _assignment['viID'];
  String get viDisplayName => _assignment['viDisplayName'];
  String get voID => _assignment['voID'];
  String get voDisplayName => _assignment['voDisplayName'];
  Map<String, double> get currentLocationLT => _assignment['currentLocationLT'];
  String get currentLocationText => _assignment['currentLocationText'];
  Map<String, double> get endLocationLT => _assignment['endLocationLT'];
  String get endLocationText => _assignment['endLocationText'];
  DateTime get date => _assignment['date'];
  String get status => _assignment['status'];

  //* Set all data
  set setAssignmentData(Map<String, dynamic> assignmentData) {
    if (assignmentData.containsKey('aid')) {
      _assignment['aid'] = assignmentData['aid'];
    }
    if (assignmentData.containsKey('viID')) {
      _assignment['viID'] = assignmentData['viID'];
    }
    if (assignmentData.containsKey('viDisplayName')) {
      _assignment['viDisplayName'] = assignmentData['viDisplayName'];
    }
    if (assignmentData.containsKey('voID')) {
      _assignment['voID'] = assignmentData['voID'];
    }
    if (assignmentData.containsKey('voDisplayName')) {
      _assignment['voDisplayName'] = assignmentData['voDisplayName'];
    }
    if (assignmentData.containsKey('currentLocationLT')) {
      _assignment['currentLocationLT'] = assignmentData['currentLocationLT'];
    }
    if (assignmentData.containsKey('currentLocationText')) {
      _assignment['currentLocationText'] = assignmentData['currentLocationText'];
    }
    if (assignmentData.containsKey('endLocationLT')) {
      _assignment['endLocationLT'] = assignmentData['endLocationLT'];
    }
    if (assignmentData.containsKey('endLocationText')) {
      _assignment['endLocationText'] = assignmentData['endLocationText'];
    }
    if (assignmentData.containsKey('date')) {
      _assignment['date'] = assignmentData['date'];
    }
    if (assignmentData.containsKey('status')) {
      _assignment['status'] = assignmentData['status'];
    }

    notifyListeners();
  }

  //* Specific setters

}
