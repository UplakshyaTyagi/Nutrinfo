import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'core/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NutrinfoApp(),
    ),
  );
}

class NutrinfoApp extends ConsumerWidget {
  const NutrinfoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Nutrinfo',
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
