import 'package:backtrip/model/user.dart';

class Step {
  int id;
  String name;
  DateTime startDatetime;
  int tripId;
  List<User> participants;

  Step({this.id, this.name, this.startDatetime, this.tripId, this.participants});

  factory Step.fromJson(dynamic json) {
    var participantsJson = json['users_steps'] as List;
    List<User> _participants = participantsJson
        .map((user) => User.fromJson(user))
        .toList();

    return Step(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.parse(json['start_datetime']),
        tripId: json['trip_id'],
        participants: _participants
    );
  }
}
