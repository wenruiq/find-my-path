class RealtimeLocation {
  late final double lat;
  late final double long;

  RealtimeLocation(this.lat, this.long);

  RealtimeLocation.fromJson(Map<dynamic, dynamic> json)
      : lat = double.parse(json['lat'] as String),
        long = double.parse(json['long'] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'lat': lat.toString(),
        'long': long.toString(),
      };
}
