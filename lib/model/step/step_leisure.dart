import 'package:backtrip/model/place/place.dart';
import 'package:backtrip/model/step/step.dart';
import 'package:backtrip/model/user.dart';
import 'package:flutter/material.dart' as material;

class StepLeisure extends Step {
  static const String type = 'Leisure';

  @override
  final material.IconData icon = material.Icons.videogame_asset;

  StepLeisure(
      {id,
      name,
      startDatetime,
      endDateTime,
      startAddress,
      phoneNumber,
      notes,
      tripId,
      participants})
      : super(
            id: id,
            name: name,
            startDatetime: startDatetime,
            endDateTime: endDateTime,
            startAddress: startAddress,
            phoneNumber: phoneNumber,
            notes: notes,
            tripId: tripId,
            participants: participants);

  @override
  factory StepLeisure.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> _participants =
        participantsJson.map((user) => User.fromJson(user)).toList();

    return StepLeisure(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.tryParse(json['start_datetime'].toString()),
        endDateTime: DateTime.tryParse(json['end_datetime'].toString()),
        startAddress: Place.fromJson(json['start_address']),
        phoneNumber: json['phone_number'],
        notes: json['notes'],
        tripId: json['trip_id'],
        participants: _participants);
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'start_datetime': startDatetime?.toIso8601String(),
        'end_datetime': endDateTime?.toIso8601String(),
        'start_address': startAddress?.toJson(),
        'phone_number': phoneNumber,
        'notes': notes,
        'type': type,
      };
}
