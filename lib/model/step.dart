import 'package:backtrip/model/user.dart';

class Step {
  int id;
  String name;
  DateTime startDatetime;
  DateTime endDateTime;
  String startAddress;
  String phoneNumber;
  String notes;
  int tripId;
  List<User> participants;
  String type;

  Step({this.id, this.name, this.startDatetime, this.endDateTime, this.startAddress, this.phoneNumber, this.notes, this.tripId, this.participants, this.type = 'Base'});

  factory Step.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> _participants = participantsJson
        .map((user) => User.fromJson(user))
        .toList();

    return Step(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.tryParse(json['start_datetime'].toString()),
        endDateTime: DateTime.tryParse(json['end_datetime'].toString()),
        startAddress: json['start_address'],
        phoneNumber: json['phone_number'],
        notes: json['notes'],
        tripId: json['trip_id'],
        type: json['type'],
        participants: _participants
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'start_datetime': startDatetime?.toIso8601String(),
        'end_datetime': endDateTime?.toIso8601String(),
        'start_address': startAddress,
        'phone_number': phoneNumber,
        'notes': notes,
        'type': type,
      };
}
