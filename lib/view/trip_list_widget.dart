import 'dart:core';
import 'dart:io';

import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:backtrip/view/create_trip_widget.dart';
import 'package:backtrip/view/participants_list_widget.dart';
import 'package:backtrip/view/trip_navbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/trip.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  Future<List<Trip>> ongoingTripsFuture;
  Future<List<Trip>> comingTripsFuture;
  Future<List<Trip>> finishedTripsFuture;

  @override
  void initState() {
    super.initState();
    getTrips();
  }

  getTrips() {
    this.setState(() {
      ongoingTripsFuture =
          UserService.getOngoingTrips(BacktripApi.currentUser.id);
      comingTripsFuture =
          UserService.getComingTrips(BacktripApi.currentUser.id);
      finishedTripsFuture =
          UserService.getFinishedTrips(BacktripApi.currentUser.id);
    });
  }

  Widget getDefaultTripCoverPage() {
    return Image.asset("assets/images/trip-default.png",
        width: 600, height: 200, fit: BoxFit.cover);
  }

  Widget getTripCoverPageFromAPI(Trip trip) {
    return FutureBuilder<String>(
        future: StoredToken.getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.network(
                '${BacktripApi.path}/file/download/${trip.picturePath}',
                headers: {HttpHeaders.authorizationHeader: snapshot.data},
                width: 600,
                height: 200,
                fit: BoxFit.cover);
          }
          return getDefaultTripCoverPage();
        });
  }

  Widget getTripCoverPage(Trip trip) {
    if (trip.hasCoverPicture()) {
      return getTripCoverPageFromAPI(trip);
    } else {
      return getDefaultTripCoverPage();
    }
  }

  Widget tripCard(trip) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: new InkWell(
          onTap: () => redirectToTripDetail(trip),
          child: Card(
            child: Column(
              children: [
                getTripCoverPage(trip),
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                trip.name,
                                style: Theme.of(context).textTheme.headline,
                              ),
                            ),
                            Visibility(
                              visible: trip.countdown > 0,
                              child: countdown(trip),
                            ),
                            ParticipantsListWidget(trip.participants)
                          ],
                        ),
                      ),
                      /*3*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget countdown(trip) {
    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(children: [
          Icon(
            Icons.timer,
            size: 22,
            color: Theme.of(context).accentColor,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("J - ${trip.countdown}",
                  style: Theme.of(context).textTheme.subhead))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Voyages"),
            bottom: TabBar(tabs: [
              Tab(text: "En cours"),
              Tab(text: "À venir"),
              Tab(text: "Terminés")
            ]),
          ),
          body: TabBarView(children: [
            tripList(ongoingTripsFuture),
            tripList(comingTripsFuture),
            tripList(finishedTripsFuture)
          ]),
          floatingActionButton: Builder(
            builder: (ctx) {
              return FloatingActionButton(
                  onPressed: () {
                    redirectToTripCreation(ctx);
                  },
                  child: Icon(Icons.add));
            },
          ),
        ));
  }

  Widget tripList(Future<List<Trip>> futureTrips) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: FutureBuilder<List<Trip>>(
            future: futureTrips,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    Column(
                        children: snapshot.data.map((trip) {
                      return tripCard(trip);
                    }).toList())
                  ],
                );
              } else if (snapshot.hasError) {
                return Components.snackBar(
                    context, snapshot.error, Theme.of(context).errorColor);
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  void redirectToTripDetail(trip) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripNavbar(trip)))
        .then((context) {
          getTrips();
    });
  }

  void redirectToTripCreation(BuildContext ctx) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateTrip()))
        .then((trip) {
      if (trip != null) {
        Components.snackBar(
            ctx, "Le voyage ${trip.name} a bien été créé !", Colors.green);
        getTrips();
      }
    });
  }
}
