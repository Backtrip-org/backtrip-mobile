class BadStepException implements Exception {
  String cause;

  BadStepException() {
    this.cause = "Les informations de l'étape sont mauvaises.";
  }
}