import 'dart:io';
import 'package:backtrip/util/backtrip_http_override.dart';
import 'package:backtrip/util/notification.dart';
import 'package:backtrip/view/authentification/splash_screen_widget.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = new BacktripHttpOverride();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationManager.initializeNotification();
    return MaterialApp(
      title: 'Backtrip',
      home: SplashScreenWidget(),
      theme: new BacktripTheme().theme,
    );
  }
}