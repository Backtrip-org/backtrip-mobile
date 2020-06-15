import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/trip/trip_invitation_widget.dart';
import 'package:flutter/material.dart';

class TripSettings extends StatefulWidget {
  final Trip _trip;

  TripSettings(this._trip);

  @override
  State<StatefulWidget> createState() {
    return _TripSettingsState();
  }
}

class _TripSettingsState extends State<TripSettings> {
  _TripSettingsState();

  List<Widget> get settingsItem =>
      [inviteToTripTile(), if (!widget._trip.closed) closeTripTile()];

  Widget inviteToTripTile() {
    return Builder(builder: (ctx) {
      return ListTile(
        leading: Icon(Icons.plus_one),
        title: Text('Inviter un ami'),
        subtitle: Text('Inviter un ami à participer au voyage'),
        onTap: () => _redirectToTripInvitation(ctx),
      );
    });
  }

  Widget closeTripTile() {
    return Builder(builder: (ctx) {
      return ListTile(
        leading: Icon(Icons.close),
        title: Text('Clôturer le voyage'),
        onTap: () => confirmTripClosure(ctx),
      );
    });
  }

  Widget listSettings() {
    return ListView.builder(
        itemCount: settingsItem.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            child: settingsItem[index],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Administration'),
        ),
        body: listSettings());
  }

  Future<void> confirmTripClosure(BuildContext scaffoldContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Êtes-vous sûr(e) de vouloir clôturer le voyage ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Valider'),
              onPressed: () {
                _closeTrip(scaffoldContext);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _redirectToTripInvitation(BuildContext scaffoldContext) {
    Navigator.push(
        scaffoldContext,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                TripInvitation(widget._trip))).then((invited) {
      if (invited != null) {
        Components.snackBar(
            scaffoldContext,
            'L\'invitation à rejoindre le voyage a bien été envoyée',
            Colors.green);
      }
    });
  }

  void _closeTrip(BuildContext scaffoldContext) {
    TripService.closeTrip(widget._trip.id).then((result) {
      Components.snackBar(
          scaffoldContext, 'Le voyage a été clôturé', Colors.green);
      Navigator.pop(context);
    }).catchError((error) => Components.snackBar(
        scaffoldContext, error.toString(), Theme.of(context).errorColor));
  }
}
