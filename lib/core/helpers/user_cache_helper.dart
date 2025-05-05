import 'package:shared_preferences/shared_preferences.dart';

class UserCacheHelper {
  static Future<void> saveUser({
    required String userId,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('email', email);
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'email': prefs.getString('email'),
    };
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
  }
}
