class UserNotFoundException implements Exception {
  String cause;

  UserNotFoundException() {
    this.cause = "Aucun utilisateur trouvé pour cette adresse mail.";
  }
}