import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/role_user_enum.dart';
import '../../../../services/auth/auth_service.dart';
import 'auth_state.dart';

/// =======================
/// CUBIT
/// =======================
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  /// =======================
  /// LOGIN
  /// =======================
  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());

    try {
      final result = await SupabaseService.loginWithIdentifier(
        identifier,
        password,
      );

      if (result == null) {
        emit(const AuthFailure("Login gagal, periksa kembali data"));
        return;
      }

      final roleString = result['roles'][0];

      /// 🔥 pakai extension kamu di enum
      final role = roleString.toString().toUserRole();

      emit(AuthAuthenticated(role));
    } catch (e) {
      emit(AuthFailure("Terjadi kesalahan: $e"));
    }
  }

  /// =======================
  /// AUTO LOGIN (SPLASH)
  /// =======================
  Future<void> checkAuth() async {
    emit(AuthLoading());

    try {
      final roleString = await SupabaseService.getCurrentUserRole();

      if (roleString == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final role = roleString.toUserRole();

      emit(AuthAuthenticated(role));
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// =======================
  /// LOGOUT
  /// =======================
  Future<void> logout() async {
    await SupabaseService.logout();
    emit(AuthUnauthenticated());
  }
}
