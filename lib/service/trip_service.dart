import 'dart:convert';
import 'dart:io';

import 'package:backtrip/model/step.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TripService {
  static Future<List<Step>> getTimeline(tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/timeline';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseSteps, response.body);
    } else {
      throw Exception('Failed to load timeline');
    }
  }

  static List<Trip> parseTrips(String responseBody) {
    Iterable data = json.decode(responseBody)['data'];
    return data.map((model) => Trip.fromJson(model)).toList();
  }

  static List<Step> parseSteps(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => Step.fromJson(model)).toList();
  }
}