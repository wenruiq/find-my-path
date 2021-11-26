import 'package:firebase_database/firebase_database.dart';
import 'realtime_location.dart';

class RealtimeLocationDAO {
  final DatabaseReference _realtimeLocationRef = FirebaseDatabase.instance.reference().child('realtimeLocation');

  void saveRealtimeLocation(RealtimeLocation location) {
    print("saving");
    _realtimeLocationRef.set(location.toJson());
  }
}
