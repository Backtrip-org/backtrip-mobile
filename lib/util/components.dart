import 'dart:io';

import 'package:backtrip/model/user.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/material.dart';

import 'backtrip_api.dart';

class Components {
  static snackBar(context, text, color) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  static Future<Widget> getParticipantWithPhoto(User participant) async {
    if(participant.picturePath != null) {
       return CircleAvatar(
        backgroundImage: NetworkImage(
            '${BacktripApi.path}/file/download/${participant.picturePath}',
            headers: {HttpHeaders.authorizationHeader: await StoredToken.getToken()}
        ),
        radius: 20,
      );
    }
    return getParticipantWithoutPhoto(participant);
  }

  static Widget getParticipantWithoutPhoto(User participant) {
    String participantInitials = participant.firstName[0] + participant.lastName[0];
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 20,
      child: Text(participantInitials,
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }
}
