import 'dart:convert';
import 'dart:io';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/exception/AddFileException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:backtrip/model/file.dart' as file_model;
import 'package:path/path.dart' as path;

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

  static Future<file_model.File> updateProfilePicture(
      userId, File file) async {
    var uri = '${BacktripApi.path}/user/$userId/profilePicture';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };

    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.headers.addAll(header);
    request.files.add(http.MultipartFile.fromBytes(
        'file', file.readAsBytesSync(),
        filename: path.basename(file.path)));

    final streamedResponse = await request.send();
    final response = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == HttpStatus.ok) {
      return file_model.File.fromJson(json.decode(response));
    } else if (streamedResponse.statusCode == HttpStatus.badRequest) {
      throw new AddFileException();
    } else {
      throw new UnexpectedException();
    }
  }
}
