import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../theme/app_theme.dart';

class MainShell extends StatelessWidget {
  MainShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _openScanner(BuildContext context) {
    context.push('/scanner');
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // 1. Render the active tab content
          navigationShell,

          // 2. The Premium Floating Glass Dock Overlay
          Positioned(
            bottom: 32.0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // --- Subtle Aura behind Camera Button ---
                  // Reference: bg-[#00FF7F]/20 blur-2xl => 20% mint with heavy blur
                  Positioned(
                    top: -48,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonMint.withAlpha(
                              51,
                            ), // 20% opacity
                            blurRadius: 48, // blur-2xl
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- The Frosted Glass Dock ---
                  // Reference: bg-[#121212]/70 backdrop-blur-2xl border-white/10
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        constraints: BoxConstraints(minWidth: 280),
                        decoration: BoxDecoration(
                          color: Color(
                            0xFF121212,
                          ).withAlpha(179), // 70% opacity
                          border: Border.all(
                            color: context.borderWhite10, // ~10% white
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Home Tab
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                navigationShell.currentIndex == 0
                                    ? PhosphorIconsFill.squaresFour
                                    : PhosphorIconsRegular.squaresFour,
                                size: 28,
                              ),
                              color: navigationShell.currentIndex == 0
                                  ? AppTheme.cyanAccent
                                  : Colors.white.withAlpha(102), // ~40%
                              onPressed: () => _onTap(0),
                            ),

                            // Gap spanning under the center camera
                            SizedBox(width: 80),

                            // History Tab
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                navigationShell.currentIndex == 1
                                    ? PhosphorIconsFill.clockCounterClockwise
                                    : PhosphorIconsRegular
                                          .clockCounterClockwise,
                                size: 28,
                              ),
                              color: navigationShell.currentIndex == 1
                                  ? AppTheme.cyanAccent
                                  : Colors.white.withAlpha(102),
                              onPressed: () => _onTap(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --- Central Camera Button ---
                  // Reference: from-[#00FF7F] to-[#00E471], border-4 border-[#121212]
                  // shadow-[0_8px_25px_rgba(0,255,127,0.4)]
                  Positioned(
                    top: -32,
                    child: GestureDetector(
                      onTap: () => _openScanner(context),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.accentMint, // neonMint
                              Color(
                                0xFF00E471,
                              ), // primary-fixed-dim (deep mint)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Color(0xFF121212),
                            width: 4.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonMint.withAlpha(
                                102,
                              ), // 40% opacity
                              blurRadius: 25,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          PhosphorIconsBold.camera,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
