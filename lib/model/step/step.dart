import 'package:backtrip/model/place/place.dart';
import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/model/user.dart';
import 'package:flutter/material.dart' as material;

class Step {
  int id;
  String name;
  DateTime startDatetime;
  DateTime endDateTime;
  Place startAddress;
  String phoneNumber;
  String notes;
  int tripId;
  List<User> participants;

  static const String type = 'Base';
  final material.IconData icon = material.Icons.assistant_photo;

  static const nameMinLength = 2;
  static const nameMaxLength = 20;

  Step(
      {this.id,
      this.name,
      this.startDatetime,
      this.endDateTime,
      this.startAddress,
      this.phoneNumber,
      this.notes,
      this.tripId,
      this.participants});

  bool hasEndAddress() {
    return this is StepTransport &&
        (this as StepTransport).endAddress?.coordinate != null;
  }

  bool hasStartAddressRating() {
    return this.startAddress != null && this.startAddress.rating != null;
  }

  bool hasEndAddressRating() {
    return hasEndAddress() && (this as StepTransport).endAddress.rating != null;
  }

  factory Step.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> _participants =
        participantsJson.map((user) => User.fromJson(user)).toList();

    return Step(
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
