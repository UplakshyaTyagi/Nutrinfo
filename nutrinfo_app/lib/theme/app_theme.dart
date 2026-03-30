import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary custom colors based on prompt rules
  static const Color background = Color(0xFF121212);
  static const Color neonMint = Color(0xFF00FF7F);
  static const Color cyanAccent = Color(0xFF00BFFF);
  static const Color surfaceGlass = Color(0x1FFFFFFF);

  // Light mode palette
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1B);
  static const Color lightOnSurfaceVariant = Color(0xFF6B6B6B);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: neonMint,
      colorScheme: const ColorScheme.dark(
        primary: neonMint,
        secondary: cyanAccent,
        surface: surfaceGlass,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: lightBackground,
      primaryColor: neonMint,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00C060),
        secondary: Color(0xFF0090CC),
        surface: lightSurface,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
