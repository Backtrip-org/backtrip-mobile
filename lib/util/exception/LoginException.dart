class EmailPasswordInvalidException implements Exception {
  String cause;

  EmailPasswordInvalidException() {
    this.cause = 'Votre email ou mot de passe est inccorect.';
  }
}

class UnexpectedLoginException implements Exception {
  String cause;

  UnexpectedLoginException() {
    this.cause = "Une erreur inattendue est survenue, veuillez contacter l'assistance.";
  }
}