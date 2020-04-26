import 'package:backtrip/service/auth_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/util/exception/UserAlreadyExistsException.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:backtrip/view/trip_list_widget.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  RegisterWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  final List<StepState> _stepStates = [StepState.editing, StepState.indexed];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Voyages"),
        ),
        body: Builder(
          builder: (scaffoldContext) => _stepper(scaffoldContext),
        )
    );
  }

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

  Widget _passwordWidget(String title, TextEditingController controller, FormFieldValidator<String> validator) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: TextInputType.text,
              obscureText: true,
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
                  prefixIcon: Icon(Icons.lock),
                  filled: true)
          )
        ],
      ),
    );
  }

  Widget _accountStep() {
    return Container(
      child: Column(
        children: <Widget>[
          _emailWidget(),
          SizedBox(height: 10),
          _passwordWidget('Mot de passe', _passwordController, isPasswordValid),
          SizedBox(height: 10),
          _passwordWidget('Confirmer le mot de passe', _passwordConfirmationController, isPasswordConfirmationValid),
        ],
      ),
    );
  }

  Widget _firstNameWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _firstNameController,
              validator: _isFirstNameValid,
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
                  fillColor: Theme.of(context).colorScheme.textFieldFillColor,
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person),
                  filled: true)
          )
        ],
      ),
    );
  }

  Widget _lastNameWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _lastNameController,
              validator: _isLastNameValid,
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
                  fillColor: Theme.of(context).colorScheme.textFieldFillColor,
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  filled: true)
          )
        ],
      ),
    );
  }

  Widget _identityStep() {
    return Container(
      child: Column(
        children: <Widget>[
          _firstNameWidget(),
          SizedBox(height: 10),
          _lastNameWidget()
        ],
      ),
    );
  }

  List<Step> get steps => [
    Step(
        title: Text('Compte'),
        state: _stepStates[0],
        content: Form(
          key: _formKeys[0],
          child: _accountStep(),
        ),
        isActive: true
    ),
    Step(
        title: Text('Qui êtes-vous ?'),
        content: Form(
          key: _formKeys[1],
          child: _identityStep(),
        ) ,
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
    );
  }

  void _stepperContinue(BuildContext scaffoldContext) {
    setState(() {
      if (areAllFormKeyValid()) {
        createUser(scaffoldContext);
        return;
      }

      if (_formKeys[_currentStep].currentState.validate()) {
        _stepStates[_currentStep] = StepState.complete;
      } else {
        _stepStates[_currentStep] = StepState.error;
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
      } else {
        _stepStates[_currentStep] = StepState.indexed;
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
      } else {
        _stepStates[_currentStep] = StepState.indexed;
      }

      _currentStep = index;
      _stepStates[_currentStep] = StepState.editing;
    });
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

  String isPasswordValid(String value) {
    if (value.isEmpty) {
      return 'Veuillez renseigner votre mot de passe';
    }

    return null;
  }

  String isPasswordConfirmationValid(String value) {
    String validity = isPasswordValid(value);
    if (validity != null) return validity;

    if (_passwordController.text != value) {
      return "Le mot de passe et la confirmation sont différents.";
    }

    return null;
  }

  String _isFirstNameValid(String value) {
    if (value.isEmpty) {
      return 'Veuillez renseigner votre prénom.';
    }

    if (value.length < 2) {
      return 'Le prénom est trop court.';
    }

    return null;
  }

  String _isLastNameValid(String value) {
    if (value.isEmpty) {
      return 'Veuillez renseigner votre nom.';
    }

    if (value.length < 2) {
      return 'Le nom est trop court.';
    }

    return null;
  }

  bool areAllFormKeyValid() {
    for(GlobalKey<FormState> formKey in _formKeys) {
      if (!formKey.currentState.validate()) {
        return false;
      }
    }
    return true;
  }

  createUser(BuildContext scaffoldContext) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    AuthService.register(email, password, firstName, lastName)
        .then((void val) {
      Navigator.pushAndRemoveUntil(
          scaffoldContext,
          MaterialPageRoute(
              builder: (BuildContext context) => TripList()),
              (Route<dynamic> route) => false);
    }).catchError((e) {
      if (e is UserAlreadyExistsException || e is UnexpectedException) {
        Components.snackBar(scaffoldContext, e.cause, Theme.of(scaffoldContext).errorColor);
      } else {
        Navigator.pop(scaffoldContext);
      }
    });
  }
}