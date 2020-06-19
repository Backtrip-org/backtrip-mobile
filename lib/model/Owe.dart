class Owe {
  int id;
  double cost;
  int userId;
  int expenseId;

  Owe({this.id, this.cost, this.userId, this.expenseId});

  factory Owe.fromJson(Map<String, dynamic> json) {
    return Owe(
        id: json['id'],
        cost: json['cost'],
        userId: json['userId'],
        expenseId: json['expenseId']
    );
  }
}