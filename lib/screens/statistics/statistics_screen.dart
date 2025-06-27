import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vacinômetro', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            _StatCard(
              title: 'Vacinas Aplicadas',
              value: '3',
              subtitle: 'Total de doses',
              icon: Icons.vaccines,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: 'Próxima Vacina',
              value: '15 dias',
              subtitle: 'Gripe sazonal',
              icon: Icons.schedule,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: 'Cobertura Vacinal',
              value: '85%',
              subtitle: 'Do calendário básico',
              icon: Icons.shield,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text('Vacinas por Categoria', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _CategoryItem('COVID-19', 2, AppTheme.primaryColor),
            _CategoryItem('Gripe', 1, Colors.blue),
            _CategoryItem('Hepatite', 0, AppTheme.textColorSecondary),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final int count;
  final Color color;

  const _CategoryItem(this.name, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColorLight),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(name)),
          Text('$count doses', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}