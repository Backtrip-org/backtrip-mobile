import 'dart:convert';
import 'dart:io';

import 'package:backtrip/model/Expense.dart';
import 'package:backtrip/model/Owe.dart';
import 'package:backtrip/model/step/step.dart';
import 'package:backtrip/model/step/step_factory.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/constants.dart';
import 'package:backtrip/util/exception/AddDocumentToStepException.dart';
import 'package:backtrip/util/exception/ExpenseException.dart';
import 'package:backtrip/util/exception/OweException.dart';
import 'package:backtrip/util/exception/StepException.dart';
import 'package:backtrip/util/exception/TripAlreadyExistsException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/exception/UserNotFoundException.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class TripService {
  static Future<List<Step>> getGlobalTimeline(tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/timeline';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseSteps, response.body);
    } else {
      throw Exception('Failed to load global timeline');
    }
  }

  static Future<List<Step>> getPersonalTimeline(tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/timeline/personal';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseSteps, response.body);
    } else {
      throw Exception('Failed to load personal timeline');
    }
  }

  static List<Trip> parseTrips(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => Trip.fromJson(model)).toList();
  }

  static List<Step> parseSteps(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => StepFactory().getStep(model)).toList();
  }

  static Future<Step> createStep(Step step) async {
    var uri = '${BacktripApi.path}/trip/${step.tripId}/step';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };

    var body = jsonEncode(step.toJson());

    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.created) {
      return Step.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw new BadStepException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<void> addDocumentToStep(tripId, stepId, File file) async {
    var uri = '${BacktripApi.path}/trip/$tripId/step/$stepId/document';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };

    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.headers.addAll(header);
    request.files.add(
      http.MultipartFile.fromBytes(
          'file',
          file.readAsBytesSync(),
          filename: path.basename(file.path)
      )
    );

    final response = await request.send();

    if(response.statusCode == HttpStatus.ok) {
      return;
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw new AddDocumentToStepException();
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
      'picture_path': ''
    });
    final response = await http.post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.created) {
      return Trip.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.conflict) {
      throw new TripAlreadyExistsException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<void> inviteToTrip(int tripId, String email) async {
    var uri = '${BacktripApi.path}/trip/$tripId/invite';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'email': email
    });
    final response = await http.post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.badRequest) {
      throw new UserNotFoundException();
    } else if (response.statusCode != HttpStatus.noContent) {
      throw new UnexpectedException();
    }
  }

  static Future<List<User>> joinStep(Step step, int userId) async {
    var uri = '${BacktripApi.path}/trip/${step.tripId}/step/${step.id}/participant';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, int>{
      'id': userId
    });
    final response = await http.post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseStepParticipants, response.body);
    } else {
      throw new UnexpectedException();
    }
  }

  static List<User> parseStepParticipants(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => User.fromJson(model)).toList();
  }

  static Future<Expense> createExpense(double totalAmount, User mainPayer, Trip trip) async {
    var uri = '${BacktripApi.path}/trip/${trip.id}/expense';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'cost': totalAmount.toString(),
      'user_id': mainPayer.id.toString(),
      'trip_id': trip.id.toString()
    });
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return Expense.fromJson(json.decode(response.body));
    } else {
      throw ExpenseException();
    }
  }

  static Future<void> createOwe(double amount, int userId, int expenseId, Trip trip) async {
    var uri = '${BacktripApi.path}/trip/${trip.id}/owe';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'cost': amount.toString(),
      'user_id': userId.toString(),
      'expense_id': expenseId.toString()
    });
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return Owe.fromJson(json.decode(response.body));
    } else {
      throw OweException();
    }
  }
}
