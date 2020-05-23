import 'dart:core';

import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/view/common/participants_list_widget.dart';
import 'package:backtrip/view/trip/step/step_period_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:intl/date_symbol_data_local.dart';

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

  void _joinStep(ctx) {
    TripService.joinStep(widget._step, BacktripApi.currentUser.id)
        .then((value) {
      Components.snackBar(ctx,
          'Vous avez rejoint l\'étape `${widget._step.name}`', Colors.green);
      setState(() {
        widget._step.participants = value;
      });
    }).catchError((e) {
      if (e is UnexpectedException) {
        Components.snackBar(ctx, e.cause, Color(0xff8B0000));
      } else {
        Components.snackBar(
            ctx,
            "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
            Color(0xff8B0000));
      }
    });
  }

  Widget presentationCard() {
    return Card(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (ctx) {
                  return Row(
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
                      Visibility(
                        child: IconButton(
                          padding: EdgeInsets.only(bottom: 3),
                          onPressed: () => _joinStep(ctx),
                          icon: Icon(Icons.person_add),
                        ),
                        visible: !currentUserIsParticipant(),
                      )
                      /*3*/
                    ],
                  );
                },
              ))
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
                          StepPeriodWidget(widget._step),
                          Divider(),
                          participantLabel(),
                          SizedBox(
                            height: 2,
                          ),
                          ParticipantsListWidget(widget._step.participants),
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
    var participantsText;
    if (widget._step.participants.length == 0) {
      participantsText = "Pas de participants";
    } else {
      participantsText = "Participants";
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text(participantsText)]);
  }

  Widget stepName() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(widget._step.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, widget._step),
            )),
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

  bool currentUserIsParticipant() {
    return widget._step.participants
        .map((user) => user.id)
        .toList()
        .contains(BacktripApi.currentUser.id);
  }
}
