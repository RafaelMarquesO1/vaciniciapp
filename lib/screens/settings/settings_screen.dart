import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notificações', style: Theme.of(context).textTheme.titleLarge),
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
          const SizedBox(height: 24),
          Text('Segurança', style: Theme.of(context).textTheme.titleLarge),
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
          const SizedBox(height: 24),
          Text('Dados', style: Theme.of(context).textTheme.titleLarge),
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
          const SizedBox(height: 24),
          Text('Sobre', style: Theme.of(context).textTheme.titleLarge),
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
            onTap: () {},
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(color: AppTheme.textColorSecondary)),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}