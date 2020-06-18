class File {
  String id;
  String name;
  String extension;
  String type;
  DateTime createdDate;

  File({this.id, this.name, this.extension, this.type, this.createdDate});

  bool isPhoto() {
    return type == 'FileType.Photo';
  }

  factory File.fromJson(dynamic json) {
    return File(
        id: json['id'],
        name: json['name'],
        extension: json['extension'],
        type: json['type'],
        createdDate: DateTime.tryParse(json['created_date'].toString())
    );
  }
}