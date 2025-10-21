import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ajuda e Suporte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding,
        child: Column(
          children: [
            AdaptiveCard(
              child: Column(
                children: [
                  Icon(Icons.help_outline, size: 48, color: primaryColor),
                  const SizedBox(height: 16),
                  AdaptiveText(
                    'Como podemos ajudar?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AdaptiveText(
                    'Encontre respostas para suas dúvidas ou entre em contato conosco',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _HelpOption(
              icon: Icons.quiz_outlined,
              title: 'Perguntas Frequentes',
              subtitle: 'Respostas para dúvidas comuns',
              onTap: () => _showFAQ(context),
            ),
            const SizedBox(height: 12),
            _HelpOption(
              icon: Icons.phone_outlined,
              title: 'Contato por Telefone',
              subtitle: '0800 123 4567',
              onTap: () => _showContact(context, 'Telefone: 0800 123 4567'),
            ),
            const SizedBox(height: 12),
            _HelpOption(
              icon: Icons.email_outlined,
              title: 'Contato por E-mail',
              subtitle: 'suporte@vaciniciapp.com',
              onTap: () => _showContact(context, 'E-mail: suporte@vaciniciapp.com'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perguntas Frequentes'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FAQItem(
                question: 'Como agendar uma vacina?',
                answer: 'Acesse a aba "Agenda" e selecione "Novo Agendamento".',
              ),
              _FAQItem(
                question: 'Como ver meu histórico?',
                answer: 'Na tela inicial, toque em "Carteira".',
              ),
              _FAQItem(
                question: 'Por que não posso editar meu perfil?',
                answer: 'Por segurança, pacientes não podem alterar dados pessoais. Entre em contato com a administração.',
              ),
              _FAQItem(
                question: 'Como alterar minha senha?',
                answer: 'Apenas administradores podem alterar senhas. Entre em contato com a administração.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showContact(BuildContext context, String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(info)),
    );
  }
}

class _HelpOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return AdaptiveCard(
      onTap: onTap,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: AdaptiveText(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
          ),
        ),
        subtitle: AdaptiveText(
          subtitle,
          style: TextStyle(
            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(answer),
        ],
      ),
    );
  }
}