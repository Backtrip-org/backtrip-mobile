import 'dart:core';
import 'dart:io';

import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/model/user.dart';
import 'package:backtrip/service/trip_service.dart';
import 'package:backtrip/service/user_service.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/exception/LeaveStepException.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:backtrip/view/common/confirm_picked_image_dialog.dart';
import 'package:backtrip/view/common/participants_list_widget.dart';
import 'package:backtrip/view/trip/step/map_widget.dart';
import 'package:backtrip/view/trip/step/photo_carousel_widget.dart';
import 'package:backtrip/view/trip/step/place_rating_widget.dart';
import 'package:backtrip/view/trip/step/step_detail_notes_widget.dart';
import 'package:backtrip/view/trip/step/step_detail_subtitle_widget.dart';
import 'package:backtrip/view/trip/step/step_detail_transport_widget.dart';
import 'package:backtrip/view/trip/step/step_documents_widget.dart';
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

  void updateStep({step_model.Step step}) async {
    if (step == null) step = await TripService.getStep(_step.tripId, _step.id);
    setState(() {
      _step = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_step.name),
            actions: <Widget>[
              Visibility(
                child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  tooltip: 'Quitter l\'étape',
                  onPressed: () => leaveStep(context),
                ),
                visible: currentUserIsParticipant(),
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, _step),
            )),
        body: Builder(
            builder: (scaffoldContext) => SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (_step.startAddress?.coordinate != null)
                        MapWidget(_step),
                      presentationCard(),
                      informationCard(),
                      stepTypeRelatedContent(),
                      notesCard(scaffoldContext),
                      photosCard(),
                      documentsButton()
                    ],
                  ),
                )));
  }

  void leaveStep(BuildContext context) {
    TripService.leaveStep(_step.tripId, _step.id, BacktripApi.currentUser.id)
    .then((step) async {
      Navigator.of(context).pop();
    }).catchError((e) {
      if (e is LeaveStepException) {
        Components.snackBar(context, e.cause, Theme.of(context).errorColor);
      } else {
        Components.snackBar(
            context, 'Une erreur est survenue', Theme.of(context).errorColor);
      }
    });
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
                              child: Column(children: [stepName(), ratings()]),
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

  Widget ratings() {
    return Column(
      children: [
        if (_step.hasStartAddressRating())
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: PlaceRatingWidget(_step.startAddress)),
        if (_step.hasEndAddressRating())
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: PlaceRatingWidget((_step as StepTransport).endAddress))
      ],
    );
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
        StepDetailSubtitleWidget(Icons.info_outline, "Informations générales"),
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
                    onTap: () => UrlLauncher.launch('tel:+$phoneNumber'))
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
      ParticipantsListWidget(_step.participants, updateStep),
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

  Widget notesCard(BuildContext scaffoldContext) {
    return StepDetailNotesWidget(_step, scaffoldContext);
  }

  Widget photosCard() {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepDetailSubtitleWidget(Icons.image, "Photos",
                    firstActionIcon: Icons.add_a_photo,
                    firstAction: _getPhoto,
                    firstActionLabel: "Ajouter"),
                PhotoCarouselWidget(_step.getPhotos())
              ],
            )));
  }

  Container documentsButton() {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 15),
            onPressed: navigateToStepDocuments,
            child: Text("Vos documents",
                style: Theme.of(context).textTheme.button),
          ),
        ));
  }

  void navigateToStepDocuments() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => StepDocumentsWidget(_step)))
        .then((step) => updateStep(step: step));
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
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final file = File(pickedImage.path);
    showUploadPhotoConfirmationDialog(
        context, file, () => _uploadSelectedPhoto(file));
  }

  void _uploadSelectedPhoto(File pickedImage) {
    TripService.addPhotoToStep(_step.tripId, _step.id, pickedImage)
        .then((file) {
      setState(() {
        _step.files.add(file);
      });
    }).catchError((error) {
      Components.snackBar(
          context, 'Une erreur est survenue', Theme.of(context).errorColor);
    });
    Navigator.of(context).pop();
  }
}
