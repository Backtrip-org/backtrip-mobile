import 'dart:core';
import 'dart:io';

import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/view/common/participants_list_widget.dart';
import 'package:backtrip/view/trip/step/map_widget.dart';
import 'package:backtrip/view/trip/step/photo_carousel_widget.dart';
import 'package:backtrip/view/trip/step/step_detail_transport_widget.dart';
import 'package:backtrip/view/trip/step/step_period_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/model/step/step.dart' as step_model;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class StepDetailWidget extends StatefulWidget {
  final step_model.Step _step;

  StepDetailWidget(this._step);

  @override
  _StepDetailWidgetState createState() => _StepDetailWidgetState();
}

class _StepDetailWidgetState extends State<StepDetailWidget> {
  step_model.Step _step;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _step = widget._step;
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_step.name),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, _step),
            )),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (_step.startAddress?.coordinate != null) MapWidget(_step),
              presentationCard(),
              informationCard(),
              stepTypeRelatedContent(),
              notesCard(),
              photosCard(),
              documentsButton()
            ],
          ),
        ));
  }

  Widget presentationCard() {
    return Card(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (ctx) {
                  return Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(children: [
                                stepName(),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        child: IconButton(
                          padding: EdgeInsets.only(bottom: 3),
                          onPressed: () => _joinStep(ctx),
                          icon: Icon(Icons.person_add),
                        ),
                        visible: !currentUserIsParticipant(),
                      )
                      /*3*/
                    ],
                  );
                },
              ))
        ],
      ),
    );
  }

  Widget stepName() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(_step.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
    ]);
  }

  bool currentUserIsParticipant() {
    return _step.participants
        .map((user) => user.id)
        .toList()
        .contains(BacktripApi.currentUser.id);
  }

  Widget informationCard() {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        title(Icons.info_outline, "Informations générales"),
        period(),
        phoneNumber(),
        participants(),
      ]),
    ));
  }

  Widget period() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 0, 0),
          child: StepPeriodWidget(_step)),
      Divider(),
    ]);
  }

  Widget phoneNumber() {
    var phoneNumber = _step.phoneNumber ?? "0";
    return Visibility(
        visible: _step.phoneNumber != null && _step.phoneNumber != '',
        child: Column(children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                Icon(Icons.phone,
                    size: 20, color: Theme.of(context).accentColor),
                SizedBox(width: 5),
                InkWell(
                    child: Text(phoneNumber,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          letterSpacing: 1,
                        )),
                    onTap: () => UrlLauncher.launch('tel:+${phoneNumber}'))
              ])),
          Divider()
        ]));
  }

  Widget participants() {
    return Column(children: [
      participantLabel(),
      SizedBox(
        height: 7,
      ),
      ParticipantsListWidget(_step.participants),
    ]);
  }

  Row participantLabel() {
    var participantsText;
    if (_step.participants.length == 0) {
      participantsText = "Pas de participants";
    } else {
      participantsText = "Participants";
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text(participantsText)]);
  }

  Widget stepTypeRelatedContent() {
    return Column(children: <Widget>[
      if (_step is StepTransport)
        StepDetailTransportWidget(_step as StepTransport),
    ]);
  }

  Widget notesCard() {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title(Icons.short_text, "Notes"),
                Text(_step.notes ?? "Aucune note pour le moment !")
              ],
            )));
  }

  Widget photosCard() {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title(Icons.image, "Photos",
                    actionIcon: Icons.add_a_photo,
                    action: _getPhoto,
                    actionLabel: "Ajouter"),
                PhotoCarouselWidget(_step.getPhotos())
              ],
            )));
  }

  Container documentsButton() {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 15),
            onPressed: () {},
            child: Text("Vos documents",
                style: Theme.of(context).textTheme.button),
          ),
        ));
  }

  Widget title(icon, text, {actionIcon, action, actionLabel}) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 5),
          Text(text, style: Theme.of(context).textTheme.title),
          Spacer(),
          if (actionIcon != null)
            OutlineButton.icon(
                icon: Icon(
                  actionIcon,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(actionLabel,
                    style: Theme.of(context).textTheme.subhead),
                onPressed: action)
        ]));
  }

  void _joinStep(context) {
    TripService.joinStep(_step, BacktripApi.currentUser.id).then((value) {
      Components.snackBar(
          context, 'Vous avez rejoint l\'étape `${_step.name}`', Colors.green);
      setState(() {
        _step.participants = value;
      });
    }).catchError((e) {
      if (e is UnexpectedException) {
        Components.snackBar(context, e.cause, Color(0xff8B0000));
      } else {
        Components.snackBar(
            context,
            "Le serveur est inaccessible. Veuillez vérifier votre connexion internet.",
            Color(0xff8B0000));
      }
    });
  }

  Future _getPhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _showUploadPhotoConfirmationDialog(File(pickedFile.path));
  }

  Future<void> _showUploadPhotoConfirmationDialog(pickedImage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.add_a_photo),
            SizedBox(width: 10),
            Text('Confirmation')
          ]),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth, image: FileImage(pickedImage))),
                ),
                SizedBox(height: 20),
                Center(child: Text('Voulez-vous envoyer cette image ?')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ANNULER'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('CONFIRMER'),
              onPressed: () {
                TripService.addPhotoToStep(
                        _step.tripId, widget._step.id, pickedImage)
                    .then((file) {
                  setState(() {
                    _step.files.add(file);
                  });
                }).catchError((error) {
                  Components.snackBar(context, 'Une erreur est survenue',
                      Theme.of(context).errorColor);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
