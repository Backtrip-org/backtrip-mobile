import 'dart:io';

import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/components.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/material.dart';

class ParticipantsListWidget extends StatefulWidget {
  final List<User> participants;
  final double radius;

  ParticipantsListWidget(this.participants, [this.radius = 20]);

  @override
  _ParticipantsListWidgetState createState() => _ParticipantsListWidgetState(radius);
}


class _ParticipantsListWidgetState extends State<ParticipantsListWidget> {
  final int maxParticipantsToDisplay = 4;
  final double radius;

  _ParticipantsListWidgetState(this.radius);

  Widget getParticipantIconWidget(User participant) {
    var result;
    if (participant.hasProfilePicture()) {
      result = Components.getParticipantWithPhoto(participant);
    } else {
      result = Components.getParticipantWithoutPhoto(participant);
    }

    return result;
  }

  Widget getXMoreParticipantsWidget() {
    return Text(
      (widget.participants.length - maxParticipantsToDisplay).toString() + "+",
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20
      ),
    );
  }

  List<User> getParticipants() {
    var _participants = widget.participants;
    if(tripHasMoreThanMaxParticipantsToDisplay()) {
      _participants = _participants.sublist(0, maxParticipantsToDisplay);
    }

    return _participants;
  }

  bool tripHasMoreThanMaxParticipantsToDisplay() {
    return widget.participants.length > maxParticipantsToDisplay;
  }

  void addExtraParticipants(List<Widget> _participants) {
    if(tripHasMoreThanMaxParticipantsToDisplay()) {
      _participants.add(getXMoreParticipantsWidget());
    }
  }

  void addSeparatorBetweenEachAvatar(List<Widget> _participants) {
    Widget spaceSeparator = SizedBox(width: 5);

    int length = _participants.length;
    for(int index = 0; index < length; index++) {
      _participants.insert(index * 2 + 1, spaceSeparator);
    }
  }

  List<Widget> convertParticipantToAvatar(List<User> _participants) {
    return _participants
        .map((participant) => getParticipantIconWidget(participant))
        .toList();
  }

  List<Widget> getAllParticipantsIcon() {
    List<User> _participants = getParticipants();
    var result = convertParticipantToAvatar(_participants);
    addSeparatorBetweenEachAvatar(result);
    addExtraParticipants(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: getAllParticipantsIcon()
    );
  }

}