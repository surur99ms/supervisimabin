import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF4B2B), Color(0xFFFF416C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adminGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient categoryAdminGradient = LinearGradient(
    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient categoryPendataanGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient categoryKbmGradient = LinearGradient(
    colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status colors
  static const Color colorBaik = Color(0xFF2ECC71);
  static const Color colorSedang = Color(0xFFF39C12);
  static const Color colorBuruk = Color(0xFFE74C3C);
  static const Color colorBelum = Color(0xFFBDC3C7);

  static Color getStatusColor(String? status) {
    switch (status) {
      case 'Baik':
        return colorBaik;
      case 'Sedang':
        return colorSedang;
      case 'Buruk':
        return colorBuruk;
      default:
        return colorBelum;
    }
  }

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF416C),
      primary: const Color(0xFFFF416C),
      secondary: const Color(0xFF4FACFE),
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F6F9),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF2B2B2B)),
      titleTextStyle: TextStyle(
        color: Color(0xFF2B2B2B),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF416C),
      brightness: Brightness.dark,
      primary: const Color(0xFFFF416C),
      secondary: const Color(0xFF00F2FE),
      surface: const Color(0xFF1E222D),
    ),
    scaffoldBackgroundColor: const Color(0xFF131722),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
