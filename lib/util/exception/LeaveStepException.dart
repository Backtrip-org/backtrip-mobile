class LeaveStepException implements Exception {
  String cause;

  LeaveStepException() {
    this.cause = "Impossible de quitter l\'étape";
  }
}