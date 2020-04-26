import 'package:backtrip/service/auth_service.dart';
import 'package:backtrip/view/login_widget.dart';
import 'package:backtrip/view/trip_list_widget.dart';
import 'package:flutter/material.dart';


class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {

  void initState() {
    super.initState();
    AuthService.isUserAlreadyLogged()
        .then((void val) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => TripList()),
              (Route<dynamic> route) => false);
    }).catchError((e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => LoginWidget()),
              (Route<dynamic> route) => false);
    });
  }

  Widget _logo() {
    return Image.asset(
      'assets/images/backtrip.png',
      height: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _logo(),
            ],
          ),
        ),
      ),
    );
  }
}
