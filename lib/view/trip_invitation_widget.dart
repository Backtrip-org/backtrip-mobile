import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/exception/UserNotFoundException.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class TripInvitation extends StatefulWidget {
  final Trip _trip;

  TripInvitation(this._trip);

  @override
  State<StatefulWidget> createState() {
    return _TripInvitationState(_trip);
  }
}

class _TripInvitationState extends State<TripInvitation> {
  final Trip _trip;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _TripInvitationState(this._trip);

  Widget _emailWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _emailController,
              validator: isEmailValid,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Theme.of(context).accentColor),
                  ),
                  fillColor: Theme.of(context).colorScheme.textFieldFillColor,
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person),
                  filled: true)
          )
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        onPressed: () => _inviteUser(ctx),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text("Inviter",
            style: Theme.of(context).textTheme.button),
      ),
    );
  }

  Widget _image() {
    return Image.asset(
        "assets/images/camping.png",
        fit: BoxFit.cover
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation à un voyage'),
      ),
      body: Builder(
        builder: (ctx) {
          return Form(
            key: _formKey,
            child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _image(),
                        SizedBox(height: 50),
                        _emailWidget(),
                        SizedBox(height: 20),
                        _submitButton(ctx)
                      ],
                    ),
                  ),
                )
            ),
          );
        },
      )
    );
  }

  String isEmailValid(String value) {
    if(value.isEmpty) {
      return 'Veuillez renseigner votre email';
    }

    Pattern emailRegexPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp emailRegex = new RegExp(emailRegexPattern);
    if (!emailRegex.hasMatch(value.trim())) {
      return "Le format de l'email n'est pas valide.";
    }

    return null;
  }

  void _inviteUser(BuildContext ctx) {
    if (_formKey.currentState.validate()) {
      TripService.inviteToTrip(_trip.id, _emailController.text.trim())
          .then((value) {
            Navigator.pop(context, true);
      }).catchError((e) {
        if (e is UserNotFoundException || e is UnexpectedException) {
          Components.snackBar(ctx, e.cause, Color(0xff8B0000));
        } else {
          Components.snackBar(
              ctx,
              "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
              Color(0xff8B0000));
        }
      });
    }
//    if (_formKey.currentState.validate()) {
//      AuthService.login(emailController.text.trim(),
//          passwordController.text.trim())
//          .then((void val) {
//        Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(
//                builder: (BuildContext context) => TripList()),
//                (Route<dynamic> route) => false);
//      }).catchError((e) {
//        if (e is EmailPasswordInvalidException ||
//            e is UnexpectedException) {
//          Components.snackBar(
//              scaffoldContext, e.cause, Theme.of(context).errorColor);
//        } else {
//          Components.snackBar(
//              scaffoldContext,
//              "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
//              Theme.of(context).errorColor);
//        }
//      });
//    }
  }
}