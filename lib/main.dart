import 'package:flutter/material.dart';

import 'login_widget.dart';
import 'home_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backtrip',
      home: Login(),
    );
  }
}