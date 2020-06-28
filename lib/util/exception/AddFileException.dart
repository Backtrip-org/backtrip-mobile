class AddFileException implements Exception {
  String cause;

  AddFileException() {
    this.cause = 'File to upload not found. Please add a body parameter named `file` containing the file to upload.';
  }
}