import 'package:backtrip/trip_list_widget.dart';
import 'package:flutter/material.dart';

import 'trip_navbar_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backtrip',
      home: TripList(),
    );
  }
}