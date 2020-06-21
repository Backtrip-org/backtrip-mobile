class Reimbursement {
  int id;
  double cost;
  int emitterId;
  int payeeId;
  int tripId;
  int expenseId;

  Reimbursement({this.id, this.cost, this.emitterId, this.payeeId, this.tripId, this.expenseId});

  factory Reimbursement.fromJson(Map<String, dynamic> json) {
    return Reimbursement(
        id: json['id'],
        cost: json['cost'],
        emitterId: json['emitter_id'],
        payeeId: json['payee_id'],
        tripId: json['trip_id'],
        expenseId: json['expense_id']
    );
  }

  Map<String, dynamic> toJsonWithoutExpenseId() => {
    'cost': cost,
    'emitter_id': emitterId.toString(),
    'payee_id': payeeId.toString(),
    'trip_id': tripId.toString()
  };

  Map<String, dynamic> toJsonWithExpenseId() => {
    'cost': cost,
    'emitter_id': emitterId.toString(),
    'payee_id': payeeId.toString(),
    'expense_id': expenseId.toString(),
    'trip_id': tripId.toString()
  };
}