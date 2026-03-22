import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary custom colors based on prompt rules
  static const Color background = Color(0xFF121212);
  static const Color neonMint = Color(0xFF00FF7F);
  static const Color cyanAccent = Color(0xFF00BFFF);
  static const Color surfaceGlass = Color(0x1FFFFFFF);

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
}
