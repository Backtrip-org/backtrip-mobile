import 'dart:convert';
import 'dart:io';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {

  static Future<List<Trip>> getOngoingTrips(int userId) async {
    var uri = '${BacktripApi.path}/user/$userId/trips/ongoing';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return compute(TripService.parseTrips, response.body);
    } else {
      throw UnexpectedException();
    }
  }

  static Future<List<Trip>> getComingTrips(int userId) async {
    var uri = '${BacktripApi.path}/user/$userId/trips/coming';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return compute(TripService.parseTrips, response.body);
    } else {
      throw UnexpectedException();
    }
  }

  static Future<List<Trip>> getFinishedTrips(int userId) async {
    var uri = '${BacktripApi.path}/user/$userId/trips/finished';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return compute(TripService.parseTrips, response.body);
    } else {
      throw UnexpectedException();
    }
  }

  static Future<User> getUserById(int userId) async {
    var uri = '${BacktripApi.path}/user/$userId';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw UnexpectedException();
    }
  }
}
