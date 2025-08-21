import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/services/api_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String selectedVaccine = '';
  String selectedLocation = '';
  bool _isLoading = false;
  bool _isLoadingData = true;
  
  List<Map<String, dynamic>> vaccines = [];
  List<Map<String, dynamic>> locations = [];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final [vacinasData, locaisData] = await Future.wait([
        ApiService.getVacinas(),
        ApiService.getLocaisVacinacao(),
      ]);
      
      setState(() {
        vaccines = (vacinasData as List).map((v) => {
          'id': v['id'],
          'name': v['nome'],
          'icon': _getVaccineIcon(v['nome']),
          'color': _getVaccineColor(v['categoria']),
        }).toList();
        
        locations = (locaisData as List).map((l) => {
          'id': l['id'],
          'name': l['nome'],
          'address': '${l['endereco']}, ${l['cidade']}',
          'distance': '${(l['id'] * 0.5).toStringAsFixed(1)} km',
        }).toList();
        
        if (vaccines.isNotEmpty) selectedVaccine = vaccines.first['name'];
        if (locations.isNotEmpty) selectedLocation = locations.first['name'];
        
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() => _isLoadingData = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }
  
  IconData _getVaccineIcon(String nome) {
    if (nome.toLowerCase().contains('covid')) return Icons.coronavirus;
    if (nome.toLowerCase().contains('gripe') || nome.toLowerCase().contains('influenza')) return Icons.sick;
    if (nome.toLowerCase().contains('hepatite')) return Icons.health_and_safety;
    return Icons.vaccines;
  }
  
  Color _getVaccineColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'obrigatoria': return Colors.red;
      case 'opcional': return Colors.blue;
      case 'sazonal': return Colors.orange;
      default: return Colors.green;
    }
  }

  Future<void> _handleSchedule() async {
    if (selectedVaccine.isEmpty || selectedLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma vacina e um local')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final user = await ApiService.getCurrentUser();
      if (user == null) throw Exception('Usuário não encontrado');
      
      final selectedVaccineData = vaccines.firstWhere((v) => v['name'] == selectedVaccine);
      final selectedLocationData = locations.firstWhere((l) => l['name'] == selectedLocation);
      
      final agendamentoData = {
        'pacienteId': user['id'],
        'vacinaId': selectedVaccineData['id'],
        'localId': selectedLocationData['id'],
        'dataAgendamento': '${DateFormat('yyyy-MM-dd').format(selectedDate)}T${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00',
        'status': 'Agendado',
      };
      
      // Salvar agendamento na API
      await ApiService.createAgendamento(agendamentoData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Agendamento confirmado para ${DateFormat('dd/MM/yyyy', 'pt_BR').format(selectedDate)} às ${selectedTime.format(context)}',
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.darkPrimaryColor : Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao agendar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Vacina'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: context.responsivePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCard(
              gradientColors: [
                primaryColor.withOpacity(0.1),
                primaryColor.withOpacity(0.05),
              ],
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.schedule, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdaptiveText(
                          'Agendamento Rápido',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AdaptiveText(
                          'Escolha a vacina, local e horário ideal para você',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: primaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AdaptiveText(
              'Tipo de Vacina', 
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vaccines.length,
                itemBuilder: (context, index) {
                  final vaccine = vaccines[index];
                  final isSelected = vaccine['name'] == selectedVaccine;
                  return GestureDetector(
                    onTap: () => setState(() => selectedVaccine = vaccine['name']),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? primaryColor 
                            : (isDark ? AppTheme.darkCardColor : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected 
                              ? primaryColor 
                              : (isDark ? AppTheme.darkTextColorTertiary : AppTheme.primaryColorLight),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? primaryColor.withOpacity(0.3)
                                : (isDark ? Colors.black.withOpacity(0.3) : AppTheme.primaryColor.withOpacity(0.1)),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            vaccine['icon'],
                            color: isSelected ? Colors.white : vaccine['color'],
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          AdaptiveText(
                            vaccine['name'],
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : (isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            AdaptiveText(
              'Local de Atendimento', 
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...locations.map((location) {
              final isSelected = location['name'] == selectedLocation;
              return GestureDetector(
                onTap: () => setState(() => selectedLocation = location['name']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? primaryColor.withOpacity(0.1) 
                        : (isDark ? AppTheme.darkCardColor : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                          ? primaryColor 
                          : (isDark ? AppTheme.darkTextColorTertiary : AppTheme.primaryColorLight),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : AppTheme.primaryColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? primaryColor 
                              : (isDark ? AppTheme.darkPrimaryColor.withOpacity(0.2) : AppTheme.primaryColorLight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: isSelected 
                              ? Colors.white 
                              : (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdaptiveText(
                              location['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected 
                                    ? primaryColor 
                                    : (isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary),
                              ),
                            ),
                            const SizedBox(height: 4),
                            AdaptiveText(
                              location['address'],
                              style: TextStyle(
                                color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          location['distance'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveText(
                        'Data', 
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (date != null) setState(() => selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                                  : [Colors.white, AppTheme.primaryColor.withOpacity(0.02)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppTheme.darkTextColorTertiary : AppTheme.primaryColorLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : AppTheme.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today, color: primaryColor, size: 24),
                              const SizedBox(height: 8),
                              AdaptiveText(
                                DateFormat('dd/MM', 'pt_BR').format(selectedDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                ),
                              ),
                              AdaptiveText(
                                DateFormat('yyyy', 'pt_BR').format(selectedDate),
                                style: TextStyle(
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdaptiveText(
                        'Horário', 
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) setState(() => selectedTime = time);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                                  : [Colors.white, AppTheme.primaryColor.withOpacity(0.02)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppTheme.darkTextColorTertiary : AppTheme.primaryColorLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : AppTheme.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.access_time, color: primaryColor, size: 24),
                              const SizedBox(height: 8),
                              AdaptiveText(
                                selectedTime.format(context),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                                ),
                              ),
                              AdaptiveText(
                                'Toque para alterar',
                                style: TextStyle(
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSchedule,
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
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Confirmar Agendamento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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