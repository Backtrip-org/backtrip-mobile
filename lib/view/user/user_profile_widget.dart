import 'dart:core';
import 'dart:io';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
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
        children: [header(), SizedBox(height: 40), indicators()],
      ),
    );
  }

  Widget header() {
    return Container(
        height: 220,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 20.0, offset: Offset(0.0, 0.1))
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [avatar(), SizedBox(height: 20), name()],
        ));
  }

  Widget avatar() {
    return Container(
      height: 120,
      width: 120,
      child: FutureBuilder<Widget>(
          future: Components.getParticipantCircularAvatar(widget._user,
              initialsFontSize: 35),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget name() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        widget._user.getFullName(),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
      ),
    );
  }

  Widget indicators() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        indicatorCard(Icons.import_contacts, 12, "voyages"),
        indicatorCard(Icons.flag, 38, "étapes"),
        indicatorCard(Icons.place, 3, "pays visités"),
        indicatorCard(Icons.account_balance, 12, "villes visitées")
      ],
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
                  SizedBox(height: 13),
                  Text(value.toString(),
                      style: Theme.of(context).textTheme.headline),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.subhead,
                  )
                ]))));
  }
}
