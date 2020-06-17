import 'package:backtrip/model/Operation.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/trip/expense/create_expense.dart';
import 'package:flutter/material.dart';

import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class RefundsDetails extends StatefulWidget {
  final Trip _trip;

  RefundsDetails(this._trip);

  @override
  _RefundsDetailsState createState() => _RefundsDetailsState();
}

class _RefundsDetailsState extends State<RefundsDetails> {
  List<Card> refundsCardList;
  List<Operation> operations;
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  @override
  void initState() {
    super.initState();
    refundsCardList = new List<Card>();
    operations = new List<Operation>();
    getRefunds();
  }

  Future<void> getRefunds() async {
    operations = await TripService.getTransactionsToBeMade(widget._trip, BacktripApi.currentUser.id);

    for(Operation operation in operations) {
      User user;
      if(BacktripApi.currentUser.id == operation.payeeId) {
        user = await UserService.getUserById(operation.emitterId);
        Card operationCard = await createNewOperationCard(operation.amount.toString(), Colors.lightGreen, 'à recevoir', user);
        setState(() {
          refundsCardList.add(operationCard);
        });
      } else {
        user = await UserService.getUserById(operation.payeeId);
        Card operationCard = await createNewOperationCard(operation.amount.toString(), Colors.red, 'à rembourser', user);
        setState(() {
          refundsCardList.add(operationCard);
        });
      }
    }
  }

  Future<Card> createNewOperationCard(String amount, Color color, String operationText, User user) async {
    CircleAvatar avatar = await Components.getParticipantWithPhoto(user);
    return Card(
      child: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: new Row(
          children: <Widget>[
            Container(
              child: avatar,
            ),
            SizedBox(width: 10),
            Container(
              child: Text(
                user.firstName,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Expanded(
              child: new Padding(
                padding: const EdgeInsets.all(20.0),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                    child: Text(
                      amount + '€',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: color
                      ),
                    )
                ),
                Container(
                    child: Text(
                      operationText,
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: color
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget circularChart() {
    return new AnimatedCircularChart(
      key: _chartKey,
      size: const Size(300.0, 300.0),
      initialChartData: <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              45.68,
              Colors.red[400],
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              143.54,
              Colors.green[600],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ],
      chartType: CircularChartType.Radial,
      holeLabel: 'Opérations en cours',
      labelStyle: new TextStyle(
        color: Colors.blueGrey[600],
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      edgeStyle: SegmentEdgeStyle.round,
      percentageValues: false,
    );
  }

  Widget refundsList() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: refundsCardList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return refundsCardList[index];
          }
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            circularChart(),
            refundsList(),
          ],
        ),
      ),
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
    setState(() {
      refundsCardList.clear();
      operations.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateExpense(widget._trip)))
          .then((context) {
        getRefunds();
      });
    });
  }
}
