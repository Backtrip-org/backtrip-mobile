import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CreateStepWidget extends StatefulWidget {
  @override
  _CreateStepState createState() => _CreateStepState();
}

class _CreateStepState extends State<CreateStepWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime _dateTime;

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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  prefixIcon: Icon(Icons.directions_bike),
                  labelText: "Nom de l'étape",
                  filled: true)),
        ],
      ),
    );
  }

  Widget _stepDateField() {
    final format = new DateFormat("yyyy-MM-dd HH:mm");
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
              validator: (date) => date == null ? 'Veuillez saisir une date' : null,
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
              onSaved: (DateTime dateTime) => _dateTime = dateTime,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  prefixIcon: Icon(Icons.date_range),
                  labelText: "Date et heure",
                  filled: true)),
        ],
      ),
    );
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
                    /* Builder(
                        builder: (contextBuilder) =>
                            //_submitButton(contextBuilder),
                      ),*/
                  ],
                ),
              ),
            )));
  }
}
