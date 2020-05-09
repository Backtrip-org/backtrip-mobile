import 'dart:core';

import 'package:backtrip/model/step.dart' as step_model;
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/create_step_widget.dart';
import 'package:backtrip/view/timeline_step_widget.dart';
import 'package:backtrip/view/trip_settings_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'package:backtrip/view/theme/backtrip_theme.dart';

class TimelineWidget extends StatefulWidget {
  final Trip _trip;

  TimelineWidget(this._trip);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState(_trip);
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final Trip _trip;
  Future<List<step_model.Step>> globalTimelineSteps;
  Future<List<step_model.Step>> personalTimelineSteps;

  _TimelineWidgetState(this._trip);

  @override
  void initState() {
    super.initState();
    getTimelines();
  }

  void getTimelines() {
    globalTimelineSteps = TripService.getGlobalTimeline(_trip.id);
    personalTimelineSteps = TripService.getPersonalTimeline(_trip.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: new BacktripTheme().theme.primaryColor,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(tabs: [
                      Tab(text: "Personnelle"),
                      Tab(text: "Globale"),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [personalTimeline(), globalTimeline()]),
          floatingActionButton: Builder(
            builder: (ctx) {
              return FloatingActionButton(
                onPressed: () {
                  navigateToStepCreation(context);
                },
                child: Icon(Icons.add),
              );
            },
          ),
        ));
  }

  Widget personalTimeline() {
    return FutureBuilder<List<step_model.Step>>(
        future: personalTimelineSteps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Timeline(
                children: getTimelineModelList(snapshot.data),
                position: TimelinePosition.Left);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget globalTimeline() {
    return FutureBuilder<List<step_model.Step>>(
        future: globalTimelineSteps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Timeline(
                children: getTimelineModelList(snapshot.data),
                position: TimelinePosition.Left);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  void navigateToStepCreation(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateStepWidget(_trip)))
        .then((step) {
      if (step != null) {
        Components.snackBar(
            context, "L'étape ${step.name} a bien été créée !", Colors.green);
        getTimelines();
      }
    });
  }

  List<TimelineModel> getTimelineModelList(List<step_model.Step> stepList) {
    return stepList
        .map((step) {
      return TimelineModel(
          TimelineStepWidget(
              isFirstStepOfTheDay(stepList, step),
              step,
              getTimelines
          ),
          position: TimelineItemPosition.random,
          iconBackground: Colors.transparent,
          icon: Icon(Icons.assistant_photo,
              color: Theme.of(context).colorScheme.accentColorDark));
    })
        .cast<TimelineModel>()
        .toList();
  }

  bool isFirstStepOfTheDay(
      List<step_model.Step> stepList, step_model.Step step) {
    var previousStep = stepList.indexOf(step) == 0
        ? null
        : stepList[stepList.indexOf(step) - 1];
    return previousStep == null
        ? true
        : step.startDatetime.difference(previousStep.startDatetime).inDays !=
        0 ||
        step.startDatetime.day != previousStep.startDatetime.day;
  }

  void _redirectToTripSettings() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TripSettings(_trip)));
  }
}
