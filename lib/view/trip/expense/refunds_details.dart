import 'package:backtrip/model/trip.dart';
import 'package:backtrip/view/trip/expense/create_expense.dart';
import 'package:flutter/material.dart';

class RefundsDetails extends StatefulWidget {
  final Trip _trip;

  RefundsDetails(this._trip);

  @override
  _RefundsDetailsState createState() => _RefundsDetailsState();
}

class _RefundsDetailsState extends State<RefundsDetails> {
  List<Card> refundsCardList;

  @override
  void initState() {
    super.initState();
    refundsCardList = new List<Card>();
    getRefunds();
  }

  void getRefunds() {
    Card card = Card(
      child: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Column(
          children: <Widget>[
            new Text('Hello World'),
            new Text('How are you?')
          ],
        ),
      ),
    );
    refundsCardList.add(card);
  }

  Widget refundsList() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView.separated(
          itemCount: refundsCardList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return refundsCardList[index];
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: refundsList(),
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