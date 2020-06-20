import 'package:backtrip/model/Operation.dart';
import 'package:backtrip/model/UserAvatar.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/common/empty_list_widget.dart';
import 'package:backtrip/view/trip/expense/CreateReimbursement.dart';
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
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  List<UserAvatar> usersAvatars = List<UserAvatar>();
  List<InkWell> refundsCardList = new List<InkWell>();
  Future<List<Operation>> futuresOperations;
  Future<List<User>> futureUserList;
  double toGet = 10;
  double toRefund = 10;

  @override
  void initState() {
    super.initState();
    getUsersAvatars();
    getRefunds();
  }

  Future<void> getUsersAvatars() async {
    List<User> userList = widget._trip.participants;
    int userListLength = userList.length;
    for(int i = 0; i < userListLength; i++) {
      CircleAvatar circleAvatar = await Components.getParticipantWithPhoto(userList[i]);
      usersAvatars.add(UserAvatar(userList[i], circleAvatar));
    }
  }

  void getRefunds() {
    futuresOperations = TripService.getTransactionsToBeMade(widget._trip, BacktripApi.currentUser.id);
  }

  void resetChartValues() {
    toGet = 0;
    toRefund = 0;
  }

  InkWell createNewOperationCard(String amount, Color color, String operationText, User user) {
    CircleAvatar avatar = getCircleAvatarByUser(user);
    Card card = Card(
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
                //user.firstName,
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

    return new InkWell(
      onTap: ()=> {},
      child: card,
    );
  }

  CircleAvatar getCircleAvatarByUser(User user) {
    for(UserAvatar userAvatar in usersAvatars) {
      if(userAvatar.user.id == user.id) {
        return userAvatar.circleAvatar;
      }
    }
    return null;
  }

  Widget circularChart() {
    return FutureBuilder<List<Operation>>(
        future: futuresOperations,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              setChart(snapshot.data);
              if( _chartKey.currentState != null) {
                reloadChart();
              }
              return new AnimatedCircularChart(
                key: _chartKey,
                size: const Size(300.0, 300.0),
                initialChartData: <CircularStackEntry>[
                  circularStackEntryChart(),
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
              //return createCardList(snapshot.data);
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container();
        });
  }

  void reloadChart() {
    List<CircularStackEntry> circularStackEntryList = new List<CircularStackEntry>();
    circularStackEntryList.add(circularStackEntryChart());
    _chartKey.currentState.updateData(circularStackEntryList);
  }

  CircularStackEntry circularStackEntryChart() {
    return CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(
          toRefund,
          Colors.red[400],
          rankKey: 'completed',
        ),
        new CircularSegmentEntry(
          toGet,
          Colors.green[600],
          rankKey: 'remaining',
        ),
      ],
      rankKey: 'progress',
    );
  }

  void setChart(List<Operation> operations) {
    if(operations.length > 0) {
      resetChartValues();
      for(Operation operation in operations) {
        if(BacktripApi.currentUser.id == operation.payeeId) {
          toGet += operation.amount;
        } else {
          toRefund += operation.amount;
        }
      }
    }
  }

  Widget refundsList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: FutureBuilder<List<Operation>>(
          future: futuresOperations,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                createCardList(snapshot.data, widget._trip.participants);
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: refundsCardList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return refundsCardList[index];
                    });
              } else {
                return EmptyListWidget("Aucune opération en cours");
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> createCardList(List<Operation> operations, List<User> users) async {
    refundsCardList.clear();
    for(Operation operation in operations) {
      if(BacktripApi.currentUser.id == operation.payeeId) {
        InkWell operationCard = createNewOperationCard(operation.amount.toString(), Colors.lightGreen, 'à recevoir', getUserById(users, operation.emitterId));
          refundsCardList.add(operationCard);
      } else {
        InkWell operationCard = createNewOperationCard(operation.amount.toString(), Colors.red, 'à rembourser', getUserById(users, operation.payeeId));
        refundsCardList.add(operationCard);
      }
    }
  }

  User getUserById(userList, userId) {
    for(User u in userList) {
      if(u.id == userId) {
        return u;
      }
    }
    return null;
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateExpense(widget._trip)))
          .then((context) {
        getRefunds();
      });
    });
  }

  void redirectToReimbursement(context) {
    setState(() {
      refundsCardList.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateReimbursement(widget._trip)))
          .then((context) {
        getRefunds();
      });
    });
  }
}
