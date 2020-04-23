import 'dart:core';

import 'package:backtrip/model/step.dart' as step_model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TimelineStepWidget extends StatefulWidget {
  final bool _displayDay;
  final step_model.Step _step;

  TimelineStepWidget(this._displayDay, this._step);

  @override
  _TimelineStepWidgetState createState() => _TimelineStepWidgetState();
}

class _TimelineStepWidgetState extends State<TimelineStepWidget> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  Widget day() {
    return Visibility(
        visible: widget._displayDay,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Divider(color: Colors.grey))),
              Text(
                new DateFormat('EEEE d MMMM', 'fr_FR')
                    .format(widget._step.startDatetime),
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.normal),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Divider(color: Colors.grey))),
            ])));
  }

  Widget hour() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              new DateFormat('HH:mm', 'fr_FR')
                  .format(widget._step.startDatetime),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            )));
  }

  Widget card() {
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
                        child: Column(children: [stepName(), address()]),
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

  Widget stepName() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget._step.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )));
  }

  Widget address() {
    return Row(children: [
      Icon(
        Icons.place,
        size: 17,
        color: Colors.black87,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text("4 rue du marché, Paris", // TODO: bind real address
              style: TextStyle(fontSize: 16, color: Colors.black87)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: new InkWell(
          onTap: () => navigateToStepDetail(),
          child: Column(children: [day(), hour(), card()]),
        ));
  }

  void navigateToStepDetail() {
//    Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => StepDetailWidget())
//    );
  }
}
