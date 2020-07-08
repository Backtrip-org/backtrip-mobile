import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:backtrip/model/expense.dart';
import 'package:backtrip/model/operation.dart';
import 'package:backtrip/model/reimbursement.dart';
import 'package:backtrip/model/file.dart' as file_model;
import 'package:backtrip/model/step/step.dart';
import 'package:backtrip/model/step/step_factory.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/constants.dart';
import 'package:backtrip/util/exception/AddFileException.dart';
import 'package:backtrip/util/exception/ExpenseException.dart';
import 'package:backtrip/util/exception/OperationException.dart';
import 'package:backtrip/util/exception/ReimbursementException.dart';
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

  static List<Operation> parseOperations(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => Operation.fromJson(model)).toList();
  }

  static List<Expense> parseExpenses(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => Expense.fromJson(model)).toList();
  }

  static List<Reimbursement> parseReimbursements(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => Reimbursement.fromJson(model)).toList();
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
        .timeout(Constants.longTimeout);

    if (response.statusCode == HttpStatus.created) {
      return Step.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw new BadStepException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<file_model.File> addPhotoToStep(
      tripId, stepId, File file) async {
    var uri = '${BacktripApi.path}/trip/$tripId/step/$stepId/photo';
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

  static Future<file_model.File> addDocumentToStep(
      tripId, stepId, File file) async {
    var uri = '${BacktripApi.path}/trip/$tripId/step/$stepId/document';
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

  static Future<file_model.File> addCoverPictureToTrip(
      tripId, File file) async {
    var uri = '${BacktripApi.path}/trip/$tripId/coverPicture';
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

  static Future<Trip> createTrip(String name) async {
    var uri = '${BacktripApi.path}/trip/';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{'name': name, 'picture_path': ''});
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.created) {
      return Trip.fromJson(json.decode(response.body));
    } else if (response.statusCode == HttpStatus.conflict) {
      throw new TripAlreadyExistsException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<Step> getStep(int tripId, int stepId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/step/$stepId';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };

    final response =
        await http.get(uri, headers: header).timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return StepFactory().getStep(json.decode(response.body));
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
    var body = jsonEncode(<String, String>{'email': email});
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.badRequest) {
      throw new UserNotFoundException();
    } else if (response.statusCode != HttpStatus.noContent) {
      throw new UnexpectedException();
    }
  }

  static Future<List<User>> joinStep(Step step, int userId) async {
    var uri =
        '${BacktripApi.path}/trip/${step.tripId}/step/${step.id}/participant';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, int>{'id': userId});
    final response = await http
        .post(uri, headers: header, body: body)
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

  static Future<void> closeTrip(int tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/close';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response =
        await http.patch(uri, headers: header).timeout(Constants.timeout);

    if (response.statusCode != HttpStatus.ok) {
      throw new UnexpectedException();
    }
  }

  static Future<Expense> createExpense(
      double totalAmount, String name, User mainPayer, Trip trip) async {
    var uri = '${BacktripApi.path}/trip/${trip.id}/expense';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{
      'cost': totalAmount.toString(),
      'name': name,
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

  static Future<void> createReimbursement(
      double amount, int userId, Trip trip, int payeeId,
      {int expenseId = 0}) async {
    var uri = '${BacktripApi.path}/trip/${trip.id}/reimbursement';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body;
    if (expenseId != 0) {
      var reimbursement = Reimbursement(
          cost: amount,
          emitterId: userId,
          expenseId: expenseId,
          payeeId: payeeId,
          tripId: trip.id);
      body = jsonEncode(reimbursement.toJsonWithExpenseId());
    } else {
      var reimbursement = Reimbursement(
          cost: amount, emitterId: userId, payeeId: payeeId, tripId: trip.id);
      body = jsonEncode(reimbursement.toJsonWithoutExpenseId());
    }
    final response = await http
        .post(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return Reimbursement.fromJson(json.decode(response.body));
    } else {
      throw ReimbursementException();
    }
  }

  static Future<List<Operation>> getTransactionsToBeMade(
      Trip trip, int userId) async {
    var uri =
        '${BacktripApi.path}/trip/${trip.id}/transactionsToBeMade/$userId';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: header);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseOperations, response.body);
    } else {
      throw OperationException();
    }
  }

  static Future<List<Expense>> getUserExpenses(Trip trip, int userId) async {
    var uri = '${BacktripApi.path}/trip/${trip.id}/user/$userId/expenses';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: header);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseExpenses, response.body);
    } else {
      throw ExpenseException();
    }
  }

  static Future<List<Reimbursement>> getExpenseReimbursements(
      Trip trip, Expense expense) async {
    var uri =
        '${BacktripApi.path}/trip/${trip.id}/expense/${expense.id}/reimbursements';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: header);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseReimbursements, response.body);
    } else {
      throw ExpenseException();
    }
  }

  static Future<Uint8List> getTravelJournal(int tripId) async {
    var uri = '${BacktripApi.path}/trip/$tripId/travelJournal';
    var header = <String, String>{
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response =
        await http.get(uri, headers: header).timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return response.bodyBytes;
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<void> updateNotes(int tripId, int stepId, String notes) async {
    var uri = '${BacktripApi.path}/trip/${tripId}/step/${stepId}/notes';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    var body = jsonEncode(<String, String>{'notes': notes});
    final response = await http
        .put(uri, headers: header, body: body)
        .timeout(Constants.timeout);

    if (response.statusCode != HttpStatus.ok) {
      throw new UnexpectedException();
    }
  }

  static Future<List<String>> suggestStep() async {
    var uri =
        '${BacktripApi.path}/trip/step/suggest';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http
        .get(uri, headers: header)
        .timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseSuggestions, response.body);
    } else {
      throw new UnexpectedException();
    }
  }

  static List<String> parseSuggestions(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((entry) => entry['name'].toString()).toList();
  }
}
