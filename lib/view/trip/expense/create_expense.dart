import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/ExpenseException.dart';
import 'package:backtrip/util/exception/OweException.dart';
import 'package:backtrip/util/percentage.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class CreateExpense extends StatefulWidget {
  final Trip _trip;

  CreateExpense(this._trip);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseAmountController =
      TextEditingController();
  List<TextEditingController> _participantsAmountController = [];
  List<TextEditingController> _participantsPercentController = [];
  List<Column> payers = new List<Column>();
  List<User> participants = [];
  List<User> selectedPayers = [];
  User mainPayer;

  @override
  void initState() {
    super.initState();
    participants = widget._trip.participants;
    mainPayer = participants[0];
  }

  Widget dropDownListMainPayer() {
    return Container(child: FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: inputDecoration("Payeur principal", Icon(Icons.person)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: mainPayer.firstName,
              isDense: true,
              onChanged: (String payer) {
                setState(() {
                  mainPayer = findUserWithUsername(payer);
                  state.didChange(payer);
                });
              },
              items: participants.map((value) {
                return DropdownMenuItem<String>(
                  value: value.firstName,
                  child: Text(value.firstName),
                );
              }).toList(),
            ),
          ),
        );
      },
    ));
  }

  Widget _expenseAmountField() {
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
              onChanged: (String value) {
                setState(() {
                  for (int i = 0;
                      i < _participantsAmountController.length;
                      i++) {
                    _participantsPercentController[i]
                        .text = Percentage.calculatePercentageFromTwoValues(
                            double.parse(
                                _participantsAmountController[i].text.trim()),
                            double.parse(_expenseAmountController.text.trim()))
                        .toString();

                    _participantsAmountController[i]
                        .text = Percentage.calculateValueFromPercentageAndValue(
                            double.parse(_expenseAmountController.text.trim()),
                            double.parse(
                                _participantsPercentController[i].text.trim()))
                        .toString();
                  }
                });
              },
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
                  labelText: "Montant de la dépense",
                  filled: true)),
        ],
      ),
    );
  }

  Row expenseParticipantsLabelAndButton() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text("Participants à la dépense"), addButton()]);
  }

  Widget addButton() {
    return IconButton(
      icon: Icon(Icons.person_add, color: Theme.of(context).primaryColor),
      onPressed: () {
        setState(() {
          _participantsAmountController.add(TextEditingController());
          _participantsPercentController.add(TextEditingController());
          payers.add(Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: dropDownListParticipants(),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _participantAmountField(),
                  ),
                  Expanded(
                    child: _participantPercentageField(),
                  ),
                ],
              )
            ],
          ));
        });
      },
    );
  }

  Widget payerList() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: payers.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return payers[index];
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }

  Widget dropDownListParticipants() {
    selectedPayers.add(participants[0]);
    int counter = selectedPayers.length - 1;
    return Container(child: FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: inputDecoration("Payeur", Icon(Icons.person)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedPayers[counter].firstName,
              isDense: true,
              onChanged: (String payer) {
                selectedPayers[counter] = findUserWithUsername(payer);
                setState(() {
                  state.didChange(payer);
                });
              },
              items: participants.map((value) {
                return DropdownMenuItem<String>(
                  value: value.firstName,
                  child: Text(value.firstName),
                );
              }).toList(),
            ),
          ),
        );
      },
    ));
  }

  Widget _participantAmountField() {
    int counter = _participantsAmountController.length - 1;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _participantsAmountController[counter],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuillez renseigner un montant';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  if (_expenseAmountController.text.trim() != '') {
                    _participantsPercentController[counter]
                        .text = Percentage.calculatePercentageFromTwoValues(
                            double.parse(_participantsAmountController[counter]
                                .text
                                .trim()),
                            double.parse(_expenseAmountController.text.trim()))
                        .toString();
                  } else {
                    _participantsPercentController[counter].text = '0';
                  }
                });
              },
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
                  labelText: "Montant de la dépense",
                  filled: true)),
        ],
      ),
    );
  }

  Widget _participantPercentageField() {
    int counter = _participantsPercentController.length - 1;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              controller: _participantsPercentController[counter],
              validator: (value) {
                if (value.isEmpty) {
                  return 'Veuillez renseigner un pourcentage';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  if (_expenseAmountController.text.trim() != '') {
                    _participantsAmountController[counter]
                        .text = Percentage.calculateValueFromPercentageAndValue(
                            double.parse(_expenseAmountController.text.trim()),
                            double.parse(_participantsPercentController[counter]
                                .text
                                .trim()))
                        .toString();
                  } else {
                    _participantsAmountController[counter].text = '0';
                  }
                });
              },
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
                  suffixIcon: Icon(Icons.local_pizza),
                  labelText: "Pourcentage de la dépense",
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

  void validateExpense(context) {
    int payerCounter = _participantsAmountController.length;
    double totalAmount = 0;
    if (_formKey.currentState.validate()) {
      for (int i = 0; i < payerCounter; i++) {
        totalAmount += double.parse(_participantsAmountController[i].text.trim());
        if (userHasMoreThanOneExpectedRefund(selectedPayers[i].firstName)) {
          Components.snackBar(context, '${selectedPayers[i].firstName} apparaît plusieurs fois dans la liste des remboursements', Color(0xff8B0000));
          return;
        }
      }

      if (totalAmount.compareTo(double.parse(_expenseAmountController.text.trim())) == 1) {
        Components.snackBar(context, "Le montant du remboursement est trop élevé", Color(0xff8B0000));
        return;
      }

      TripService.createExpense(double.parse(_expenseAmountController.text.trim()), mainPayer, widget._trip).then((expense) => {
        Future.wait([createOwes(payerCounter, expense.id)]).then((response) {
          Navigator.pop(context);
        })

      }).catchError((e) {
        if (e is ExpenseException) {
          Components.snackBar(context, e.cause, Color(0xff8B0000));
        } else {
          Components.snackBar(
              context, "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.", Color(0xff8B0000));
        }
      });
    }
  }

  Future<void> createOwes(int payerCounter, expenseId) async {
    for (int i = 0; i < payerCounter; i++) {
      await TripService.createOwe(double.parse(_participantsAmountController[i].text.trim()), selectedPayers[i].id, expenseId, widget._trip)
      .catchError((e) {
        if(e is OweException) {
          Components.snackBar(context, e.cause, Color(0xff8B0000));
        } else {
          Components.snackBar(
              context, "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.", Color(0xff8B0000));
        }
      });
    }
  }

  bool userHasMoreThanOneExpectedRefund(String userName) {
    int occurrences = 0;

    selectedPayers.forEach((User selectedPlayer) =>
        {if (selectedPlayer.firstName == userName) occurrences++});

    if (mainPayer.firstName == userName) occurrences++;

    return occurrences != 1;
  }

  User findUserWithUsername(String username) {
    return participants
        .where((user) => user.firstName == username)
        .toList()
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une dépense"),
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
                  expenseParticipantsLabelAndButton(),
                  Divider(),
                  payerList(),
                ],
              ),
            ),
          )),
      floatingActionButton: Builder(
        builder: (ctx) {
          return FloatingActionButton(
              onPressed: () {
                validateExpense(ctx);
              },
              child: Icon(Icons.check));
        },
      ),
    );
  }
}
