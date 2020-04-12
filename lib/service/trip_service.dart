import 'dart:convert';

import 'package:backtrip/model/trip.dart';

class TripService {
  static List<Trip> parseTrips(String responseBody) {
    Iterable data = json.decode(responseBody)['data'];
    return data.map((model) => Trip.fromJson(model)).toList();
  }
}