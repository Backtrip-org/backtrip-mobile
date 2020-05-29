class Document {
  int id;
  String name;
  String extension;
  DateTime createdDate;


  Document({this.id, this.name, this.extension, this.createdDate});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      extension: json['extension'],
      createdDate: json['createdDate']
    );
  }
}