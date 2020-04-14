import 'dart:convert';
import 'dart:io';

import 'package:backtrip/home_widget.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginService {

  static void login(email, password, context) async {
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      if(response.statusCode == HttpStatus.badRequest) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
          Text("Votre email ou mot de passe est inccorect."),
          backgroundColor: Color(0xff8B0000),
        ));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content:
          Text("Une erreur inattendue est survenue, veuillez contacter l'assistance."),
          backgroundColor: Color(0xff8B0000),
        ));
      }
    }
  }
}