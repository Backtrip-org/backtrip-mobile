class TripAlreadyExistsException implements Exception {
  String cause;

  TripAlreadyExistsException() {
    this.cause = "Un voyage avec le même nom existe déjà.";
  }
}