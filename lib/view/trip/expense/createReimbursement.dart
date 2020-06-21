import 'package:backtrip/model/operation.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/ReimbursementException.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class CreateReimbursement extends StatefulWidget {
  final Trip _trip;
  final Operation operation;
  final User user;

  CreateReimbursement(this._trip, this.operation, this.user);

  @override
  _CreateReimbursementState createState() => _CreateReimbursementState();
}

class _CreateReimbursementState extends State<CreateReimbursement> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseAmountController =
  TextEditingController();
  List<Column> payers = new List<Column>();

  Widget dropDownListMainPayer() {

    return Container(
      child: Text(
        "à rembourser: " + widget.user.firstName,
        style: TextStyle(
            fontSize: 20
        ),
      ),
    );
  }

  Widget _expenseAmountField() {
    _expenseAmountController.text = widget.operation.amount.toString();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _expenseAmountController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuillez renseigner un montant';
                }
                return null;
              },
              keyboardType: TextInputType.number,
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
                  suffixIcon: Icon(Icons.euro_symbol),
                  labelText: "Montant du remboursement",
                  filled: true)),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(String label, Icon icon) {
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.textFieldFillColor,
        labelText: label,
        prefixIcon: icon,
        filled: true);
  }

  void validateReimbursement(context) {
    if (_formKey.currentState.validate()) {
      TripService.createReimbursement(double.parse(_expenseAmountController.text.trim().toString()), widget.operation.payeeId, widget._trip, widget.operation.emitterId)
      .then((response) {
        Navigator.pop(context);
      })
      .catchError((e) {
        if(e is ReimbursementException) {
          Components.snackBar(context, e.cause, Color(0xff8B0000));
        } else {
          Components.snackBar(
              context, "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.", Color(0xff8B0000));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remboursement de " + widget.user.firstName),
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
                  dropDownListMainPayer(),
                  SizedBox(height: 10),
                  _expenseAmountField(),
                  SizedBox(height: 30),
                ],
              ),
            ),
          )),
      floatingActionButton: Builder(
        builder: (ctx) {
          return FloatingActionButton(
              onPressed: () {
                validateReimbursement(ctx);
              },
              child: Icon(Icons.check));
        },
      ),
    );
  }
}