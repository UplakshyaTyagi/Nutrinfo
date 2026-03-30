import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/main_shell/main_shell.dart';
import '../features/home/home_screen.dart';
import '../features/history/history_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/product_detail/product_detail_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/expert/expert_dashboard_screen.dart';
import '../features/reviews/reviews_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// GoRouter — splash → home, settings/expert/reviews are full-screen overlays.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      // Scanner — full-screen overlay
      GoRoute(
        path: '/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerScreen(),
      ),
      // Product detail
      GoRoute(
        path: '/product-detail/:productId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = state.pathParameters['productId'] ?? '';
          return ProductDetailScreen(productId: productId);
        },
      ),
      // Settings — full-screen overlay (accessed from top-right icon)
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      // Expert dashboard — accessed from Settings
      GoRoute(
        path: '/expert',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExpertDashboardScreen(),
      ),
      // Reviews — accessed from Settings
      GoRoute(
        path: '/reviews',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReviewsScreen(),
      ),
      // Main shell with 2 tabs: Home + History
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
