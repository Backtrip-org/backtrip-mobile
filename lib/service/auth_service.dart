import 'dart:convert';
import 'dart:io';

import 'package:backtrip/util/constants.dart';
import 'package:backtrip/util/exception/LoginException.dart';
import 'package:backtrip/model/login.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/current_user.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/exception/UserAlreadyExistsException.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<void> login(String email, String password) async {
    var uri = '${BacktripApi.path}/auth/login';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });
    final response = await http.post(uri, headers: header, body: body).timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      Login login = Login.fromJson(json.decode(response.body));
      StoredToken.storeToken(login.authorization);
      BacktripApi.currentUser = new CurrentUser(login.id);
    } else if (response.statusCode == HttpStatus.badRequest) {
      throw new EmailPasswordInvalidException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<void> register(String email, String password, String firstName, String lastName) async {
    var uri = '${BacktripApi.path}/user/';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'firstname': firstName,
      'lastname': lastName
    });
    final response = await http.post(uri, headers: header, body: body).timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.created) {
      return login(email, password);
    } else if (response.statusCode == HttpStatus.conflict) {
      throw new UserAlreadyExistsException();
    } else {
      throw new UnexpectedException();
    }
  }

  static Future<void> isUserAlreadyLogged() async {
    var uri = '${BacktripApi.path}/auth/isUserAlreadyLogged';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);

    if(response.statusCode == HttpStatus.ok) {
      BacktripApi.currentUser = new CurrentUser(json.decode(response.body)['id']);
    } else {
      throw new InvalidTokenException();
    }
  }
}
