class Expense {
  int id;
  String name;
  double cost;
  int userId;
  int tripId;

  Expense({this.id, this.name, this.cost, this.userId, this.tripId});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json['id'],
        name: json['name'],
        cost: json['cost'],
        userId: json['user_id'],
        tripId: json['trip_id']
    );
  }
}