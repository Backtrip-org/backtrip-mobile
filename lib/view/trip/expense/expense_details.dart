import 'package:backtrip/model/trip.dart';
import 'package:backtrip/view/trip/expense/create_expense.dart';
import 'package:flutter/material.dart';

class ExpenseDetails extends StatefulWidget {
  final Trip _trip;

  ExpenseDetails(this._trip);

  @override
  _ExpenseDetailsState createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (ctx) {
          return FloatingActionButton(
              onPressed: () {
                redirectToExpenseCreation(ctx);
              },
              child: Icon(Icons.add));
        },
      ),
    );
  }

  void redirectToExpenseCreation(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateExpense(widget._trip)));
  }
}