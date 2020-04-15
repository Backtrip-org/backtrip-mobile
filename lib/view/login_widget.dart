import 'package:backtrip/service/login_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/LoginException.dart';
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
                }
                return null;
              },
              keyboardType:
                  isPassword ? TextInputType.text : TextInputType.emailAddress,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  labelText: title,
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
            LoginService.login(emailController.text.trim(),
                    passwordController.text.trim(), scaffoldContext)
            .catchError((e) {
              if (e is EmailPasswordInvalidException) {
                Components.snackBar(
                    scaffoldContext, e.cause, Color(0xff8B0000));
              } else if (e is UnexpectedLoginException) {
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
        color: Color(0xff243949),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        child: Text("Connexion",
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  Widget _logo() {
    return Image.asset(
      'assets/images/panda.jpg',
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
                        child: Text('Mot de passe oublié ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
