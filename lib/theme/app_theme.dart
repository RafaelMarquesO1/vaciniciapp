import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF5A8B7B);
  static const Color primaryColorLight = Color(0xFFD9E4E0);
  static const Color accentColor = Color(0xFF4D7263);
  static const Color backgroundColor = Color(0xFFF8FAFA);
  
  // Cores de texto
  static const Color textColorPrimary = Color(0xFF2F4858);
  static const Color textColorSecondary = Color(0xFF8699A6);
  
  // Cores adicionais
  static const Color infoColor = Color(0xFF2196F3);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      background: backgroundColor,
      error: Colors.red,
    ),
    
    // Tipografia
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textColorPrimary, height: 1.2),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColorPrimary, height: 1.3),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColorPrimary, height: 1.3),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColorPrimary, height: 1.4),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textColorPrimary, height: 1.4),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColorPrimary, height: 1.4),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColorPrimary, height: 1.4),
        bodyLarge: TextStyle(fontSize: 16, color: textColorPrimary, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: textColorSecondary, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: textColorSecondary, height: 1.4),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColorPrimary),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColorSecondary),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColorSecondary),
      ),
    ),
    
    // Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Botões com contorno
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: textColorSecondary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: textColorSecondary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(color: textColorSecondary.withOpacity(0.7)),
      labelStyle: const TextStyle(color: textColorSecondary),
      floatingLabelStyle: const TextStyle(color: primaryColor),
    ),
    
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: textColorPrimary,
      titleTextStyle: TextStyle(
        color: textColorPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shadowColor: primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Dividers
    dividerTheme: DividerThemeData(
      color: textColorSecondary.withOpacity(0.2),
      thickness: 1,
      space: 1,
    ),
    
    // FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
  
  // Sombras personalizadas
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}