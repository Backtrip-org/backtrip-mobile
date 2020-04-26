import 'package:backtrip/service/auth_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/LoginException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/view/register_widget.dart';
import 'package:backtrip/view/trip_list_widget.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: isPassword ? passwordController : emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return isPassword
                      ? 'Veuillez renseigner votre mot de passe.'
                      : 'Veuillez renseigner votre email.';
                } else if (!isPassword) {
                  Pattern emailRegexPattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp emailRegex = new RegExp(emailRegexPattern);

                  if (!emailRegex.hasMatch(value.trim())) {
                    return "Le format de l'email n'est pas valide.";
                  }
                }
                return null;
              },
              keyboardType:
                  isPassword ? TextInputType.text : TextInputType.emailAddress,
              obscureText: isPassword,
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
                  labelText: title,
                  prefixIcon:
                      isPassword ? Icon(Icons.lock) : Icon(Icons.person),
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
            AuthService.login(emailController.text.trim(),
                    passwordController.text.trim())
                .then((void val) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TripList()),
                  (Route<dynamic> route) => false);
            }).catchError((e) {
              if (e is EmailPasswordInvalidException ||
                  e is UnexpectedException) {
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
        child: Text("Connexion",
            style: Theme.of(context).textTheme.button),
      ),
    );
  }

  Widget _logo() {
    return Image.asset(
      'assets/images/backtrip-logo.png',
      height: 300,
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email"),
        _entryField("Mot de passe", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _logo(),
                      SizedBox(
                        height: 20,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      Builder(
                        builder: (contextBuilder) =>
                            _submitButton(contextBuilder),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: Theme.of(context).accentColor,
                            fontSize: 14, fontWeight: FontWeight.w500)
                        )
                      ),
                      new InkWell(
                        onTap: () => redirectToRegister(),
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Créer un compte',
                                style: TextStyle(color: Theme.of(context).accentColor,
                                    fontSize: 14, fontWeight: FontWeight.w500)
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void redirectToRegister() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterWidget())
    );
  }
}
