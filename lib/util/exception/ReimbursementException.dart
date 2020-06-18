class ReimbursementException implements Exception {
  String cause;

  ReimbursementException() {
    this.cause = "Impossible de créer le remboursement.";
  }
}