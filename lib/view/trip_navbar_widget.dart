import 'package:backtrip/view/temp_widget.dart';
import 'package:backtrip/view/timeline_widget.dart';
import 'package:backtrip/view/trip_list_widget.dart';
import 'package:flutter/material.dart';

import '../model/trip.dart';

class TripNavbar extends StatefulWidget {
  final Trip _trip;

  TripNavbar(this._trip);

  @override
  State<StatefulWidget> createState() {
    return _TripNavbarState(_trip);
  }
}

class _TripNavbarState extends State<TripNavbar> {
  final Trip _trip;
  List<Widget> _children;
  int _currentIndex = 0;

  _TripNavbarState(this._trip);


  @override
  void initState() {
    super.initState();

    _children = [
    TimelineWidget(_trip),
    PlaceholderWidget(Colors.green), // temporary - in the end: chat
    PlaceholderWidget(Colors.blue) // temporary  in the end: spending
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_trip.name),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.timeline),
            title: new Text('Timeline'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              title: Text('Chat')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              title: Text('Dépenses')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}