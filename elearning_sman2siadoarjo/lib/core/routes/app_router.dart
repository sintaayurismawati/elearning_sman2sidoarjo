import 'package:elearning_sman2sidoarjo/core/enums/role_user_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/features/auth/screen/login_screen.dart';
import '../../presentation/features/dashboard_page.dart';
import '../../presentation/features/init/splash_screen.dart';
import '../../presentation/features/kelas_page.dart';
import '../../presentation/features/landing_page/screens/landing_page.dart';
import '../../presentation/features/main_page.dart';
import '../../services/auth/auth_service.dart';
import 'routes_name.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),

    /// 🔥 TARUH DI SINI
    redirect: (context, state) async {
      final role = await SupabaseService.getCurrentUserRole();

      final isLoggedIn = role != null;
      final isLoginPage = state.matchedLocation == RoutesNames.login;
      // final isMainPage = state.matchedLocation == RoutesNames.main;
      final isProtectedRoute = state.matchedLocation.startsWith('/main');

      if (!isLoggedIn && isProtectedRoute) {
        return RoutesNames.landing;
      }


      /// ✅ Sudah login tapi masih di login page
      if (isLoggedIn && isLoginPage) {
        return RoutesNames.main;
      }

      return null;
    },
    routes: [
      // LANDING
      GoRoute(
        path: RoutesNames.landing,
        builder: (context, state) => const ElearningLandingPage(),
      ),
      // SPLASH
      GoRoute(
        path: RoutesNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      // LOGIN
      GoRoute(
        path: RoutesNames.login,
        builder: (context, state) {
          final roleUser = state.extra as UserRole; // ambil extra
          return LoginScreen(roleUser: roleUser);
        },
      ),
      ShellRoute(  builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          GoRoute(
            path: RoutesNames.main, // ✅ TAMBAH INI
            redirect: (_, __) => RoutesNames.dashboard, // auto ke dashboard
          ),
          GoRoute(
            path: RoutesNames.dashboard,
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: RoutesNames.kelas,
            builder: (context, state) => const KelasPage(),
          ),
        ],
      ),
    ],
  );

  static String _getInitialRoute() {
    if (kIsWeb) {
      return '/'; // WEB → Landing
    } else {
      return RoutesNames.splashScreen; // MOBILE → Splash
    }
  }
}
