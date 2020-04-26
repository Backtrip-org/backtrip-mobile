class UserAlreadyExistsException implements Exception {
  String cause;

  UserAlreadyExistsException() {
    this.cause = "Un utilisateur existe déjà pour cette adresse mail.";
  }
}