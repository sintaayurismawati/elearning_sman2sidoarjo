import 'package:elearning_sman2sidoarjo/core/enums/role_user_enum.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/guru/jadwal_mengajar/jadwal_mengajar_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/guru/kelas/detail_kelas_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/guru/kelas/kelas_guru_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/guru/nilai_siswa/nilai_akhir_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/guru/rubrik_mapel/rubrik_mapel_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/data_guru/data_guru_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/data_siswa/data_siswa_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/jadwal_akademik/jadwal_akademik_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/jadwal_pelajaran/jadwal_pelajaran_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/kelas/kelas_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/mata_pelajaran/mata_pelajaran_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/features/auth/screen/login_screen.dart';
import '../../presentation/features/init/splash_screen.dart';
import '../../presentation/features/landing_page/screens/landing_page.dart';
import '../../presentation/features/main_page.dart';
import '../helper/shared_pref_helper.dart';
import 'routes_name.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: _getInitialRoute(),

    /// =======================
    /// GLOBAL REDIRECT
    /// =======================
    redirect: (context, state) async {
      final roleString = await SharedPrefHelper.getRole();
      final role = roleString != null ? roleString.toUserRole() : null;

      final isLoggedIn = role != null;
      final isLoginPage = state.matchedLocation == RoutesNames.login;
      final isProtectedRoute = state.matchedLocation.startsWith('/main');

      /// ❌ Belum login tapi akses /main
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
      /// =======================
      /// PUBLIC ROUTES
      /// =======================
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
        builder: (context, state) {
          final roleUser = state.extra as UserRole;
          return LoginScreen(roleUser: roleUser);
        },
      ),

      /// =======================
      /// MAIN (PROTECTED)
      /// =======================
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          /// 🔥 HANDLE /main BIAR GAK KOSONG
          GoRoute(
            path: RoutesNames.main,
            redirect: (context, state) async {
              final roleString = await SharedPrefHelper.getRole();
              final role = roleString != null ? roleString.toUserRole() : null;

              if (role == UserRole.staff) return RoutesNames.dataGuru;
              if (role == UserRole.admin) return RoutesNames.dataSiswa;
              if (role == UserRole.guru) return RoutesNames.kelasGuru;
              if (role == UserRole.siswa) return RoutesNames.mataPelajaran;

              return RoutesNames.landing;
            },
          ),

          /// =======================
          /// STAFF
          /// =======================
          GoRoute(
            path: RoutesNames.dataGuru,
            builder: (context, state) => const DataGuruScreen(),
          ),
          GoRoute(
            path: RoutesNames.dataSiswa,
            builder: (context, state) => const DataSiswaScreen(),
          ),
          GoRoute(
            path: RoutesNames.jadwalAkademik,
            builder: (context, state) => const JadwalAkademikScreen(),
          ),
          GoRoute(
            path: RoutesNames.jadwalPelajaran,
            builder: (context, state) => const JadwalPelajaranScreen(),
          ),
          GoRoute(
            path: RoutesNames.kelas,
            builder: (context, state) => const KelasScreen(),
          ),
          GoRoute(
            path: RoutesNames.mataPelajaran,
            builder: (context, state) => const MataPelajaranScreen(),
          ),

          /// =======================
          /// GURU
          /// =======================
          GoRoute(
            path: RoutesNames.kelasGuru,
            builder: (context, state) => const KelasGuruScreen(),
          ),
          GoRoute(
            path: RoutesNames.detailKelas,
            builder: (context, state) => const DetailKelasScreen(),
          ),
          GoRoute(
            path: RoutesNames.jadwalMengajar,
            builder: (context, state) => const JadwalMengajarScreen(),
          ),
          GoRoute(
            path: RoutesNames.rubrikMapelKelas,
            builder: (context, state) => const RubrikMapelGuruScreen(),
          ),
          GoRoute(
            path: RoutesNames.nilaiAkhirKelas,
            builder: (context, state) => const NilaiAkhirKelasScreen(),
          ),
        ],
      ),
    ],
  );

  static String _getInitialRoute() {
    if (kIsWeb) {
      return '/';
    } else {
      return RoutesNames.splashScreen;
    }
  }
}
