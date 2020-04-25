import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/TripAlreadyExistsException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:flutter/material.dart';

class CreateTrip extends StatefulWidget {
  CreateTrip();

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _CreateTripState();

  Widget _tripNameField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _nameController,
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
                  fillColor: Color(0xfff3f3f4),
                  prefixIcon: Icon(Icons.card_travel),
                  labelText: "Nom du voyage",
                  filled: true)),
        ],
      ),
    );
  }

  Widget _submitButton(scaffoldContext) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            TripService.createTrip(_nameController.text.trim()).then((trip) {
              Navigator.pop(context, trip);
            }).catchError((e) {
              if (e is TripAlreadyExistsException || e is UnexpectedException) {
                Components.snackBar(
                    scaffoldContext, e.cause, Color(0xff8B0000));
              } else {
                Components.snackBar(
                    scaffoldContext,
                    "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
                    Color(0xff8B0000));
              }
            });
          }
        },
        padding: EdgeInsets.symmetric(vertical: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Text("Valider",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Créez un nouveau voyage"),
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
                    SizedBox(height: 10),
                    _tripNameField(),
                    SizedBox(height: 10),
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
