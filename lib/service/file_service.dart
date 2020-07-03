import 'dart:io';
import 'dart:typed_data';
import 'package:backtrip/util/constants.dart';
import 'package:backtrip/util/exception/UnexpectedException.dart';
import 'package:http/http.dart' as http;
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/stored_token.dart';

class FileService {
  static Future<Uint8List> get(String fileId) async {
    var uri = '${BacktripApi.path}/file/download/$fileId';
    var header = <String, String>{
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response =
        await http.get(uri, headers: header).timeout(Constants.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return response.bodyBytes;
    } else {
      throw new UnexpectedException();
    }
  }
}
