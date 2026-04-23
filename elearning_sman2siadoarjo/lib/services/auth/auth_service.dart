// ignore_for_file: avoid_print

import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = SupabaseClient(
    dotenv.env['SUPABASE_URL'] ?? '',
    dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  /// Login dengan NIP/NUPTK/NISN dan password bcrypt
  static Future<Map<String, dynamic>?> loginWithIdentifier(
    String identifier,
    String password,
  ) async {
    try {
      final userRes = await client
          .from('users')
          .select()
          .eq('nip_nuptk_nisn', identifier)
          .filter('deleted_at', 'is', null)
          .maybeSingle();

      if (userRes == null) return null;

      final userId = userRes['id'].toString();
      final storedHash = userRes['password'] as String?;

      if (storedHash == null || !BCrypt.checkpw(password, storedHash)) {
        return null;
      }

      final userRole = userRes['role'];
      if (userRole == null) return null;

      final roles = [userRole.toString()];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      await prefs.setStringList(
        'user_roles',
        userRole is List<String> ? userRole : [userRole.toString()],
      );
      await prefs.setString('auth_token', 'local-login');

      // Simpan token FCM
      // await SupabaseService.saveFcmToken(userId);

      return {'user_id': userId, 'roles': roles};
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Ambil semua role user berdasarkan userId
  static Future<List<String>> getUserRoles(String userId) async {
    try {
      final userRes = await client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      final role = userRes?['role'];
      if (role == null) return [];

      return [role.toString()];
    } catch (e) {
      print('Get roles error: $e');
      return [];
    }
  }

  /// Ambil role utama (urutan pertama)
  static Future<String?> getPrimaryRole(String userId) async {
    final roles = await getUserRoles(userId);
    return roles.isNotEmpty ? roles.first : null;
  }

  /// Ambil role utama dari SharedPreferences
  static Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getStringList('user_roles');
    return (roles != null && roles.isNotEmpty) ? roles.first : null;
  }

  /// Ambil user ID dari SharedPreferences
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Logout user dan clear semua session lokal
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Simpan token FCM user ke kolom token di tabel users
  static Future<void> saveFcmToken(String userId) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) return;

      // Update token user
      await client.from('users').update({'token': fcmToken}).eq('id', userId);

      // Listen token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await client.from('users').update({'token': newToken}).eq('id', userId);
      });

      print('FCM token saved for user $userId: $fcmToken');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }
}
