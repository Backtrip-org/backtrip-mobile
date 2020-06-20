class Reimbursement {
  int id;
  double cost;
  int userId;
  int expenseId;

  Reimbursement({this.id, this.cost, this.userId, this.expenseId});

  factory Reimbursement.fromJson(Map<String, dynamic> json) {
    return Reimbursement(
        id: json['id'],
        cost: json['cost'],
        userId: json['userId'],
        expenseId: json['expenseId']
    );
  }
}