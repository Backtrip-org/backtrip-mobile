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

class BannedUserException implements Exception {
  String cause;

  BannedUserException() {
    this.cause = 'Vous avez été banni.';
  }
}