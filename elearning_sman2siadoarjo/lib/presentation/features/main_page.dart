import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/role_user_enum.dart';
import '../../core/routes/routes_name.dart';
import '../../services/auth/auth_service.dart';
import 'auth/cubit/auth_cubit.dart';


class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UserRole? role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final roleString = await SupabaseService.getCurrentUserRole();

    if (roleString != null) {
      setState(() {
        role = roleString.toUserRole();
      });
    }
  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Apakah ingin logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Tidak"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Ya"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width > 900;

    if (role == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final confirm = await _showExitDialog();
        if (confirm) {
          context.read<AuthCubit>().logout();
          context.go(RoutesNames.landing);
        }
      },
      child: Scaffold(
        appBar: isDesktop ? null : AppBar(title: const Text("E-Learning")),

        drawer: isDesktop ? null : Drawer(child: _buildSidebar()),

        body: Row(
          children: [
            if (isDesktop)
              Container(
                width: 250,
                color: Colors.white,
                child: _buildSidebar(),
              ),

            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// SIDEBAR
  /// =======================
  Widget _buildSidebar() {
    final menus = _getMenusByRole(role!);

    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(role!.name.toUpperCase()),
          accountEmail: const Text("user@email.com"),
          currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
        ),

        ...menus.map((menu) {
          return ListTile(
            leading: Icon(menu.icon),
            title: Text(menu.title),
            onTap: () => context.go(menu.route),
          );
        }),

        const Spacer(),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout"),
          onTap: () async {
            context.read<AuthCubit>().logout();
            context.go(RoutesNames.landing);
          },
        ),
      ],
    );
  }

  List<_Menu> _getMenusByRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return [
          _Menu("Dashboard", Icons.dashboard, RoutesNames.dashboard),
          _Menu("Manajemen User", Icons.people, "/main/dashboard"),
        ];

      case UserRole.staff:
        return [_Menu("Dashboard", Icons.dashboard, "/main/dashboard")];

      case UserRole.guru:
        return [
          _Menu("Dashboard", Icons.dashboard, RoutesNames.dashboard),
          _Menu("Kelas", Icons.menu_book, RoutesNames.kelas),
        ];

      case UserRole.siswa:
        return [
          _Menu("Dashboard", Icons.dashboard, "/main/dashboard"),
          _Menu("Kelas", Icons.menu_book, "/main/kelas"),
        ];
    }
  }
}

class _Menu {
  final String title;
  final IconData icon;
  final String route;

  _Menu(this.title, this.icon, this.route);
}
