import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/services/api_service.dart';
import 'package:vaciniciapp/routes/app_routes.dart';

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
    final dataAgendamento = DateTime.parse(agendamento['dataAgendamento']);
    
    Navigator.pushNamed(
      context,
      AppRoutes.cancelAppointment,
      arguments: {
        'id': agendamento['id'],
        'vacina': agendamento['nomeVacina'],
        'data': DateFormat('dd/MM/yyyy', 'pt_BR').format(dataAgendamento),
        'horario': DateFormat('HH:mm', 'pt_BR').format(dataAgendamento),
        'local': agendamento['nomeLocal'],
        'status': agendamento['status'],
      },
    ).then((_) {
      // Recarregar agendamentos após cancelamento
      _loadAgendamentos();
    });
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
                                // Botão de cancelar (apenas para agendamentos futuros e com status "Agendado")
                                if (dataAgendamento.isAfter(DateTime.now()) && 
                                    (agendamento['status'] == 'Agendado' || agendamento['status'] == 'Confirmado'))
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red.withOpacity(0.5),
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () => _navigateToCancelAppointment(agendamento),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red[600],
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Cancelar Agendamento',
                                                  style: TextStyle(
                                                    color: Colors.red[600],
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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