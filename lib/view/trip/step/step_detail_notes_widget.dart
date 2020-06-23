import 'dart:core';

import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/trip/step/step_detail_subtitle_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;

class StepDetailNotesWidget extends StatefulWidget {
  final step_model.Step _step;
  final BuildContext scaffoldContext;

  StepDetailNotesWidget(this._step, this.scaffoldContext);

  @override
  _StepDetailNotesWidgetState createState() => _StepDetailNotesWidgetState();
}

class _StepDetailNotesWidgetState extends State<StepDetailNotesWidget> {
  TextEditingController notesEditingController = TextEditingController();
  bool isEditing;

  @override
  void initState() {
    super.initState();

    updateIsEditing(false);
  }

  void updateIsEditing(bool edit) {
    setState(() {
      isEditing = edit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: isEditing ? editingView() : readView(),
            )));
  }

  List<Widget> editingView() {
    return [
      StepDetailSubtitleWidget(
        Icons.short_text,
        "Notes",
        firstActionIcon: Icons.mode_edit,
        firstAction: saveNotes,
        firstActionLabel: "Enregistrer",
        secondActionIcon: Icons.close,
        secondAction: read,
      ),
      TextField(
        controller: notesEditingController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).accentColor),
            ),
            hintText: "Ecrivez ici vos notes"),
        keyboardType: TextInputType.multiline,
        maxLength: 200,
        maxLines: null,
      )
    ];
  }

  List<Widget> readView() {
    return [
      StepDetailSubtitleWidget(
        Icons.short_text,
        "Notes",
        firstActionIcon: Icons.mode_edit,
        firstAction: edit,
        firstActionLabel: "Modifier",
      ),
      Text(widget._step.notes ?? "Aucune note pour le moment !")
    ];
  }

  read() {
    updateIsEditing(false);
    notesEditingController.text = widget._step.notes ?? '';
  }

  edit() {
    updateIsEditing(true);
    notesEditingController.text = widget._step.notes ?? '';
  }

  saveNotes() {
    var notes = notesEditingController.text;
    TripService.updateNotes(widget._step.tripId, widget._step.id, notes)
        .then((value) {
      Components.snackBar(widget.scaffoldContext,
          'Les notes ont bien été mises à jour !', Colors.green);
      widget._step.notes = notes;
      read();
    }).catchError((error) {
      Components.snackBar(widget.scaffoldContext, 'Une erreur est survenue',
          Theme.of(context).errorColor);
    });
  }
}
