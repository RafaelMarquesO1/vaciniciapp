import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Política de Privacidade',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  context,
                  'Coleta de Dados',
                  'Coletamos apenas os dados necessários para o funcionamento do sistema de vacinação, incluindo informações pessoais básicas e histórico de vacinação.',
                ),
                _buildSection(
                  context,
                  'Uso dos Dados',
                  'Seus dados são utilizados exclusivamente para gerenciar seu histórico de vacinação e agendar futuras vacinas.',
                ),
                _buildSection(
                  context,
                  'Segurança',
                  'Implementamos medidas de segurança rigorosas para proteger suas informações pessoais.',
                ),
                _buildSection(
                  context,
                  'Compartilhamento',
                  'Não compartilhamos seus dados com terceiros sem seu consentimento explícito.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }
}