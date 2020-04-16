class EmailPasswordInvalidException implements Exception {
  String cause;

  EmailPasswordInvalidException() {
    this.cause = 'Votre email ou mot de passe est incorrect.';
  }
}

class UnexpectedLoginException implements Exception {
  String cause;

  UnexpectedLoginException() {
    this.cause = "Une erreur inattendue est survenue, veuillez contacter l'assistance.";
  }
}