import 'package:backtrip/view/trip/chat/chat_widget.dart';
import 'package:backtrip/view/common/temp_widget.dart';
import 'package:backtrip/view/trip/expense/refunds_details.dart';
import 'package:backtrip/view/trip/timeline/timeline_widget.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:backtrip/view/trip/trip_settings_widget.dart';
import 'package:flutter/material.dart';

import '../../model/trip.dart';

class TripNavbar extends StatefulWidget {
  final Trip _trip;

  TripNavbar(this._trip);

  @override
  State<StatefulWidget> createState() {
    return _TripNavbarState();
  }
}

class _TripNavbarState extends State<TripNavbar> {
  Trip _trip;
  List<Widget> _children;
  int _currentIndex = 0;

  _TripNavbarState();

  @override
  void initState() {
    super.initState();

    updateTrip(widget._trip);
  }

  void updateTrip(Trip trip) {
    setState(() {
      _trip = trip;
      _children = [
        TimelineWidget(trip),
        ChatWidget(trip),
        RefundsDetails(trip),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_trip.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Administration',
            onPressed: _redirectToTripSettings,
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Theme.of(context).colorScheme.accentColorLight,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.timeline),
            title: new Text('Timeline'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), title: Text('Dépenses'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _redirectToTripSettings() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TripSettings(_trip)))
        .then((trip) {
      if (trip is Trip && trip != null) {
        updateTrip(trip);
      }
    });
  }
}
