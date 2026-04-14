import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/features/auth/screen/login_screen.dart';
import '../../presentation/features/init/splash_screen.dart';
import '../../presentation/features/landing_page/screens/landing_page.dart';
import 'routes_name.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),
    routes: [
      GoRoute(
        path: RoutesNames.landing,
        builder: (context, state) => const ElearningLandingPage(),
      ),
      GoRoute(
        path: RoutesNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesNames.login,
        builder: (context, state) => const LoginScreen(),
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
