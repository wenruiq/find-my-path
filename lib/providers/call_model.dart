import 'package:flutter/foundation.dart';

class Call with ChangeNotifier {
  final Map<String, dynamic> _call = {
    'callerID': '',
    'receiverID': '',
    'isCalling': false,
    'isActive': false,
  };

  Map<String, dynamic> get data => _call;

  String get callerID => _call['callerID'];
  String get callerName => _call['callerName'];
  String get receiverID => _call['receiverID'];
  String get receiverName => _call['receiverName'];
  String get channelId => _call['channelId'];
  bool get hasDialled => _call['hasDialled'];

  set setCallData(Map<String, dynamic> callData) {
    if (callData.containsKey('callerID')) {
      _call['callerID'] = callData['callerID'];
    }
    if (callData.containsKey('callerName')) {
      _call['callerName'] = callData['callerName'];
    }
    if (callData.containsKey('receiverID')) {
      _call['receiverID'] = callData['receiverID'];
    }
    if (callData.containsKey('receiverName')) {
      _call['receiverName'] = callData['receiverName'];
    }
    if (callData.containsKey('channelId')) {
      _call['channelId'] = callData['channelId'];
    }
    if (callData.containsKey('hasDialled')) {
      _call['hasDialled'] = callData['hasDialled'];
    }

    notifyListeners();
  }
}
