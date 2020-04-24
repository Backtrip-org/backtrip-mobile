import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:backtrip/model/step.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/StepException.dart';
import 'package:backtrip/util/exception/TripAlreadyExistsException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
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

  static Future<Step> createStep(String name, String date, tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/step';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'name': name,
      'start_datetime': date,
    });
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Duration(seconds: 5));

    if (response.statusCode == HttpStatus.created) {
      return Step.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw new BadStepException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<Trip> createTrip(String name) async {
    var uri = '${BacktripApi.path}/trip/';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'name': name,
//      'picture_path': null
    });
    final response = await http.post(uri, headers: header, body: body)
        .timeout(Duration(seconds: 5));

    if (response.statusCode == HttpStatus.created) {
      return Trip.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.conflict) {
      throw new TripAlreadyExistsException();
    } else {
      throw new UnexpectedException();
    }
  }
}
