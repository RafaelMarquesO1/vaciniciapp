import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedVaccine = 'COVID-19';
  String selectedLocation = 'UBS Centro';

  final List<String> vaccines = ['COVID-19', 'Gripe', 'Hepatite B', 'Tétano'];
  final List<String> locations = ['UBS Centro', 'UBS Norte', 'UBS Sul', 'Hospital Municipal'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Vacina'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColorLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Agende sua vacina com antecedência para garantir sua dose',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tipo de Vacina', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColorLight),
              ),
              child: DropdownButton<String>(
                value: selectedVaccine,
                isExpanded: true,
                underline: const SizedBox(),
                items: vaccines.map((vaccine) {
                  return DropdownMenuItem(value: vaccine, child: Text(vaccine));
                }).toList(),
                onChanged: (value) => setState(() => selectedVaccine = value!),
              ),
            ),
            const SizedBox(height: 20),
            Text('Local', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColorLight),
              ),
              child: DropdownButton<String>(
                value: selectedLocation,
                isExpanded: true,
                underline: const SizedBox(),
                items: locations.map((location) {
                  return DropdownMenuItem(value: location, child: Text(location));
                }).toList(),
                onChanged: (value) => setState(() => selectedLocation = value!),
              ),
            ),
            const SizedBox(height: 20),
            Text('Data', style: Theme.of(context).textTheme.titleMedium),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColorLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Horário', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: selectedTime);
                if (time != null) setState(() => selectedTime = time);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColorLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Text('${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Agendamento realizado com sucesso!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Confirmar Agendamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}