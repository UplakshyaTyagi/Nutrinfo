import 'package:flutter/material.dart';

extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get bgScreen => isDark ? Color(0xFF131313) : Color(0xFFF9F9F9);
  Color get bgCard => isDark ? Color(0xFF1C1B1B) : Color(0xFFFFFFFF);
  Color get bgHeader => isDark ? Color(0xFF0A0A0A) : Color(0xFFFFFFFF);
  Color get bgInput => isDark ? Color(0xFF2A2A2A) : Color(0xFFF5F5F5);

  // Glassmorphism overlays
  Color get glassOverlay => isDark
      ? Color(0xFF2A2A2A).withAlpha(153)
      : Color(0xFFFFFFFF).withAlpha(153);
  Color get glassCard => isDark
      ? Color(0xFF2A2A2A).withAlpha(102)
      : Color(0xFFFFFFFF).withAlpha(200);

  // Text
  Color get textPrimary => isDark ? Color(0xFFE5E2E1) : Color(0xFF111111);
  Color get textSecondary => isDark ? Color(0xFFB9CBB8) : Color(0xFF666666);
  Color get textMuted =>
      isDark ? Color(0xFFB9CBB8).withAlpha(128) : Color(0xFF999999);

  // Borders
  Color get borderWhite10 =>
      isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(25);
  Color get borderWhite20 =>
      isDark ? Colors.white.withAlpha(51) : Colors.black.withAlpha(51);

  // Highlights / Primary Accents (these work well on both dark and light, with minor tweaks)
  Color get accentMint => Color(0xFF00FF7F);
  Color get accentCyan => Color(0xFF00BFFF);
  Color get accentGold => Color(0xFFFFDF95);

  // Bottom Nav
  Color get navBackground => isDark ? Color(0xFF1A1A1A) : Color(0xFFFFFFFF);
  Color get navActive => accentMint;
  Color get navInactive => isDark ? Color(0xFF888888) : Color(0xFFBBBBBB);
}
