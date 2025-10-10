import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CancelamentoScreen extends StatefulWidget {
  final Map<String, dynamic> agendamento;

  const CancelamentoScreen({Key? key, required this.agendamento}) : super(key: key);

  @override
  _CancelamentoScreenState createState() => _CancelamentoScreenState();
}

class _CancelamentoScreenState extends State<CancelamentoScreen> {
  String? motivoSelecionado;
  final TextEditingController _motivoController = TextEditingController();
  bool _isLoading = false;

  final List<String> motivosPredefinidos = [
    'Não posso comparecer no horário agendado',
    'Problemas de saúde no momento',
    'Viagem ou compromisso inadiável',
    'Já tomei esta vacina em outro local',
    'Médico recomendou adiar a vacinação',
    'Problemas de transporte',
    'Mudança de endereço',
    'Outro motivo (especificar abaixo)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Cancelar Agendamento'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do Agendamento
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColorLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event_note, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Dados do Agendamento',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Vacina: ${widget.agendamento['nomeVacina'] ?? 'N/A'}',
                    style: TextStyle(color: AppTheme.textColorPrimary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data: ${_formatDateTime(widget.agendamento['dataAgendamento'])}',
                    style: TextStyle(color: AppTheme.textColorPrimary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Local: ${widget.agendamento['nomeLocal'] ?? 'N/A'}',
                    style: TextStyle(color: AppTheme.textColorPrimary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Pergunta
            Text(
              'Por que você deseja cancelar este agendamento?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de Motivos
            ...motivosPredefinidos.map((motivo) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: motivoSelecionado == motivo 
                    ? AppTheme.primaryColor 
                    : AppTheme.textColorSecondary.withOpacity(0.3),
                  width: motivoSelecionado == motivo ? 2 : 1,
                ),
                color: motivoSelecionado == motivo 
                  ? AppTheme.primaryColorLight 
                  : Colors.white,
              ),
              child: RadioListTile<String>(
                title: Text(
                  motivo,
                  style: TextStyle(
                    fontSize: 14,
                    color: motivoSelecionado == motivo 
                      ? AppTheme.primaryColor 
                      : AppTheme.textColorPrimary,
                    fontWeight: motivoSelecionado == motivo 
                      ? FontWeight.w600 
                      : FontWeight.normal,
                  ),
                ),
                value: motivo,
                groupValue: motivoSelecionado,
                onChanged: (value) {
                  setState(() {
                    motivoSelecionado = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            )).toList(),
            
            // Campo de texto personalizado
            if (motivoSelecionado == 'Outro motivo (especificar abaixo)') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: TextField(
                  controller: _motivoController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Especifique o motivo',
                    labelStyle: TextStyle(color: AppTheme.primaryColor),
                    hintText: 'Descreva o motivo do cancelamento...',
                    hintStyle: TextStyle(color: AppTheme.textColorSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: AppTheme.primaryColorLight.withOpacity(0.3),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppTheme.textColorSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: AppTheme.textColorSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmarCancelamento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
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
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Confirmar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

  void _confirmarCancelamento() async {
    if (motivoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione um motivo para o cancelamento.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    String motivoFinal = motivoSelecionado!;
    if (motivoSelecionado == 'Outro motivo (especificar abaixo)') {
      if (_motivoController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor, especifique o motivo do cancelamento.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      motivoFinal = _motivoController.text.trim();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/agendamentos/${widget.agendamento['id']}/status'),
        headers: await ApiService.authHeaders,
        body: jsonEncode({
          'status': 'Cancelado',
          'motivoCancelamento': motivoFinal,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao cancelar agendamento');
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Agendamento cancelado com sucesso!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cancelar agendamento: $e'),
            backgroundColor: AppTheme.errorColor,
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

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }
}