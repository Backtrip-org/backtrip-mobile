import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step.dart' as step_model;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class StepDetailWidget extends StatefulWidget {
  final step_model.Step _step;

  StepDetailWidget(this._step);

  @override
  _StepDetailWidgetState createState() => _StepDetailWidgetState();
}

class _StepDetailWidgetState extends State<StepDetailWidget> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  Widget presentationCard() {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  /*1*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*2*/
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(children: [
                          stepName(),
                        ]),
                      ),
                    ],
                  ),
                ),
                /*3*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget informationCard() {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  /*1*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*2*/
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(children: [
                          stepDate(),
                          Divider(),
                          participantLabel(),
                          SizedBox(
                            height: 2,
                          ),
                          participantsList(),
                          SizedBox(
                            height: 7,
                          ),
                          photoLabel(),
                        ]),
                      ),
                    ],
                  ),
                ),
                /*3*/
              ],
            ),
          )
        ],
      ),
    );
  }

  Row photoLabel() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: [Text('Photos')]);
  }

  Row participantLabel() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text('Participants')]);
  }

  Widget stepName() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[Text(widget._step.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))]);
  }

  Widget stepDate() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
          child: Row(
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            size: 17,
            color: Theme.of(context).accentColor,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(getStepDate(),
                  style: Theme.of(context).textTheme.subhead)),
        ],
      )),
      SizedBox(
        width: 40,
      ),
      Container(
          child: Row(
        children: <Widget>[
          Icon(
            Icons.access_time,
            size: 17,
            color: Theme.of(context).accentColor,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(getStepTime(),
                  style: Theme.of(context).textTheme.subhead))
        ],
      )),
    ]);
  }

  Widget participantsList() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text('AB',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      SizedBox(
        width: 3,
      ),
      CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text('VG',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      SizedBox(
        width: 3,
      ),
      CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text('CC',
            style: TextStyle(
              color: Colors.white,
            )),
      )
    ]);
  }

  Container documentsButton() {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 15),
            onPressed: () {},
            child: Text("Vos documents",
                style: Theme.of(context).textTheme.button),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._step.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              presentationCard(),
              informationCard(),
              documentsButton()
            ],
          ),
        ));
  }

  String getStepDate() {
    return new DateFormat.yMMMd('fr_FR').format(widget._step.startDatetime);
  }

  String getStepTime() {
    return new DateFormat('HH:mm', 'fr_FR').format(widget._step.startDatetime);
  }
}
