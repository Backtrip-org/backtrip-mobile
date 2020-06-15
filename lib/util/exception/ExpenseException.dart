class ExpenseException implements Exception {
  String cause;

  ExpenseException() {
    this.cause = "Impossible de créer la dépense.";
  }
}
