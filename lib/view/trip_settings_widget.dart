import 'package:backtrip/model/trip.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/trip_invitation_widget.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class TripSettings extends StatefulWidget {
  final Trip _trip;

  TripSettings(this._trip);

  @override
  State<StatefulWidget> createState() {
    return _TripSettingsState(_trip);
  }
}

class _TripSettingsState extends State<TripSettings> {
  final Trip _trip;

  _TripSettingsState(this._trip);

  List<Widget> get settingsItem => [
    inviteToTrip()
  ];

  Widget inviteToTrip() {
    return Builder(
      builder: (ctx) {
        return ListTile(
          leading: Icon(Icons.plus_one),
          title: Text('Inviter un ami'),
          subtitle: Text('Inviter un ami à participer au voyage'),
          onTap: () => _redirectToTripInvitation(ctx),
        );
      }
    );
  }

  Widget listSettings() {
    return ListView.builder(
        itemCount: settingsItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 80.0,
            child: settingsItem[index],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Administration'),
        ),
        body: listSettings()
    );
  }

  void _redirectToTripInvitation(BuildContext scaffoldContext) {
    Navigator.push(
        scaffoldContext,
        MaterialPageRoute(builder: (BuildContext context) => TripInvitation(_trip))
    ).then((invited) {
      if (invited != null) {
        Components.snackBar(scaffoldContext, 'L\'invitation à rejoindre le voyage a bien été envoyée', Colors.green);
      }
    });
  }
}