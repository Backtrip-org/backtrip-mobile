import 'dart:convert';
import 'dart:io';

import 'package:backtrip/util/backtrip_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginService {

  static void login(email, password) async {
    var uri = '${BacktripApi.path}/auth/login';
    var header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = jsonEncode(<String, String> {
      'email': email,
      'password': password,
    });
    final response = await http.post(uri, headers: header, body: body);

    if (response.statusCode == HttpStatus.ok) {
      debugPrint(response.body);
    } else {
      debugPrint(response.body);
      throw Exception('Failed to login');
    }
  }
}