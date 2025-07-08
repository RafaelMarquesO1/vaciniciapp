import 'package:flutter/material.dart';
import 'package:vaciniciapp/models/usuario.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ProfessionalDetailScreen extends StatelessWidget {
  const ProfessionalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Usuario professional = ModalRoute.of(context)!.settings.arguments as Usuario;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Detalhes do Profissional',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Gradiente de fundo no topo
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(isDark ? 0.5 : 0.7),
                  theme.scaffoldBackgroundColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar com sombra
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                        child: Text(
                          professional.nomeCompleto.split(' ').map((e) => e[0]).take(2).join(),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      professional.nomeCompleto,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        professional.cargo ?? 'Profissional de Saúde',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Estatísticas em destaque
                    _buildStatsSection(isDark, primaryColor),

                    const SizedBox(height: 24),

                    // Informações pessoais
                    _buildInfoSection(
                      context,
                      'Informações Pessoais',
                      [
                        _buildInfoItem(context, Icons.badge_outlined, 'CPF', professional.cpf),
                        if (professional.email != null)
                          _buildInfoItem(context, Icons.email_outlined, 'E-mail', professional.email!),
                        if (professional.telefone != null)
                          _buildInfoItem(context, Icons.phone_outlined, 'Telefone', professional.telefone!),
                      ],
                      isDark,
                    ),

                    const SizedBox(height: 20),

                    // Informações profissionais
                    _buildInfoSection(
                      context,
                      'Informações Profissionais',
                      [
                        _buildInfoItem(context, Icons.work_outline, 'Cargo', professional.cargo ?? 'Não informado'),
                        _buildInfoItem(context, Icons.business_outlined, 'Setor', 'Vacinação'),
                        _buildInfoItem(context, Icons.schedule_outlined, 'Horário', '08:00 - 17:00'),
                        _buildInfoItem(context, Icons.location_on_outlined, 'Local', 'UBS Centro'),
                      ],
                      isDark,
                    ),

                    const SizedBox(height: 32),

                    // Botão de contato
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showContactDialog(context, professional, primaryColor, isDark);
                        },
                        icon: const Icon(Icons.message_outlined, size: 24),
                        label: const Text(
                          'Entrar em Contato',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> items, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : AppTheme.textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : AppTheme.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard('Vacinas', '1.247', Icons.vaccines_outlined, Colors.blue, isDark),
              const SizedBox(width: 12),
              _buildStatCard('Pacientes', '892', Icons.people_outline, Colors.green, isDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Avaliação', '4.9', Icons.star_outline, Colors.amber[800]!, isDark),
              const SizedBox(width: 12),
              _buildStatCard('Experiência', '8 anos', Icons.work_history_outlined, Colors.purple, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color iconColor, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(isDark ? 0.18 : 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[300] : AppTheme.textColorSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context, Usuario professional, Color primaryColor, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Contatar ${professional.nomeCompleto}',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: primaryColor),
              title: const Text('Telefone'),
              subtitle: Text(professional.telefone ?? 'Não disponível'),
              onTap: professional.telefone != null ? () {
                Navigator.pop(context);
              } : null,
            ),
            ListTile(
              leading: Icon(Icons.email, color: primaryColor),
              title: const Text('E-mail'),
              subtitle: Text(professional.email ?? 'Não disponível'),
              onTap: professional.email != null ? () {
                Navigator.pop(context);
              } : null,
            ),
            ListTile(
              leading: Icon(Icons.message, color: primaryColor),
              title: const Text('Mensagem'),
              subtitle: const Text('Enviar mensagem interna'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }
}