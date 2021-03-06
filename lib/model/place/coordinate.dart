
class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  factory Coordinate.fromPhotonJson(dynamic json) {
    return Coordinate(
        json[1],
        json[0]
    );
  }

  factory Coordinate.fromJson(dynamic json) {
    return Coordinate(
        json['latitude'],
        json['longitude']
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}