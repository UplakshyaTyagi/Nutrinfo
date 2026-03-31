import 'package:flutter/material.dart';
import 'package:nutrinfo_app/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary custom colors based on prompt rules
  static Color background = Color(0xFF121212);
  static Color neonMint = Color(0xFF00FF7F);
  static Color cyanAccent = Color(0xFF00BFFF);
  static Color surfaceGlass = Color(0x1FFFFFFF);

  // Light mode palette
  static Color lightBackground = Color(0xFFF5F5F5);
  static Color lightSurface = Color(0xFFFFFFFF);
  static Color lightOnSurface = Color(0xFF1E1E1E);
  static Color lightOnSurfaceVariant = Color(0xFF6B6B6B);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: neonMint,
      colorScheme: ColorScheme.dark(
        primary: neonMint,
        secondary: cyanAccent,
        surface: surfaceGlass,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
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
      colorScheme: ColorScheme.light(
        primary: Color(0xFF00C060),
        secondary: Color(0xFF0090CC),
        surface: lightSurface,
        onSurface: lightOnSurface,
        onSurfaceVariant: lightOnSurfaceVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
