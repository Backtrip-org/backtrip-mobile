import 'dart:core';
import 'dart:io';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatefulWidget {
  User _user;

  UserProfileWidget(this._user);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  _UserProfileWidgetState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de profil'),
      ),
      body: Column(
        children: [
          Container(
              height: 220,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0,
                    offset: Offset(0.0, 0.1))
              ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    width: 100,
                    child: getParticipantWithoutPhoto(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text(
                      widget._user.getFullName(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                    ),
                  )
                ],
              )),
          SizedBox(height: 40),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              indicatorCard(Icons.import_contacts, 12, "voyages"),
              indicatorCard(Icons.flag, 38, "étapes"),
              indicatorCard(Icons.place, 3, "pays visités"),
              indicatorCard(Icons.account_balance, 12, "villes visitées")
            ],
          )
        ],
      ),
    );
  }

  Widget indicatorCard(IconData icon, int value, String description) {
    return SizedBox(
        width: 150,
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Icon(icon, color: Theme.of(context).primaryColor),
                  SizedBox(height: 10),
                  Text(value.toString(),
                      style: Theme.of(context).textTheme.headline),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.subhead,
                  )
                ]))));
  }

  CircleAvatar getParticipantWithoutPhoto() {
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.grey,
      child: Text(widget._user.getInitials(),
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
          )),
    );
  }
}
