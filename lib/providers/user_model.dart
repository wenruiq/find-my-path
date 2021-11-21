import "package:flutter/foundation.dart";

class UserModel extends ChangeNotifier {
  final Map<String, dynamic> _user = {};

  Map<String, dynamic> get data => _user;

  bool get isAvailable => _user['isAvailable'];

  void updateUserData(Map<String, dynamic> userData) {
    _user['uid'] = userData['uid'];
    _user['email'] = userData['email'];
    _user['displayName'] = userData['displayName'];
    _user['isVolunteer'] = userData['isVolunteer'];
    _user['isAvailable'] = userData['isAvailable'];

    notifyListeners();
  }

  void updateAvailability(bool isAvailable) {
    _user['isAvailable'] = isAvailable;

    notifyListeners();
  }
}
