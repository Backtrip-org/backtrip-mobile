import 'dart:io';
import 'dart:typed_data';

import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  static downloadToLocalDirectory(Uint8List bytes, String filename) async {
    String directory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    File file = new File('$directory/$filename.pdf');
    if (await Permission.storage.request().isGranted) {
      await file.writeAsBytes(bytes.toList());
    }
  }
}
