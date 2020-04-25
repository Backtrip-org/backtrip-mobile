import 'dart:core';

import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/create_trip_widget.dart';
import 'package:backtrip/view/trip_navbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/trip.dart';

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  Future<List<Trip>> futureTrips;

  @override
  void initState() {
    super.initState();
    futureTrips = getTrips();
  }

  Widget tripCard(trip) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: new InkWell(
          onTap: () => navigateToTripDetail(trip),
          child: Card(
            child: Column(
              children: [
                Image.asset(
                    trip.picturePath?.isEmpty ??
                        "assets/images/trip-default.png",
                    width: 600,
                    height: 200,
                    fit: BoxFit.cover),
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
                          ],
                        ),
                      ),
                      /*3*/
                    ],
                  ),
                )
              ],
            ),)
          ,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Voyages"),
        ),
        floatingActionButton: Builder(
          builder: (ctx) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateTrip())
                ).then((trip) {
                  if (trip != null) {
                    Components.snackBar(ctx,
                        "Le voyage ${trip.name} a bien été créé !", Colors.green);
                    this.setState(() {
                      futureTrips = getTrips();
                    });
                  }
                });
              },
              child: Icon(Icons.add),
//          backgroundColor: secondary,
            );
          },
        ),
      body: Padding(
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
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              })
      )
    );
  }

  void navigateToTripDetail(trip) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TripNavbar(trip))
    );
  }

  Future<List<Trip>> getTrips() {
    return UserService.getTrips(BacktripApi.currentUser.id);
  }
}
