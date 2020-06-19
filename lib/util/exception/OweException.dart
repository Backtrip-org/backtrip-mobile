class OweException implements Exception {
  String cause;

  OweException() {
    this.cause = "Impossible de créer le remboursement.";
  }
}