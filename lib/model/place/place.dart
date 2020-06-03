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

  factory Place.fromPhotonJson(dynamic json) {
    return Place(
      Coordinate.fromPhotonJson(json['geometry']['coordinates']),
      json['properties']['country'] ?? '',
      json['properties']['city'] ?? '',
      json['properties']['postcode'] ?? '',
      json['properties']['name'] ?? '',
      json['properties']['state'] ?? '',
    );
  }

  factory Place.fromJson(dynamic json) {
    if (json == null)
      return null;

    return Place(
      Coordinate.fromJson(json['coordinates']),
      json['country'] ?? '',
      json['city'] ?? '',
      json['postcode'] ?? '',
      json['name'] ?? '',
      json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'coordinate': coordinate?.toJson(),
    'country': country,
    'city': city,
    'postcode': postcode,
    'name': name,
    'state': state
  };
}