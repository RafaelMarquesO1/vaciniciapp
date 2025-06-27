import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/routes/app_routes.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vacinici',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.onboarding,
      routes: AppRoutes.routes,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Página não encontrada')),
        ),
      ),
    );
  }
}