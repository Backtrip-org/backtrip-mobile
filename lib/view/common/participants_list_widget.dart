import 'dart:io';

import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/backtrip_api.dart';
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

  Widget getParticipantWithPhoto(User participant) {
    return FutureBuilder<String>(
        future: StoredToken.getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              backgroundImage: NetworkImage(
                  '${BacktripApi.path}/file/download/${participant.picturePath}',
                  headers: {HttpHeaders.authorizationHeader: snapshot.data}
              ),
              radius: radius,
            );
          }
          return getParticipantWithoutPhoto(participant);
        }
    );
  }

  Widget getParticipantWithoutPhoto(User participant) {
    String participantInitials = participant.firstName[0] + participant.lastName[0];
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: radius,
      child: Text(participantInitials,
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  Widget getParticipantIconWidget(User participant) {
    var result;
    if (participant.hasProfilePicture()) {
      result = getParticipantWithPhoto(participant);
    } else {
      result = getParticipantWithoutPhoto(participant);
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