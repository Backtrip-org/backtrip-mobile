import 'dart:core';

import 'package:backtrip/model/step.dart' as step_model;
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/create_step_widget.dart';
import 'package:backtrip/view/timeline_step_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TimelineWidget extends StatefulWidget {
  final Trip _trip;

  TimelineWidget(this._trip);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState(_trip);
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final Trip _trip;
  Future<List<step_model.Step>> _futureSteps;

  _TimelineWidgetState(this._trip);

  @override
  void initState() {
    super.initState();
    _futureSteps = TripService.getTimeline(_trip.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateStepWidget(_trip)))
            .then((step) {
              Components.snackBar(
                  context,
                  "L'étape ${step.name} à bien été créée !",
                  Colors.green);
              this.setState(() {
                _futureSteps = TripService.getTimeline(_trip.id);
              });
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
        body: new FutureBuilder<List<step_model.Step>>(
            future: _futureSteps,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Timeline(
                    children: getTimelineModelList(snapshot.data),
                    position: TimelinePosition.Left);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  List<TimelineModel> getTimelineModelList(stepList) {
    return stepList
        .map((step) {
          return TimelineModel(TimelineStepWidget(step),
              position: TimelineItemPosition.random,
              iconBackground: Colors.amberAccent,
              icon: Icon(Icons.assistant_photo));
        })
        .cast<TimelineModel>()
        .toList();
  }
}
