import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaciniciapp/providers/theme_provider.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/screens/backup/backup_screen.dart';
import 'package:vaciniciapp/screens/export/export_screen.dart';
import 'package:vaciniciapp/screens/privacy/privacy_screen.dart';
import 'package:vaciniciapp/screens/change_password/change_password_screen.dart';
import 'package:vaciniciapp/screens/notifications/notifications_screen.dart';
import 'package:vaciniciapp/services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool reminderEnabled = true;
  bool biometricEnabled = false;
  Map<String, dynamic>? currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() => _isLoadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoadingUser) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ResponsivePadding(
        child: ListView(
          children: [
            // Header com ícone
            GradientCard(
              gradientColors: [
                (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.1),
                (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.05),
              ],
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdaptiveText(
                          'Personalizar App',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AdaptiveText(
                          'Configure o app do seu jeito',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.8),
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
            title: 'Configurar Notificações',
            subtitle: 'Gerenciar todas as notificações',
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          _SettingsTile(
            title: 'Lembretes de Vacina',
            subtitle: 'Lembrar sobre próximas vacinas',
            trailing: Switch(
              value: reminderEnabled,
              onChanged: (value) => setState(() => reminderEnabled = value),
              activeColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          _SectionHeader(
            icon: Icons.security_outlined,
            title: 'Segurança',
            subtitle: 'Proteja sua conta',
          ),
          const SizedBox(height: 16),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _SettingsTile(
                title: 'Tema Escuro',
                subtitle: 'Alternar entre tema claro e escuro',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                  activeColor: themeProvider.isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
              );
            },
          ),
          if (currentUser?['tipoUsuario'] != 'Paciente') 
            _SettingsTile(
              title: 'Alterar Senha',
              subtitle: 'Modificar senha de acesso',
              trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
          _SettingsTile(
            title: 'Autenticação Biométrica',
            subtitle: 'Usar digital ou Face ID',
            trailing: Switch(
              value: biometricEnabled,
              onChanged: (value) => setState(() => biometricEnabled = value),
              activeColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
            ),
          ),

          // Remover botão de contato com enfermeiro
          const SizedBox(height: 32),

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
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BackupScreen())),
          ),
          _SettingsTile(
            title: 'Exportar Dados',
            subtitle: 'Baixar seus dados em PDF',
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportScreen())),
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
            subtitle: '11.0', // Versão do App
            trailing: const SizedBox(),
          ),
          _SettingsTile(
            title: 'Termos de Uso',
            subtitle: 'Ler termos e condições',
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.terms),
          ),
          _SettingsTile(
            title: 'Política de Privacidade',
            subtitle: 'Como tratamos seus dados',
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen())),
          ),
          _SettingsTile(
            title: 'Ajuda e Suporte',
            subtitle: 'Central de ajuda e contato',
            trailing: Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.help),
          ),
          ],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdaptiveText(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AdaptiveText(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AdaptiveCard(
      margin: const EdgeInsets.only(bottom: 12),
      showBorder: true,
      onTap: onTap,
      child: ListTile(
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
            fontSize: 13,
          ),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
      ),
    );
  }
}