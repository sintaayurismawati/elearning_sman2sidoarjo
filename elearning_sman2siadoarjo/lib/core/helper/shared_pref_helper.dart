import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String _keyRoleUser = 'role_user';

  /// 💾 Save role user
  static Future<void> saveRoleUser(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRoleUser, role);
  }

  /// 📥 Get role user
  static Future<String?> getRoleUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRoleUser);
  }

  /// 🗑️ Optional: clear role user
  static Future<void> clearRoleUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRoleUser);
  }
}
