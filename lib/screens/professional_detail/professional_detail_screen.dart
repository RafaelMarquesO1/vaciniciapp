import 'package:flutter/material.dart';
import 'package:vaciniciapp/models/usuario.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ProfessionalDetailScreen extends StatelessWidget {
  const ProfessionalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Usuario professional = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Profissional'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto e informações básicas
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      professional.nomeCompleto.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    professional.nomeCompleto,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      professional.cargo ?? 'Profissional de Saúde',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Informações pessoais
            _buildInfoSection(
              'Informações Pessoais',
              [
                _buildInfoItem(Icons.badge_outlined, 'CPF', professional.cpf),
                if (professional.email != null)
                  _buildInfoItem(Icons.email_outlined, 'E-mail', professional.email!),
                if (professional.telefone != null)
                  _buildInfoItem(Icons.phone_outlined, 'Telefone', professional.telefone!),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Informações profissionais
            _buildInfoSection(
              'Informações Profissionais',
              [
                _buildInfoItem(Icons.work_outline, 'Cargo', professional.cargo ?? 'Não informado'),
                _buildInfoItem(Icons.business_outlined, 'Setor', 'Vacinação'),
                _buildInfoItem(Icons.schedule_outlined, 'Horário', '08:00 - 17:00'),
                _buildInfoItem(Icons.location_on_outlined, 'Local', 'UBS Centro'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Estatísticas
            _buildStatsSection(),
            
            const SizedBox(height: 32),
            
            // Botão de contato
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showContactDialog(context, professional);
                },
                icon: const Icon(Icons.message_outlined),
                label: const Text('Entrar em Contato'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textColorPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Vacinas Aplicadas', '1.247', Icons.vaccines_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Pacientes Atendidos', '892', Icons.people_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Avaliação', '4.9', Icons.star_outline),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Anos de Experiência', '8', Icons.work_history_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textColorSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, Usuario professional) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contatar ${professional.nomeCompleto}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
              title: const Text('Telefone'),
              subtitle: Text(professional.telefone ?? 'Não disponível'),
              onTap: professional.telefone != null ? () {
                Navigator.pop(context);
              } : null,
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppTheme.primaryColor),
              title: const Text('E-mail'),
              subtitle: Text(professional.email ?? 'Não disponível'),
              onTap: professional.email != null ? () {
                Navigator.pop(context);
              } : null,
            ),
            ListTile(
              leading: const Icon(Icons.message, color: AppTheme.primaryColor),
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
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}