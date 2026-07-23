import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/deposit_page.dart';
import '../pages/developer_settings_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/qris_page.dart';
import '../pages/transfer_page.dart';
import '../widgets/app_bottom_navigation.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/home'),
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(path: '/home', pageBuilder: (_, state) => _fadePage(state, const HomePage())),
        GoRoute(path: '/transfer', pageBuilder: (_, state) => _fadePage(state, const TransferPage())),
        GoRoute(path: '/qris', pageBuilder: (_, state) => _fadePage(state, const QrisPage())),
        GoRoute(path: '/deposit', pageBuilder: (_, state) => _fadePage(state, const DepositPage())),
        GoRoute(path: '/profile', pageBuilder: (_, state) => _fadePage(state, const ProfilePage())),
      ],
    ),
    GoRoute(path: '/developer-settings', pageBuilder: (_, state) => _fadePage(state, const DeveloperSettingsPage())),
  ],
);

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic), child: child),
      transitionDuration: const Duration(milliseconds: 240),
    );

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: location.startsWith('/qris')
            ? null
            : SafeArea(
                top: false,
                child: AppBottomNavigation(location: location),
              ),
      );
}
