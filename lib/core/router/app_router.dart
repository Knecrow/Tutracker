import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_student/add_student_sheet.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';
import '../../presentation/screens/history/history_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/widgets/floating_nav_sheet.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => const NoTransitionPage(child: AnalyticsScreen()),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => const NoTransitionPage(child: HistoryScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/add-student',
      pageBuilder: (context, state) => const ModalBottomSheetPage(
        child: AddStudentSheet(),
      ),
    ),
  ],
);

/// Custom modal bottom sheet page for go_router
class ModalBottomSheetPage<T> extends Page<T> {
  const ModalBottomSheetPage({required this.child});
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }
}
