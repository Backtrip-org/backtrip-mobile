import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {

  static download(String url, String filename, String extension) async {
    Directory directory = await getExternalStorageDirectory();
    File file = new File('${directory.path}/$filename.$extension');

    for (int num = 0; file.existsSync(); num++) {
      file = new File('${directory.path}/$filename($num).$extension');
    }

    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };

    await FlutterDownloader.enqueue(
        url: url,
        fileName: basename(file.path),
        savedDir: directory.path,
        showNotification: true,
        openFileFromNotification: true,
        headers: headers);
  }
}
