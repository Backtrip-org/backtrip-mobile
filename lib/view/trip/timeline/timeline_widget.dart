import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/file_service.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/notification.dart';
import 'package:backtrip/view/trip/step/create_step_widget.dart';
import 'package:backtrip/view/trip/step/suggest_step_widget.dart';
import 'package:backtrip/view/trip/timeline/timeline_step_widget.dart';
import 'package:backtrip/view/common/empty_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:unicorndial/unicorndial.dart';

class TimelineWidget extends StatefulWidget {
  final Trip _trip;

  TimelineWidget(this._trip);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  Future<List<step_model.Step>> globalTimelineSteps;
  Future<List<step_model.Step>> personalTimelineSteps;

  _TimelineWidgetState();

  @override
  void initState() {
    super.initState();
    getTimelines();
  }

  void getTimelines() {
    setState(() {
      globalTimelineSteps = TripService.getGlobalTimeline(widget._trip.id);
      personalTimelineSteps = TripService.getPersonalTimeline(widget._trip.id);
    });
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
              return getFloatingActionButton();
            },
          ),
        ));
  }

  Widget _profileOption(
      {IconData iconData, Function onPressed, String tooltip}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.grey[500],
      heroTag: null,
      mini: true,
      child: Icon(iconData),
      onPressed: onPressed,
      tooltip: tooltip,
    ));
  }

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    children.add(_profileOption(
        iconData: Icons.lightbulb_outline,
        onPressed: () {
          navigateToStepSuggestion(context);
        },
        tooltip: "Suggestion d'activité"));
    children.add(_profileOption(
        iconData: Icons.add,
        onPressed: () {
          navigateToStepCreation(context);
        },
        tooltip: "Nouvelle étape"));

    return children;
  }

  Widget getFloatingActionButton() {
    if (widget._trip.closed) {
      if (Platform.isAndroid) {
        return FloatingActionButton(
          onPressed: () {
            _showDownloadTravelJournalConfirmationDialog(context);
          },
          child: Icon(Icons.import_contacts),
        );
      } else {
        return Container();
      }
    } else {
      return UnicornDialer(
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: _getProfileMenu(),
      );
    }
  }

  Widget personalTimeline() {
    return FutureBuilder<List<step_model.Step>>(
        future: personalTimelineSteps,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            setNotifications(snapshot.data);
            if (snapshot.data.length > 0) {
              return Timeline(
                  children: getTimelineModelList(snapshot.data),
                  position: TimelinePosition.Left);
            } else {
              return EmptyListWidget(
                  "Vous ne participez à aucune étape", "Rejoignez-en une !");
            }
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
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length > 0) {
              return Timeline(
                  children: getTimelineModelList(snapshot.data),
                  position: TimelinePosition.Left);
            } else {
              return EmptyListWidget(
                  "Aucune étape n'a été créée", "Créez-en une !");
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  List<TimelineModel> getTimelineModelList(List<step_model.Step> stepList) {
    return stepList
        .map((step) {
          return TimelineModel(
              TimelineStepWidget(
                  isFirstStepOfTheDay(stepList, step), step, getTimelines),
              position: TimelineItemPosition.random,
              iconBackground: Colors.transparent,
              icon: Icon(step.icon,
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

  void setNotifications(List<step_model.Step> steps) {
    for (int i = 0; i < steps.length; i++) {
      setRemindNotification(steps[i]);
    }
  }

  void setRemindNotification(step_model.Step step) {
    if (step.startDatetime.isAfter(DateTime.now().add(Duration(hours: 1)))) {
      DateTime duration = step.startDatetime.subtract(Duration(hours: 1));
      NotificationManager.scheduleNotification(
          step.name, "Votre étape démarre dans 1h !", step.id, duration);
    }
  }

  void handleReturnFromStepCreation(BuildContext context, dynamic step) {
    if (step != null) {
      Components.snackBar(
          context, "L'étape ${step.name} a bien été créée !", Colors.green);
      getTimelines();
    }
  }

  void navigateToStepCreation(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateStepWidget(widget._trip))).then((step) {
      handleReturnFromStepCreation(context, step);
    });
  }

  void navigateToStepSuggestion(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuggestStepWidget(widget._trip))).then((step) {
      handleReturnFromStepCreation(context, step);
    });
  }

  Future<void> _showDownloadTravelJournalConfirmationDialog(
      BuildContext parentContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.add_a_photo),
            SizedBox(width: 10),
            Text('Confirmation')
          ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                        'Voulez-vous télécharger votre carnet de voyage au format PDF ?')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('NON'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OUI'),
              onPressed: () {
                FileService.download(
                        '${BacktripApi.path}/trip/${widget._trip.id}/travelJournal',
                        'journal_voyage_${widget._trip.id}',
                        'pdf')
                    .then((value) {
                  Components.snackBar(
                      parentContext,
                      'Le téléchargement du carnet de voyage a démarré !',
                      Colors.green);
                }).catchError((error) {
                  Components.snackBar(parentContext, 'Une erreur est survenue',
                      Theme.of(context).errorColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
