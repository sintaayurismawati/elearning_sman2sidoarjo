import 'package:go_router/go_router.dart';
import 'package:elearning_sman2siadoarjo/core/routes/routes_name.dart';
import 'package:elearning_sman2siadoarjo/presentation/features/auth/screen/login_screen.dart';
import 'package:elearning_sman2siadoarjo/presentation/features/landing_page/screens/landing_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutesNames.landing,
    routes: [
      GoRoute(
        path: RoutesNames.landing,
        builder: (context, state) => const ElearningLandingPage(),
      ),
      GoRoute(
        path: RoutesNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
