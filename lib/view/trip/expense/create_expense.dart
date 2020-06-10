import 'package:backtrip/model/trip.dart';
import 'package:flutter/material.dart';

class CreateExpense extends StatefulWidget {
  final Trip _trip;

  CreateExpense(this._trip);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final TextEditingController _expenseAmountController = TextEditingController();

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
        children: [
          Text("Participants à la dépense"),
          sendButton()
        ]);
  }

  Widget sendButton() {
    return IconButton(
      icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une dépense"),
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                _expenseAmountField(),
                SizedBox(height: 30),
                expenseParticipantsLabelAndButton(),
                Divider(),
              ],
            ),
          ),
        )
      ),
    );
  }

}