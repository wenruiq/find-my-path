import "package:flutter/foundation.dart";

class UserModel extends ChangeNotifier {
  final Map<String, dynamic> _user = {};

  Map<String, dynamic> get data => _user;

  void updateUserData(Map<String, dynamic> userData) {
    print("Updating user data...");
    _user['uid'] = userData['uid'];
    _user['email'] = userData['email'];
    _user['displayName'] = userData['displayName'];
    _user['isVolunteer'] = userData['isVolunteer'];
    _user['isAvailable'] = userData['isAvailable'];

    notifyListeners();
  }
}
