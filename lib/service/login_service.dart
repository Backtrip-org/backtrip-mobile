import 'dart:convert';
import 'dart:io';

import 'package:backtrip/home_widget.dart';
import 'package:backtrip/model/login.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/current_user.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static void login(String email, String password, context) async {
    if (email.isEmpty || password.isEmpty) {
      Components.snackBar(
          context,
          "Veuillez saisir tous les champs avant de valider.",
          Color(0xff8B0000));
    } else {
      var uri = '${BacktripApi.path}/auth/login';
      var header = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var body = jsonEncode(<String, String>{
        'email': email,
        'password': password,
      });
      final response = await http.post(uri, headers: header, body: body);

      if (response.statusCode == HttpStatus.ok) {
        Login login = Login.fromJson(json.decode(response.body));
        StoredToken.storeToken(login.authorization);
        BacktripApi.currentUser = new CurrentUser(login.id);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
      } else {
        if (response.statusCode == HttpStatus.badRequest) {
          Components.snackBar(context,
              "Votre email ou mot de passe est inccorect.", Color(0xff8B0000));
        } else {
          Components.snackBar(
              context,
              "Une erreur inattendue est survenue, veuillez contacter l'assistance.",
              Color(0xff8B0000));
        }
      }
    }
  }
}
