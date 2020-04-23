import 'package:backtrip/view/theme/backtrip_theme.dart';
import 'package:flutter/material.dart';

import 'view/login_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backtrip',
      theme: new BacktripTheme().theme,
      home: LoginWidget(),
    );
  }
}
