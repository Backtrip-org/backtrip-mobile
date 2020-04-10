import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/trip.dart';

class TripList extends StatefulWidget {

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {

  List<Trip> trips = [
    Trip(name: "Mon voyage", picturePath: "img/test.png"),
    Trip(name: "Mon autre voyage", picturePath: "img/test.png"),
  ];

  Widget tripCard(Trip) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/trip-default.png")
                        )
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(Trip.name,
                    style: TextStyle (
                        fontSize: 18
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
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