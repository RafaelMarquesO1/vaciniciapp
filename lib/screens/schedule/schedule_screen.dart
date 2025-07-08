import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String selectedVaccine = 'COVID-19';
  String selectedLocation = 'UBS Centro';
  bool _isLoading = false;

  final List<Map<String, dynamic>> vaccines = [
    {'name': 'COVID-19', 'icon': Icons.coronavirus, 'color': Colors.red},
    {'name': 'Gripe', 'icon': Icons.sick, 'color': Colors.orange},
    {'name': 'Hepatite B', 'icon': Icons.health_and_safety, 'color': Colors.green},
    {'name': 'Tétano', 'icon': Icons.medical_services, 'color': Colors.blue},
  ];
  
  final List<Map<String, dynamic>> locations = [
    {'name': 'UBS Centro', 'address': 'Rua das Flores, 123', 'distance': '0.5 km'},
    {'name': 'UBS Norte', 'address': 'Av. Principal, 456', 'distance': '1.2 km'},
    {'name': 'UBS Sul', 'address': 'Rua do Sul, 789', 'distance': '2.1 km'},
    {'name': 'Hospital Municipal', 'address': 'Praça Central, 100', 'distance': '3.0 km'},
  ];

  Future<void> _handleSchedule() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    
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
    setState(() => _isLoading = false);
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
      body: SingleChildScrollView(
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