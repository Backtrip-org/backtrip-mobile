import 'dart:io';
import 'package:backtrip/util/backtrip_http_override.dart';
import 'package:backtrip/util/notification.dart';
import 'package:backtrip/view/authentification/splash_screen_widget.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  HttpOverrides.global = new BacktripHttpOverride();
  initDownloader();
  runApp(App());
}

void initDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationManager.initializeNotification();
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', 'FR')
      ],
      title: 'Backtrip',
      home: SplashScreenWidget(),
      theme: new BacktripTheme().theme,
    );
  }
}