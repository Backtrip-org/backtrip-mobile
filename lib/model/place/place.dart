import 'package:backtrip/model/place/coordinate.dart';

class Place {
  Coordinate coordinate;
  String country;
  String city;
  String postcode;
  String name;
  String state;
  
  Place(this.coordinate, this.country, this.city, this.postcode, this.name, this.state);

  String getAddress() {
    return '$name, $postcode $city, $country';
  }

  factory Place.fromJson(dynamic json) {
    return Place(
      Coordinate(1,1),
      json['properties']['country'] ?? '',
      json['properties']['city'] ?? '',
      json['properties']['postcode'] ?? '',
      json['properties']['name'] ?? '',
      json['properties']['state'] ?? '',
    );
  }
}