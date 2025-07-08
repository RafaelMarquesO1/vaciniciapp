import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores principais - Tema Claro
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryColorLight = Color(0xFFE8F5E8);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Cores de texto - Tema Claro
  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color textColorTertiary = Color(0xFF9E9E9E);
  
  // Cores principais - Tema Escuro
  static const Color darkPrimaryColor = Color(0xFF4CAF50);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkElevatedColor = Color(0xFF2E2E2E);
  
  // Cores de texto - Tema Escuro
  static const Color darkTextColorPrimary = Color(0xFFFFFFFF);
  static const Color darkTextColorSecondary = Color(0xFFB0B0B0);
  static const Color darkTextColorTertiary = Color(0xFF808080);
  
  // Cores adicionais
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Breakpoints para responsividade
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Função para obter padding responsivo
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return const EdgeInsets.all(16);
    } else if (width < tabletBreakpoint) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }
  
  // Função para obter número de colunas responsivo
  static int getResponsiveColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 2;
    } else if (width < tabletBreakpoint) {
      return 3;
    } else {
      return 4;
    }
  }
  
  // Função para obter tamanho de fonte responsivo
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width < mobileBreakpoint ? 0.9 : width < tabletBreakpoint ? 1.0 : 1.1;
    return baseFontSize * scaleFactor;
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textColorPrimary,
      onBackground: textColorPrimary,
      onError: Colors.white,
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
        elevation: 3,
        shadowColor: primaryColor.withOpacity(0.3),
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
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
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
  
  // Tema escuro
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    primaryColor: darkPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimaryColor,
      brightness: Brightness.dark,
      primary: darkPrimaryColor,
      secondary: accentColor,
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      error: errorColor,
      onPrimary: darkBackgroundColor,
      onSecondary: darkBackgroundColor,
      onSurface: darkTextColorPrimary,
      onBackground: darkTextColorPrimary,
      onError: darkBackgroundColor,
    ),
    
    // Tipografia
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: darkTextColorPrimary, height: 1.2),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkTextColorPrimary, height: 1.3),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkTextColorPrimary, height: 1.3),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkTextColorPrimary, height: 1.4),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextColorPrimary, height: 1.4),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextColorPrimary, height: 1.4),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextColorPrimary, height: 1.4),
        bodyLarge: TextStyle(fontSize: 16, color: darkTextColorPrimary, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: darkTextColorSecondary, height: 1.5),
        bodySmall: TextStyle(fontSize: 12, color: darkTextColorSecondary, height: 1.4),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkTextColorPrimary),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: darkTextColorSecondary),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: darkTextColorTertiary),
      ),
    ),
    
    // Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: darkPrimaryColor.withOpacity(0.4),
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
        foregroundColor: darkPrimaryColor,
        side: const BorderSide(color: darkPrimaryColor, width: 1.5),
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
        foregroundColor: darkPrimaryColor,
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
      fillColor: darkElevatedColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: darkTextColorTertiary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: darkTextColorTertiary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      hintStyle: const TextStyle(color: darkTextColorTertiary),
      labelStyle: const TextStyle(color: darkTextColorSecondary),
      floatingLabelStyle: const TextStyle(color: darkPrimaryColor),
    ),
    
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: darkTextColorPrimary,
      titleTextStyle: TextStyle(
        color: darkTextColorPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkTextColorPrimary),
      actionsIconTheme: IconThemeData(color: darkTextColorPrimary),
    ),
    
    // Cards
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Dividers
    dividerTheme: const DividerThemeData(
      color: darkTextColorTertiary,
      thickness: 1,
      space: 1,
    ),
    
    // FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 8,
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
  
  static List<BoxShadow> get darkCardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 15,
      offset: const Offset(0, 6),
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