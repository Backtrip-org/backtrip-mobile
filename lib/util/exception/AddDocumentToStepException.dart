class AddDocumentToStepException implements Exception {
  String cause;

  AddDocumentToStepException() {
    this.cause = 'File to upload not found. Please add a body parameter named `file` containing the file to upload.';
  }
}