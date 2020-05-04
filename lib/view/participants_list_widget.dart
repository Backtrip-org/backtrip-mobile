import 'package:backtrip/model/user.dart';
import 'package:flutter/material.dart';
import 'package:backtrip/view/theme/backtrip_theme.dart';

class ParticipantsListWidget extends StatefulWidget {
  final List<User> participants;

  ParticipantsListWidget(this.participants);

  @override
  _ParticipantsListWidgetState createState() => _ParticipantsListWidgetState(participants);
}


class _ParticipantsListWidgetState extends State<ParticipantsListWidget> {
  final List<User> participants;
  final int maxParticipantsToDisplay = 4;

  _ParticipantsListWidgetState(this.participants);

  Widget getParticipantIconWidget(User participant) {
    String participantInitials = participant.firstName[0] + participant.lastName[0];
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Text(participantInitials,
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  Widget getXMoreParticipantsWidget() {
    return Text(
        (participants.length - maxParticipantsToDisplay).toString() + "+",
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 20
        ),
    );
  }

  List<User> getParticipants() {
    var _participants = participants;
    if(tripHasMoreThanMaxParticipantsToDisplay()) {
      _participants = _participants.sublist(0, maxParticipantsToDisplay);
    }

    return _participants;
  }

  bool tripHasMoreThanMaxParticipantsToDisplay() {
    return participants.length > maxParticipantsToDisplay;
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