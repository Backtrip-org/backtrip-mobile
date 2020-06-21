class Expense {
  int id;
  double cost;
  int userId;
  int tripId;

  Expense({this.id, this.cost, this.userId, this.tripId});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json['id'],
        cost: json['cost'],
        userId: json['userId'],
        tripId: json['tripId']
    );
  }
}