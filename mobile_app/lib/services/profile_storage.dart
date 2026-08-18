import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorage {
  static const String _key = 'fitback_profile_photo';

  static Future<String?> getPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> savePhoto(String base64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, base64);
  }

  static Future<void> removePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
