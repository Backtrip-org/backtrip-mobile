import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredToken {
  static final storage = new FlutterSecureStorage();
  static final String tokenKey = 'token';

  static storeToken(token) {
    storage.write(key: tokenKey, value: token);
  }

  static delete() {
    storage.delete(key: tokenKey);
  }

  static Future<String> getToken() {
    return storage.read(key: tokenKey);
  }
}
