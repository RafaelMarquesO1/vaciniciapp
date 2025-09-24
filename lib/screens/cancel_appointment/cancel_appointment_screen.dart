import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/services/api_service.dart';

class CancelAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;
  
  const CancelAppointmentScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<CancelAppointmentScreen> createState() => _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  String? _selectedReason;
  bool _isLoading = false;
  
  final List<Map<String, String>> _cancellationReasons = [
    {
      'value': 'mudanca_plano',
      'label': 'Mudança de planos'
    },
    {
      'value': 'problema_saude',
      'label': 'Problema de saúde'
    },
    {
      'value': 'conflito_horario',
      'label': 'Conflito de horário'
    },
    {
      'value': 'nao_possivel_comparecer',
      'label': 'Não será possível comparecer'
    },
    {
      'value': 'ja_vacinado',
      'label': 'Já foi vacinado em outro local'
    },
    {
      'value': 'medo_agulha',
      'label': 'Medo de agulha'
    },
    {
      'value': 'reacao_anterior',
      'label': 'Reação adversa anterior'
    },
    {
      'value': 'outro',
      'label': 'Outro motivo'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelar Agendamento'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [AppTheme.darkBackgroundColor, AppTheme.darkSurfaceColor]
                : [AppTheme.backgroundColor, Colors.white],
          ),
        ),
        child: SafeArea(
          child: ResponsiveBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > AppTheme.mobileBreakpoint;
              
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWideScreen ? 500 : double.infinity,
                  ),
                  child: SingleChildScrollView(
                    padding: context.responsivePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Informações do agendamento
                        GradientCard(
                          gradientColors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                          ],
                          borderRadius: BorderRadius.circular(16),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.event,
                                    color: primaryColor,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AdaptiveText(
                                          'Detalhes do Agendamento',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AdaptiveText(
                                          widget.appointment['vacina'] ?? 'Vacina não especificada',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        AdaptiveText(
                                          'Data: ${widget.appointment['data'] ?? 'Data não especificada'}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                          ),
                                        ),
                                        AdaptiveText(
                                          'Horário: ${widget.appointment['horario'] ?? 'Horário não especificado'}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                          ),
                                        ),
                                        AdaptiveText(
                                          'Local: ${widget.appointment['local'] ?? 'Local não especificado'}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Título da seleção de motivo
                        AdaptiveText(
                          'Selecione o motivo do cancelamento:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Lista de motivos
                        ..._cancellationReasons.map((reason) => 
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: RadioListTile<String>(
                              value: reason['value']!,
                              groupValue: _selectedReason,
                              onChanged: (value) {
                                setState(() {
                                  _selectedReason = value;
                                });
                              },
                              title: AdaptiveText(
                                reason['label']!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                ),
                              ),
                              activeColor: primaryColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: _selectedReason == reason['value'] 
                                      ? primaryColor 
                                      : (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              tileColor: _selectedReason == reason['value'] 
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                          ),
                        ).toList(),
                        
                        const SizedBox(height: 32),
                        
                        // Botão de cancelar
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red[600]!,
                                Colors.red[500]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _selectedReason != null && !_isLoading 
                                ? _handleCancelAppointment 
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Confirmar Cancelamento',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Botão de voltar
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Voltar',
                              style: TextStyle(
                                color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleCancelAppointment() async {
    if (_selectedReason == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Chamar API para cancelar agendamento
      await ApiService.cancelAgendamento(
        widget.appointment['id'], 
        _selectedReason!
      );
      
      if (mounted) {
        // Mostrar confirmação
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Agendamento Cancelado'),
            content: Text(
              'Seu agendamento foi cancelado com sucesso.\n\n'
              'Motivo: ${_cancellationReasons.firstWhere((r) => r['value'] == _selectedReason)['label']}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar dialog
                  Navigator.of(context).pop(); // Voltar para tela anterior
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cancelar agendamento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
