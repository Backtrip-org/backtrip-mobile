import 'package:backtrip/model/place/coordinate.dart';

class Place {
  Coordinate coordinate;
  String name;
  String street;
  String houseNumber;
  String country;
  String city;
  String postcode;
  String state;
  double rating;

  Place(this.coordinate, this.name, this.street, this.houseNumber, this.country, this.city, this.postcode, this.state, {this.rating});

  String getTitleAddress() {
    String houseNumberAndStreet = [houseNumber,street].where((str) => str != null && str != '').join(' ');
    return hasName() ? name : houseNumberAndStreet;
  }

  String getSubtitleAddress() {
    String cityAndCountry = [city,country].where((str) => str != null && str != '').join(', ');
    String houseNumberAndStreet = [houseNumber,street].where((str) => str != null && str != '').join(' ');
    String all = [houseNumberAndStreet, cityAndCountry].where((str) => str != null && str != '').join((', '));

    return hasName() ? all : cityAndCountry;
  }

  String getLongAddress() {
    String cityAndCountry = [city,country].where((str) => str != null && str != '').join(', ');
    String houseNumberAndStreet = [houseNumber,street].where((str) => str != null && str != '').join(' ');
    return [name, houseNumberAndStreet, cityAndCountry].where((str) => str != null && str != '').join((', '));
  }

  bool hasName() {
    return name != null && name != '';
  }

  factory Place.fromPhotonJson(dynamic json) {
    return Place(
      Coordinate.fromPhotonJson(json['geometry']['coordinates']),
      json['properties']['name'] ?? '',
      json['properties']['street'] ?? '',
      json['properties']['housenumber'] ?? '',
      json['properties']['country'] ?? '',
      json['properties']['city'] ?? '',
      json['properties']['postcode'] ?? '',
      json['properties']['state'] ?? '',
    );
  }

  factory Place.fromJson(dynamic json) {
    if (json == null)
      return null;

    return Place(
      Coordinate.fromJson(json['coordinates']),
      json['name'] ?? '',
      json['street'] ?? '',
      json['house_number'] ?? '',
      json['country'] ?? '',
      json['city'] ?? '',
      json['postcode'] ?? '',
      json['state'] ?? '',
      rating: json['rating']
    );
  }

  Map<String, dynamic> toJson() => {
    'coordinate': coordinate?.toJson(),
    'name': name,
    'street': street,
    'house_number': houseNumber,
    'country': country,
    'city': city,
    'postcode': postcode,
    'state': state
  };
}