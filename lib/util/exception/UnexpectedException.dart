class UnexpectedException implements Exception {
  String cause;

  UnexpectedException() {
    this.cause = "Une erreur inattendue est survenue, veuillez contacter l'assistance.";
  }
}