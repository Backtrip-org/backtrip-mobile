import 'dart:core';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/StepException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class CreateStepWidget extends StatefulWidget {
  final Trip _trip;

  CreateStepWidget(this._trip);

  @override
  _CreateStepState createState() => _CreateStepState(_trip);
}

class _CreateStepState extends State<CreateStepWidget> {
  final Trip _trip;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  DateTime _dateTime;

  _CreateStepState(this._trip);

  Widget _stepNameField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuillez renseigner un nom.';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.textFieldFillColor,
                  prefixIcon: Icon(Icons.directions_bike),
                  labelText: "Nom de l'étape",
                  filled: true)),
        ],
      ),
    );
  }

  Widget _stepDateField() {
    final format = new DateFormat("yyyy-MM-dd HH:mm:ss");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          DateTimeField(
              format: format,
              autovalidate: false,
              validator: (date) =>
                  date == null ? 'Veuillez saisir une date' : null,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().month),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 30));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              onChanged: (date) => setState(() {
                    _dateTime = date;
                  }),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  border: InputBorder.none,
                  fillColor: Theme.of(context).colorScheme.textFieldFillColor,
                  prefixIcon: Icon(Icons.date_range),
                  labelText: "Date et heure",
                  filled: true)),
        ],
      ),
    );
  }

  Widget _submitButton(scaffoldContext) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                TripService.createStep(nameController.text.trim(),
                        _dateTime.toString(), _trip.id)
                    .then((step) {
                  Navigator.pop(context, step);
                }).catchError((e) {
                  if (e is BadStepException || e is UnexpectedException) {
                    Components.snackBar(
                        scaffoldContext, e.cause, Theme.of(context).errorColor);
                  } else {
                    Components.snackBar(
                        scaffoldContext,
                        "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
                        Theme.of(context).errorColor);
                  }
                });
              }
            },
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Valider",
                style:  Theme.of(context).textTheme.button),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Créez votre nouvelle étape"),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _stepNameField(),
                    _stepDateField(),
                    Builder(
                      builder: (contextBuilder) =>
                          _submitButton(contextBuilder),
                    ),
                  ],
                ),
              ),
            )));
  }
}
