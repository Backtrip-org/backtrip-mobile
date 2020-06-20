class OperationException implements Exception {
  String cause;

  OperationException() {
    this.cause = "Impossible de récupérer les opérations.";
  }
}