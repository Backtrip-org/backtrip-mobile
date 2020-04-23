import 'dart:convert';
import 'dart:io';

import 'package:backtrip/util/exception/LoginException.dart';
import 'package:backtrip/model/login.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/current_user.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<void> login(String email, String password, context) async {
    var uri = '${BacktripApi.path}/auth/login';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });
    final response = await http.post(uri, headers: header, body: body).timeout(Duration(seconds: 5));

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
}
