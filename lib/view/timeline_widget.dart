import 'dart:core';

import 'package:backtrip/model/trip.dart';
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

  _TimelineWidgetState(this._trip);

  List<TimelineModel> items = [
    TimelineModel(TimelineStepWidget(),
        position: TimelineItemPosition.random,
        iconBackground: Colors.amberAccent,
        icon: Icon(Icons.fastfood)),
    TimelineModel(TimelineStepWidget(),
        position: TimelineItemPosition.random,
        iconBackground: Colors.redAccent,
        icon: Icon(Icons.videogame_asset)),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(children: items, position: TimelinePosition.Left);
  }

}