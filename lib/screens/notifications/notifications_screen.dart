import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushNotifications = true;
  bool vaccineReminders = true;
  bool appointmentReminders = true;
  bool systemUpdates = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding,
        child: Column(
          children: [
            // Header
            AdaptiveCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configurar Notificações',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Personalize suas notificações',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notification Settings
            AdaptiveCard(
              child: Column(
                children: [
                  _NotificationTile(
                    title: 'Notificações Push',
                    subtitle: 'Receber notificações do aplicativo',
                    value: pushNotifications,
                    onChanged: (value) => setState(() => pushNotifications = value),
                    icon: Icons.notifications,
                  ),
                  const Divider(height: 1),
                  _NotificationTile(
                    title: 'Lembretes de Vacina',
                    subtitle: 'Lembrar sobre próximas vacinas',
                    value: vaccineReminders,
                    onChanged: (value) => setState(() => vaccineReminders = value),
                    icon: Icons.vaccines,
                  ),
                  const Divider(height: 1),
                  _NotificationTile(
                    title: 'Lembretes de Consulta',
                    subtitle: 'Lembrar sobre agendamentos',
                    value: appointmentReminders,
                    onChanged: (value) => setState(() => appointmentReminders = value),
                    icon: Icons.event,
                  ),
                  const Divider(height: 1),
                  _NotificationTile(
                    title: 'Atualizações do Sistema',
                    subtitle: 'Novidades e atualizações',
                    value: systemUpdates,
                    onChanged: (value) => setState(() => systemUpdates = value),
                    icon: Icons.system_update,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Card
            AdaptiveCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Sobre as Notificações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'As notificações ajudam você a manter sua carteira de vacinação em dia. Você pode desativar qualquer tipo de notificação a qualquer momento.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                      ),
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

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return ListTile(
      leading: Icon(
        icon,
        color: primaryColor,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }
}