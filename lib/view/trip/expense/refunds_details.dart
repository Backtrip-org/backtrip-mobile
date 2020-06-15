import 'package:backtrip/model/trip.dart';
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
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  @override
  void initState() {
    super.initState();
    refundsCardList = new List<Card>();
    getRefunds();
  }

  void getRefunds() {
    Card card = Card(
      child: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: new Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.brown.shade800,
                child: Text('AB'),
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: Text(
                'Alexis',
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
                      '143.54€',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.lightGreen
                      ),
                    )
                ),
                Container(
                    child: Text(
                      'à recevoir',
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.lightGreen
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Card refundCard = Card(
      child: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: new Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.brown.shade800,
                child: Text('CC'),
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: Text(
                'Célia',
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
                      '45.68€',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.red
                      ),
                    )
                ),
                Container(
                    child: Text(
                      'à rembourser',
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.red
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Card card2 = Card(
      child: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.fromLTRB(10, 30, 10, 30),
        child: new Row(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.brown.shade800,
                child: Text('VG'),
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: Text(
                'Vincent',
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
                      '103.49€',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.lightGreen
                      ),
                    )
                ),
                Container(
                    child: Text(
                      'à recevoir',
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.lightGreen
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
    refundsCardList.add(card);
    refundsCardList.add(refundCard);
    refundsCardList.add(card2);
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateExpense(widget._trip)));
  }
}
