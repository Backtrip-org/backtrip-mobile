import 'package:backtrip/view/splash_screen_widget.dart';
import 'package:flutter/material.dart';

import 'view/login_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backtrip',
      home: SplashScreenWidget(),
    );
  }
}
