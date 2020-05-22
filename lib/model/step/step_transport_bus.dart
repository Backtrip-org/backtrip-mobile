import 'package:backtrip/model/step/step_transport.dart';
import 'package:backtrip/model/user.dart';
import 'package:flutter/material.dart' as material;

class StepTransportBus extends StepTransport {
  static const String type = 'TransportBus';

  @override
  final material.IconData icon = material.Icons.directions_bus;

  StepTransportBus(
      {id,
      name,
      startDatetime,
      endDateTime,
      startAddress,
      phoneNumber,
      notes,
      tripId,
      participants,
      reservationNumber,
      transportNumber,
      endAddress})
      : super(
            id: id,
            name: name,
            startDatetime: startDatetime,
            endDateTime: endDateTime,
            startAddress: startAddress,
            phoneNumber: phoneNumber,
            notes: notes,
            tripId: tripId,
            participants: participants,
            reservationNumber: reservationNumber,
            transportNumber: transportNumber,
            endAddress: endAddress);

  @override
  factory StepTransportBus.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> _participants =
        participantsJson.map((user) => User.fromJson(user)).toList();

    return StepTransportBus(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.tryParse(json['start_datetime'].toString()),
        endDateTime: DateTime.tryParse(json['end_datetime'].toString()),
        startAddress: json['start_address'],
        endAddress: json['end_address'],
        phoneNumber: json['phone_number'],
        notes: json['notes'],
        reservationNumber: json['reservation_number'],
        transportNumber: json['transport_number'],
        tripId: json['trip_id'],
        participants: _participants);
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'start_datetime': startDatetime?.toIso8601String(),
        'end_datetime': endDateTime?.toIso8601String(),
        'start_address': startAddress,
        'end_address': endAddress,
        'phone_number': phoneNumber,
        'notes': notes,
        'reservation_number': reservationNumber,
        'transport_number': transportNumber,
        'type': type,
      };
}