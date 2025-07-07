import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vaciniciapp/providers/theme_provider.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/routes/app_routes.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Vacinici',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.onboarding,
            routes: AppRoutes.routes,
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Página não encontrada')),
              ),
            ),
          );
        },
      ),
    );
  }
}