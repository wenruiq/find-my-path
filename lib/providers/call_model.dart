import 'package:flutter/foundation.dart';

class Call with ChangeNotifier {
  final Map<String, dynamic> _call = {
    'callerId': '',
    'receiverId': '',
    'isCalling': false,
    'isActive': false,
  };

  Map<String, dynamic> get data => _call;

  String get callerId => _call['callerId'];
  String get callerName => _call['callerName'];
  String get receiverId => _call['receiverId'];
  String get receiverName => _call['receiverName'];
  String get channelId => _call['channelId'];
  bool get hasDialled => _call['hasDialled'];

  set setCallData(Map<String, dynamic> callData) {
    if (callData.containsKey('callerId')) {
      _call['callerId'] = callData['callerId'];
    }
    if (callData.containsKey('callerName')) {
      _call['callerName'] = callData['callerName'];
    }
    if (callData.containsKey('receiverId')) {
      _call['receiverId'] = callData['receiverId'];
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
