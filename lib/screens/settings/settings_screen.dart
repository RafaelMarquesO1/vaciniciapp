import 'package:flutter/material.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool reminderEnabled = true;
  bool biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header com ícone
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personalizar App',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Configure o app do seu jeito',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            subtitle: 'Gerencie suas notificações',
          ),
          const SizedBox(height: 16),
          _SettingsTile(
            title: 'Notificações Push',
            subtitle: 'Receber notificações do app',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) => setState(() => notificationsEnabled = value),
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _SettingsTile(
            title: 'Lembretes de Vacina',
            subtitle: 'Lembrar sobre próximas vacinas',
            trailing: Switch(
              value: reminderEnabled,
              onChanged: (value) => setState(() => reminderEnabled = value),
              activeColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.security_outlined,
            title: 'Segurança',
            subtitle: 'Proteja sua conta',
          ),
          const SizedBox(height: 16),
          _SettingsTile(
            title: 'Autenticação Biométrica',
            subtitle: 'Usar digital ou Face ID',
            trailing: Switch(
              value: biometricEnabled,
              onChanged: (value) => setState(() => biometricEnabled = value),
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _SettingsTile(
            title: 'Alterar Senha',
            subtitle: 'Modificar sua senha de acesso',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.people_outline,
            title: 'Equipe Médica',
            subtitle: 'Conheça nossos profissionais',
          ),
          const SizedBox(height: 16),
          _SettingsTile(
            title: 'Profissionais de Saúde',
            subtitle: 'Ver equipe médica disponível',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.professionals),
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.cloud_outlined,
            title: 'Dados e Backup',
            subtitle: 'Gerencie seus dados',
          ),
          const SizedBox(height: 16),
          _SettingsTile(
            title: 'Backup dos Dados',
            subtitle: 'Fazer backup na nuvem',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () {},
          ),
          _SettingsTile(
            title: 'Exportar Dados',
            subtitle: 'Baixar seus dados em PDF',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.info_outline,
            title: 'Sobre o App',
            subtitle: 'Informações e suporte',
          ),
          const SizedBox(height: 16),
          _SettingsTile(
            title: 'Versão do App',
            subtitle: '1.0.0',
            trailing: const SizedBox(),
          ),
          _SettingsTile(
            title: 'Termos de Uso',
            subtitle: 'Ler termos e condições',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.terms),
          ),
          _SettingsTile(
            title: 'Política de Privacidade',
            subtitle: 'Como tratamos seus dados',
            trailing: const Icon(Icons.chevron_right, color: AppTheme.textColorSecondary),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColorSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textColorPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppTheme.textColorSecondary,
            fontSize: 13,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
      ),
    );
  }
}