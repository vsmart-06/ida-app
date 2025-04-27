import "package:flutter_secure_storage/flutter_secure_storage.dart";

class SecureStorage {
  static final storage = FlutterSecureStorage();

  static Future<void> writeOne(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<void> writeMany(Map<String, String> pairs) async {
    for (String key in pairs.keys) {
      await storage.write(key: key, value: pairs[key]);
    }
  }

  static Future<dynamic> read([String? key]) async {
    if (key != null) return await storage.read(key: key);
    return await storage.readAll();
  }

  static Future<void> delete([String? key]) async {
    if (key != null) await storage.delete(key: key);
    else await storage.deleteAll();
  }
}