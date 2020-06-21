class Operation {
  int emitterId;
  int payeeId;
  double amount;

  Operation({this.emitterId, this.payeeId, this.amount});

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
        emitterId: json['emitter_id'],
        payeeId: json['payee_id'],
        amount: json['amount']
    );
  }
}