import 'dart:io';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {

  static Future<List<Trip>> getTrips(userId) async {
    var uri = '${BacktripApi.path}/user/${userId}/trips';
    var headers = { HttpHeaders.authorizationHeader: BacktripApi.token };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return compute(TripService.parseTrips, response.body);
    } else {
      throw Exception('Failed to load trips');
    }
  }
}