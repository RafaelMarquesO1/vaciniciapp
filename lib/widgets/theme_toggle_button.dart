import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaciniciapp/providers/theme_provider.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: themeProvider.isDarkMode
                  ? [AppTheme.darkPrimaryColor.withOpacity(0.2), AppTheme.darkPrimaryColor.withOpacity(0.1)]
                  : [AppTheme.primaryColor.withOpacity(0.2), AppTheme.primaryColor.withOpacity(0.1)],
            ),
          ),
          child: IconButton(
            onPressed: () => themeProvider.toggleTheme(),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(themeProvider.isDarkMode),
                color: themeProvider.isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              ),
            ),
            tooltip: themeProvider.isDarkMode ? 'Tema Claro' : 'Tema Escuro',
          ),
        );
      },
    );
  }
}