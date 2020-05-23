import 'package:backtrip/model/user.dart';

class Trip {
  int id;
  String name;
  String picturePath;
  int creatorId;
  int countdown;
  List<User> participants;

  static const nameMinLength = 2;
  static const nameMaxLength = 20;

  Trip({this.id, this.name, this.picturePath, this.creatorId, this.countdown, this.participants});

  factory Trip.fromJson(dynamic json) {
    var participantsJson = json['users_trips'] as List;
    List<User> _participants = participantsJson
        .map((user) => User.fromJson(user))
        .toList();

    return Trip(
        id: json['id'],
        name: json['name'],
        picturePath: json['picture_path'],
        creatorId: json['creator_id'],
        countdown: json['countdown'] ?? 0,
        participants: _participants
    );
  }

  bool hasCoverPicture() {
    return this.picturePath != null;
  }
}