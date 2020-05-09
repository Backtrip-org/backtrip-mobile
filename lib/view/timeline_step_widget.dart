import 'dart:core';

import 'package:backtrip/model/step.dart' as step_model;
import 'package:backtrip/model/user.dart';
import 'package:backtrip/view/participants_list_widget.dart';
import 'package:backtrip/view/step_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TimelineStepWidget extends StatefulWidget {
  final bool _displayDay;
  final step_model.Step _step;
  final VoidCallback onStepRefresh;

  TimelineStepWidget(this._displayDay, this._step, [this.onStepRefresh]);

  @override
  _TimelineStepWidgetState createState() => _TimelineStepWidgetState();
}

class _TimelineStepWidgetState extends State<TimelineStepWidget> {
  final List<User> _participants = <User>[];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _participants.addAll(widget._step.participants);
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
                new DateFormat('EEEE d MMMM y', 'fr_FR')
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
              style: Theme.of(context).textTheme.subhead,
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
                        child: Column(
                            children: [
                              stepName(),
                              address(),
                              SizedBox(height: 5),
                              participants()
                            ]
                        ),
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
              style: Theme.of(context).textTheme.title,
            )));
  }

  Widget address() {
    return Row(children: [
      Icon(
        Icons.place,
        size: 17,
        color: Theme.of(context).accentColor,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("4 rue du marché, Paris", // TODO: bind real address
              style: Theme.of(context).textTheme.subhead
          ))
    ]);
  }

  Widget participants() {
    return ParticipantsListWidget(_participants, 15);
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
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StepDetailWidget(widget._step))
    ).then((step) {
      setState(() {
        /* Update participants in widget._step but we don't need it now */
//        for (var participant in step.participants) {
//          if (!widget._step.participants.contains(participant)) {
//            widget._step.participants.add(participant);
//          }
//        }
        _participants.clear();
        _participants.addAll(step.participants);
        if (widget.onStepRefresh != null) {
          widget.onStepRefresh();
        }
      });
    })
    ;
  }
}
