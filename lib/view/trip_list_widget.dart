import 'dart:core';
import 'dart:io';

import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:backtrip/view/create_trip_widget.dart';
import 'package:backtrip/view/empty_list_widget.dart';
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

  final String ongoing = "En cours";
  final String coming = "À venir";
  final String finished = "Terminé";

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
              Tab(text: ongoing),
              Tab(text: coming),
              Tab(text: finished)
            ]),
          ),
          body: TabBarView(children: [
            tripList(ongoingTripsFuture, ongoing.toLowerCase()),
            tripList(comingTripsFuture, coming.toLowerCase()),
            tripList(finishedTripsFuture, finished.toLowerCase())
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

  Widget tripList(Future<List<Trip>> futureTrips, type) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: FutureBuilder<List<Trip>>(
            future: futureTrips,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data.length > 0) {
                  return ListView(
                    children: <Widget>[
                      Column(
                          children: snapshot.data.map((trip) {
                            return tripCard(trip);
                          }).toList())
                    ],
                  );
                } else {
                  return EmptyListWidget("Aucun voyage $type");
                }
              } else if (snapshot.hasError) {
                return Components.snackBar(
                    context, snapshot.error, Theme.of(context).errorColor);
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  void redirectToTripDetail(trip) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TripNavbar(trip)));
  }

  void redirectToTripCreation(BuildContext ctx) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateTrip()))
        .then((trip) {
      if (trip != null) {
        getTrips();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TripNavbar(trip)));
      }
    });
  }
}
