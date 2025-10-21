import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup dos Dados'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AdaptiveCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 64,
                      color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Backup Automático',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seus dados são automaticamente salvos na nuvem para garantir segurança.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Backup realizado com sucesso!')),
                        );
                      },
                      child: const Text('Fazer Backup Agora'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}