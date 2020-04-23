class EmailPasswordInvalidException implements Exception {
  String cause;

  EmailPasswordInvalidException() {
    this.cause = 'Votre email ou mot de passe est incorrect.';
  }
}

class InvalidTokenException implements Exception {
  String cause;

  InvalidTokenException() {
    this.cause = 'Token invalide.';
  }
}