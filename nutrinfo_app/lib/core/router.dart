import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/main_shell/main_shell.dart';
import '../features/home/home_screen.dart';
import '../features/history/history_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/scanner/scanner_screen.dart';
import '../features/product_detail/product_detail_screen.dart';
import '../features/expert/expert_dashboard_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// GoRouter — no auth guard, starts directly at /home.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      // Scanner — full-screen overlay above the shell
      GoRoute(
        path: '/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerScreen(),
      ),
      // Product detail — full-screen overlay with product ID
      GoRoute(
        path: '/product-detail/:productId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = state.pathParameters['productId'] ?? '';
          return ProductDetailScreen(productId: productId);
        },
      ),
      // Expert dashboard
      GoRoute(
        path: '/expert',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExpertDashboardScreen(),
      ),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
