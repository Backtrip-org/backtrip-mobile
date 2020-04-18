class Trip {
  String name;
  String picturePath;
  int creatorId;

  Trip({this.name, this.picturePath, this.creatorId});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        name: json['name'],
        picturePath: json['picture_path'],
        creatorId: json['creator_id']
    );
  }
}