class Step {
  int id;
  String name;
  DateTime startDatetime;
  int tripId;

  Step({this.id, this.name, this.startDatetime, this.tripId});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
        id: json['id'],
        name: json['name'],
        startDatetime: DateTime.parse(json['start_datetime']),
        tripId: json['trip_id']);
  }
}
