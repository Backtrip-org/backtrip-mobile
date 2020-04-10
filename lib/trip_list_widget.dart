import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/trip.dart';

class TripList extends StatefulWidget {

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {

  List<Trip> trips = [
    Trip(name: "Mon voyage", picturePath: ""),
    Trip(name: "Mon autre voyage", picturePath: ""),
    Trip(name: "Mon ancien voyage", picturePath: ""),
  ];

  Widget tripCard(Trip) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Column(
          children: [
            Image.asset(
                "assets/images/trip-default.png",
                width: 600,
                height: 200,
                fit: BoxFit.cover
            ),
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
                            Trip.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ListView(
          children: <Widget>[
            Column(
                children: trips.map((trip) {
                  return tripCard(trip);
                }).toList()
            )
          ],
        ),
      ),
    );
  }
}