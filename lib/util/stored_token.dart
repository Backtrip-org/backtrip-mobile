import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredToken {
  static final storage = new FlutterSecureStorage();

  static storeToken(token) {
    storage.write(key: 'token', value: token);
  }

  static Future<String> getToken() {
    return storage.read(key: 'token');
  }
}
