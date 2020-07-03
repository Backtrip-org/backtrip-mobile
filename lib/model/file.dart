import 'package:intl/intl.dart';

class File {
  String id;
  String name;
  String extension;
  String type;
  DateTime createdDate;

  File({this.id, this.name, this.extension, this.type, this.createdDate});

  String getFileName() {
    return "$name.$extension";
  }

  String getFormattedCreationDate() {
    String formattedDate = new DateFormat('EEEE d MMMM y \à HH:mm', 'fr_FR').format(createdDate);
    return "Envoyé le ${formattedDate}";
  }

  bool isPhoto() {
    return type == 'FileType.Photo';
  }

  bool isDocument() {
    return type == 'FileType.Document';
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