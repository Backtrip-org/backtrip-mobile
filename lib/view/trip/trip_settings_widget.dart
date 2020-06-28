import 'dart:io';

import 'package:backtrip/model/trip.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/view/common/confirm_picked_image_dialog.dart';
import 'package:backtrip/view/trip/trip_invitation_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  final _picker = ImagePicker();

  List<Widget> get settingsItem => [
        inviteToTripTile(),
        updateCoverPhotoTile(),
        if (!widget._trip.closed) closeTripTile()
      ];

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

  Widget updateCoverPhotoTile() {
    return Builder(builder: (ctx) {
      return ListTile(
        leading: Icon(Icons.photo_size_select_actual),
        title: Text('Mettre à jour la photo de couverture'),
        onTap: () => _getCoverPicture(ctx),
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
        body: Builder(builder: (scaffoldContext) => listSettings()));
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

  Future _getCoverPicture(BuildContext scaffoldContext) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final file = File(pickedFile.path);
    showUploadPhotoConfirmationDialog(
        context, file, () => _uploadCoverPicture(scaffoldContext, file));
  }

  void _uploadCoverPicture(BuildContext scaffoldContext, File pickedImage) {
    TripService.addCoverPictureToTrip(widget._trip.id, pickedImage)
        .then((file) {
      Components.snackBar(scaffoldContext,
          'La photo de couverture a bien été mise à jour', Colors.green);
    }).catchError((error) {
      Components.snackBar(scaffoldContext, 'Une erreur est survenue',
          Theme.of(context).errorColor);
    });
    Navigator.of(context).pop();
  }

  void _closeTrip(BuildContext scaffoldContext) {
    TripService.closeTrip(widget._trip.id).then((result) {
      widget._trip.closed = true;
      Components.snackBar(
          scaffoldContext, 'Le voyage a été clôturé', Colors.green);
      Navigator.pop(context, widget._trip);
    }).catchError((error) => Components.snackBar(
        scaffoldContext, error.toString(), Theme.of(context).errorColor));
  }
}
