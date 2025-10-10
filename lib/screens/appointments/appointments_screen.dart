import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/services/api_service.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import '../cancelamento_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> agendamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgendamentos();
  }

  Future<void> _loadAgendamentos() async {
    try {
      final user = await ApiService.getCurrentUser();
      if (user != null) {
        final data = await ApiService.getAgendamentosByPaciente(user['id']);
        setState(() {
          agendamentos = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar agendamentos: $e')),
        );
      }
    }
  }

  void _navigateToCancelAppointment(Map<String, dynamic> agendamento) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CancelamentoScreen(agendamento: agendamento),
        ),
      ).then((result) {
        if (result == true) {
          _loadAgendamentos();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir tela de cancelamento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : agendamentos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 64, color: primaryColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum agendamento encontrado',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAgendamentos,
                  child: ListView.builder(
                    padding: context.responsivePadding,
                    itemCount: agendamentos.length,
                    itemBuilder: (context, index) {
                      final agendamento = agendamentos[index];
                      final dataAgendamento = DateTime.parse(agendamento['dataAgendamento']);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AdaptiveCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.vaccines, color: primaryColor, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            agendamento['nomeVacina'] ?? 'Vacina',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            agendamento['nomeLocal'] ?? 'Local',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        agendamento['status'] ?? 'Agendado',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: primaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('dd/MM/yyyy', 'pt_BR').format(dataAgendamento),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.access_time, size: 16, color: primaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('HH:mm', 'pt_BR').format(dataAgendamento),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Motivo do cancelamento
                                if (agendamento['status'] == 'Cancelado' && 
                                    agendamento['motivoCancelamento'] != null &&
                                    agendamento['motivoCancelamento'].toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Motivo do cancelamento:',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          agendamento['motivoCancelamento'].toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.red[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                // Botão de cancelar
                                if (agendamento['status'] == 'Agendado' || agendamento['status'] == 'Confirmado') ...[
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _navigateToCancelAppointment(agendamento),
                                      icon: Icon(Icons.cancel_outlined, color: Colors.red[600], size: 18),
                                      label: Text(
                                        'Cancelar Agendamento',
                                        style: TextStyle(
                                          color: Colors.red[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red.withOpacity(0.5)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}