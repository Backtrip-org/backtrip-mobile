class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  factory Coordinate.fromJson(dynamic json) {
    return Coordinate(
        double.parse(json['0']),
        double.parse(json['1'])
    );
  }
}