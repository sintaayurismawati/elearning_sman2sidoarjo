import 'package:elearning_sman2siadoarjo/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SMAN2ElearningApp());
}

class SMAN2ElearningApp extends StatelessWidget {
  const SMAN2ElearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Learning SMAN 2 Sidoarjo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
