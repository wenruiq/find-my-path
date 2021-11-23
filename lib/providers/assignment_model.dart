import 'dart:convert';
import 'dart:async';

import 'package:find_my_path/widgets/query/current_location.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Assignment with ChangeNotifier {
  final String aid;
  final String vi_id;
  final String vi_displayName;
  String vo_id;
  String vo_displayName;
  final DateTime date;
  final String imageURL;
  final Object currentLocation;
  final Object endLocation;
  String status;
  String timeTaken;

  Assignment({
    required this.aid,
    required this.vi_id,
    required this.vi_displayName,
    required this.vo_id,
    required this.vo_displayName,
    required this.date,
    required this.imageURL,
    required this.currentLocation,
    required this.endLocation,
    required this.status,
    required this.timeTaken,
  });

  String get assignmentID {
    return aid;
  }

  void set assignmentStatus(String status) {
    this.status = status;
    //* Add in firebase link to update assignment status
    notifyListeners();
  }

  void _setAssignmentStatusAfterAcceptance(String status) {
    this.status = status;
    notifyListeners();
  }

  void set assignmentVolunteer(Map<String, String> volunteerDetails) {
    vo_id = volunteerDetails["voID"].toString();
    vo_displayName = volunteerDetails["voName"].toString();
    _setAssignmentStatusAfterAcceptance("Ongoing");
  }

  Map<String, dynamic> toMap() {
    return {
      'VI_ID': vi_id,
      "VI_displayName": vi_displayName,
      "VO_ID": vo_id,
      "VO_displayName": vo_displayName,
      "date": date,
      "imageURL": imageURL,
      "currentLocation": currentLocation,
      "endLocation": endLocation,
      "status": status,
      "timeTaken": timeTaken,
    };
  }
}
