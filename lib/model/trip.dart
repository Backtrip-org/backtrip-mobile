class Trip {
  int id;
  String name;
  String picturePath;
  int creatorId;

  Trip({this.id, this.name, this.picturePath, this.creatorId});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        id: json['id'],
        name: json['name'],
        picturePath: json['picture_path'],
        creatorId: int.parse(json['creator_id'])
    );
  }
}