import 'package:elearning_sman2sidoarjo/core/enums/role_user_enum.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/data_guru/data_guru_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/data_siswa/data_siswa_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/jadwal_akademik/jadwal_akademik_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/jadwal_pelajaran/jadwal_pelajaran_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/kelas/kelas_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/mata_pelajaran/mata_pelajaran_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/nilai_siswa/nilai_akhir_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/nilai_siswa/nilai_latsol_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/nilai_siswa/nilai_tugas_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/nilai_siswa/nilai_ujian_sumatif.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/nilai_siswa/sumatif_lingkup_materi.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/range_nilai_kategori/range_nilai_kategori_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/rubrik_mapel/rubrik_mapel_screen.dart';
import 'package:elearning_sman2sidoarjo/presentation/features/staff/tahun_ajaran/tahun_ajaran_screen.dart';
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

    /// 🔥 TARUH DI SINI
    redirect: (context, state) async {
      final role = await SharedPrefHelper.getRole();

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
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          // GoRoute(
          //   path: RoutesNames.main, // ✅ TAMBAH INI
          //   redirect: (_, _) => RoutesNames.dataGuru, // auto ke dashboard
          // ),
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
          GoRoute(
            path: RoutesNames.nilaiAkhir,
            builder: (context, state) => const NilaiAkhirScreen(),
          ),
          GoRoute(
            path: RoutesNames.nilaiLatsol,
            builder: (context, state) => const NilaiLatsolScreen(),
          ),
          GoRoute(
            path: RoutesNames.nilaiTugas,
            builder: (context, state) => const NilaiTugasScreen(),
          ),
          GoRoute(
            path: RoutesNames.nlaiUjianSumatif,
            builder: (context, state) => const NilaiUjianSumatifScreen(),
          ),
          GoRoute(
            path: RoutesNames.sumatifLingkupMateri,
            builder: (context, state) => const NilaiSumatifLMScreen(),
          ),
          GoRoute(
            path: RoutesNames.rangeNilaiKategori,
            builder: (context, state) => const RangeNilaiKategoriScreen(),
          ),
          GoRoute(
            path: RoutesNames.rubrikMapel,
            builder: (context, state) => const RubrikMapelScreen(),
          ),
          GoRoute(
            path: RoutesNames.tahunAjaran,
            builder: (context, state) => const TahunAjaranScreen(),
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
