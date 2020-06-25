import 'package:backtrip/model/expense.dart';
import 'package:backtrip/model/operation.dart';
import 'package:backtrip/model/reimbursement.dart';
import 'package:backtrip/model/user_avatar.dart';
import 'package:backtrip/model/trip.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/common/empty_list_widget.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:backtrip/view/trip/expense/createReimbursement.dart';
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
  Future<List<Expense>> userExpenses;
  Future<List<Reimbursement>> expenseReimbursements;
  double toGet = 10;
  double toRefund = 10;

  @override
  void initState() {
    super.initState();
    getUsersAvatars();
    getRefunds();
    getUserExpenses(widget._trip, BacktripApi.currentUser.id);
  }

  Future<void> getUsersAvatars() async {
    List<User> userList = widget._trip.participants;
    int userListLength = userList.length;
    for(int i = 0; i < userListLength; i++) {
      CircleAvatar circleAvatar = await Components.getParticipantCircularAvatar(userList[i]);
      usersAvatars.add(UserAvatar(userList[i], circleAvatar));
    }
  }

  void getRefunds() {
    futuresOperations = TripService.getTransactionsToBeMade(widget._trip, BacktripApi.currentUser.id);
  }

  void getUserExpenses(Trip trip, int userId) {
    userExpenses = TripService.getUserExpenses(trip, userId);
  }

  void resetChartValues() {
    toGet = 0;
    toRefund = 0;
  }

  InkWell createNewOperationCard(Operation operation, Color color, String operationText, User user) {
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
                      operation.amount.toString() + '€',
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
      onTap: ()=> redirectToReimbursement(context, operation, user),
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
        InkWell operationCard = createNewOperationCard(operation, Colors.lightGreen, 'à recevoir', getUserById(users, operation.emitterId));
          refundsCardList.add(operationCard);
      } else {
        InkWell operationCard = createNewOperationCard(operation, Colors.red, 'à rembourser', getUserById(users, operation.payeeId));
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

  InkWell createNewExpenseCard(Expense expense) {
    Card card = Card(
      child: new Container(
        alignment: Alignment.center,
        padding: new EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: new Row(
          children: <Widget>[
            Expanded(
              child: Text(
                expense.name,
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(width: 40),
            Container(
                child: Text(
                  expense.cost.toString() + '€',
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.green
                  ),
                )
            ),
          ],
        ),
      ),
    );

    return new InkWell(
      onTap: () => showExpenseDialog(expense),
      child: card,
    );
  }

  Card createNewExpenseReimbursementsCard(Reimbursement reimbursement) {
    User user = getUserById(widget._trip.participants, reimbursement.emitterId);
    CircleAvatar avatar = getCircleAvatarByUser(user);
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
                      reimbursement.cost.toString() + '€',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.green
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

  Future showExpenseDialog(Expense expense) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(expense.name),
            content: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: futureBuilderExpenseReimbursements(expense),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok :)'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget futureBuilderExpenseReimbursements(Expense expense) {
    expenseReimbursements = TripService.getExpenseReimbursements(widget._trip, expense);
    return FutureBuilder<List<Reimbursement>>(
        future: expenseReimbursements,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double cost = 0;
            for(int i = 0; i < snapshot.data.length; i++) {
              cost += snapshot.data[i].cost;
            }
            Reimbursement reimbursement = Reimbursement(cost: double.parse((expense.cost - cost).toStringAsFixed(2)), emitterId: expense.userId);
            snapshot.data.add(reimbursement);
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return createNewExpenseReimbursementsCard(snapshot.data[index]);
                  });
            } else {
              return EmptyListWidget("Aucune collaborateur pour cette dépense");
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  SingleChildScrollView operations() {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
          circularChart(),
          refundsList(),
        ],
    ));
  }

  Widget userExpensesList() {
    return FutureBuilder<List<Expense>>(
        future: userExpenses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return createNewExpenseCard(snapshot.data[index]);
                  });
            } else {
              return EmptyListWidget("Aucune opération en cours");
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: new BacktripTheme().theme.primaryColor,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(tabs: [
                      Tab(text: "Opérations"),
                      Tab(text: "Dépenses"),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [operations(), userExpensesList()]),
          floatingActionButton: Builder(
            builder: (ctx) {
              return FloatingActionButton(
                  onPressed: () {
                    redirectToExpenseCreation(ctx);
                  },
                  child: Icon(Icons.add));
            },
          ),
        ));
  }

  void redirectToExpenseCreation(context) {
    setState(() {
      refundsCardList.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateExpense(widget._trip)))
          .then((context) {
        getRefunds();
        getUserExpenses(widget._trip, BacktripApi.currentUser.id);
      });
    });
  }

  void redirectToReimbursement(context, Operation operation, User user) {
    if(operation.emitterId == BacktripApi.currentUser.id) {
      setState(() {
        refundsCardList.clear();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateReimbursement(widget._trip, operation, user)))
            .then((context) {
          getRefunds();
        });
      });
    }
  }
}
