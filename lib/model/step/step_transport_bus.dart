import 'package:backtrip/model/file.dart';
import 'package:backtrip/model/place/place.dart';
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
      files,
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
            files: files,
            reservationNumber: reservationNumber,
            transportNumber: transportNumber,
            endAddress: endAddress);

  @override
  factory StepTransportBus.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> participants =
        participantsJson.map((user) => User.fromJson(user)).toList();

    var filesJson = json['files'] as List;
    List<File> files = filesJson.map((file) => File.fromJson(file)).toList();

    return StepTransportBus(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.tryParse(json['start_datetime'].toString()),
        endDateTime: DateTime.tryParse(json['end_datetime'].toString()),
        startAddress: Place.fromJson(json['start_address']),
        endAddress: Place.fromJson(json['end_address']),
        phoneNumber: json['phone_number'],
        notes: json['notes'],
        reservationNumber: json['reservation_number'],
        transportNumber: json['transport_number'],
        tripId: json['trip_id'],
        participants: participants,
        files: files);
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'start_datetime': startDatetime?.toIso8601String(),
        'end_datetime': endDateTime?.toIso8601String(),
        'start_address': startAddress?.toJson(),
        'end_address': endAddress?.toJson(),
        'phone_number': phoneNumber,
        'notes': notes,
        'reservation_number': reservationNumber,
        'transport_number': transportNumber,
        'type': type,
      };
}
