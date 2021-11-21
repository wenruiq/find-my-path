import "package:flutter/foundation.dart";

class UserModel extends ChangeNotifier {
  final Map<String, dynamic> _user = {
    'uid': '',
    'email': '',
    'displayName': '',
    'isVolunteer': true,
    'isAvailable': false
  };

  //* Get all data
  Map<String, dynamic> get data => _user;

  //* Specific getters
  bool get isAvailable => _user['isAvailable'];
  bool get isVolunteer => _user['isVolunteer'];
  String get uid => _user['uid'];
  String get email => _user['email'];
  String get displayName => _user['displayName'];

  //* Set all data
  set setUserData(Map<String, dynamic> userData) {
    _user['uid'] = userData['uid'];
    _user['email'] = userData['email'];
    _user['displayName'] = userData['displayName'];
    _user['isVolunteer'] = userData['isVolunteer'];
    _user['isAvailable'] = userData['isAvailable'];

    notifyListeners();
  }

  //* Specific setters
  set setIsAvailable(bool isAvailable) {
    _user['isAvailable'] = isAvailable;

    notifyListeners();
  }
}
