import 'dart:core';
import 'dart:io';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/StepException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:path/path.dart' as path;

class CreateStepWidget extends StatefulWidget {
  final Trip _trip;

  CreateStepWidget(this._trip);

  @override
  _CreateStepState createState() => _CreateStepState(_trip);
}

class _CreateStepState extends State<CreateStepWidget> {
  final Trip _trip;
  final _formKey = GlobalKey<FormState>();
  final List<StepState> _stepStates = [StepState.editing, StepState.indexed];
  final List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  final List<bool> _stepsCompleted = [false, true];
  List<File> selectedFiles = new List<File>();
  List<Widget> documentsWidgets = new List<Widget>();
  TextEditingController nameController = TextEditingController();
  DateTime _dateTime;
  int _currentStep = 0;

  _CreateStepState(this._trip);

  List<Step> get steps => [
    Step(
      title: Text('Informations sur votre étape'),
      state: _stepStates[0],
      content: Container(
        child: Form(
          key: _formKeys[0],
          child: _informationStep(),
        ),
        padding: EdgeInsets.all(3),
      ),
      isActive: true,
    ),
    Step(
        title: Text('Voulez-vous ajouter un document ?'),
        content: Container(
          padding: EdgeInsets.all(3),
          child: Form(
            key: _formKeys[1],
            child: _documentationStep(),
          ),
        ),
        state: _stepStates[1],
        isActive: true
    )
  ];

  Widget _stepper(BuildContext scaffoldContext) {
    return Stepper(
        currentStep: _currentStep,
        steps: steps,
        onStepContinue: () => _stepperContinue(scaffoldContext),
        onStepCancel: _stepperCancel,
        onStepTapped: _stepperTapped,
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: onStepContinue,
                  child: Text("CONTINUER",
                      style: Theme.of(context).textTheme.button
                  ),
                ),
                FlatButton(
                  onPressed: onStepCancel,
                  child: const Text('ANNULER'),
                ),
              ],
            ),
          );
        }
    );
  }

  void _stepperContinue(BuildContext scaffoldContext) {
    setState(() {
      if (areAllFormKeyValid()) {
        createStep(scaffoldContext);
        return;
      }

      if (_formKeys[_currentStep].currentState.validate()) {
        _stepStates[_currentStep] = StepState.complete;
        _stepsCompleted[_currentStep] = true;
      } else {
        _stepStates[_currentStep] = StepState.error;
        _stepsCompleted[_currentStep] = false;
        return;
      }
      if(_currentStep < steps.length - 1) {
        _currentStep += 1;
        _stepStates[_currentStep] = StepState.editing;
      }
    });
  }

  void _stepperCancel() {
    setState(() {
      if (_formKeys[_currentStep].currentState.validate()) {
        _stepStates[_currentStep] = StepState.complete;
        _stepsCompleted[_currentStep] = true;
      } else {
        _stepStates[_currentStep] = StepState.indexed;
        _stepsCompleted[_currentStep] = false;
      }

      if(_currentStep > 0) {
        _currentStep -= 1;
        _stepStates[_currentStep] = StepState.editing;
      }
    });
  }

  void _stepperTapped(index) {
    setState(() {
      if (_formKeys[_currentStep].currentState.validate()) {
        _stepStates[_currentStep] = StepState.complete;
        _stepsCompleted[_currentStep] = true;
      } else {
        _stepStates[_currentStep] = StepState.indexed;
        _stepsCompleted[_currentStep] = false;
      }

      _currentStep = index;
      _stepStates[_currentStep] = StepState.editing;
    });
  }

  bool areAllFormKeyValid() {
    for(bool stepCompleted in _stepsCompleted) {
      if (!stepCompleted) {
        return false;
      }
    }
    return true;
  }

  Widget _informationStep() {
    return Container(
      child: Column(
        children: <Widget>[
          _stepNameField(),
          SizedBox(height: 10),
          _stepDateField(),
        ],
      ),
    );
  }

  Widget _documentationStep() {
    return Container(
      height: 150,
      child: Column(
        children: <Widget>[
          _documentList(),
          _addDocumentsButton(),
        ],
      ),
    );
  }

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
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
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
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).accentColor),
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

  Widget _addDocumentsButton() {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            onPressed: () {
              getFilesFromPhone().then( (value) {
                  setState(() {
                    documentsWidgets.clear();
                    for(File file in selectedFiles) {
                      print(path.basename(file.path));
                      String filename = path.basename(file.path);
                      documentsWidgets.add(
                          new Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(filename),
                            ),
                          )
                      );
                    }
                  });
                }
              );
            },
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("Ajouter des documents",
                style: Theme
                    .of(context)
                    .textTheme
                    .button),
          ),
        ));
  }

  Widget _documentList() {
    return Expanded(
      child: documentsWidgets.length > 0 ? ListView.builder(
          itemCount: documentsWidgets.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              child: documentsWidgets[index],
              background: Container(),
              secondaryBackground: Container(
                child: Center(
                  child: Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                color: Colors.red,
              ),
              onDismissed: (direction) {
                setState(() {
                  documentsWidgets.removeAt(index);
                  selectedFiles.removeAt(index);
                });
              },
            );// return your widget
          }) : Center(child: noDocumentsCard()),
    );
  }

  Widget noDocumentsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Aucun document n'a été ajouté."),
      ),
    );
  }

  Future<void> getFilesFromPhone() async {
    List<File> pickedFiles = await FilePicker.getMultiFile();
    selectedFiles.addAll(pickedFiles);
  }

  void createStep(BuildContext scaffoldContext) {
      TripService.createStep(nameController.text.trim(),
          _dateTime.toString(), _trip.id)
          .then((step) {
            Future.wait(selectedFiles.map((File selectedFile) async {
              await TripService.addDocumentToStep(_trip.id, step.id, selectedFile);
            })).then((response) {
              Navigator.pop(context, step);
            });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Créez votre nouvelle étape"),
        ),
        body: Builder(
          builder: (scaffoldContext) => _stepper(scaffoldContext),
        ));
  }
}
