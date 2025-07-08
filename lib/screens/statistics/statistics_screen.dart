import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: context.responsivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveText(
                  'Vacinômetro',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDark ? Colors.white : AppTheme.textColorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _GlassStatCard(
                        title: 'Aplicadas',
                        value: '3',
                        subtitle: 'Total de doses',
                        icon: Icons.vaccines,
                        color: primaryColor,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _GlassStatCard(
                        title: 'Cobertura',
                        value: '85%',
                        subtitle: 'Do calendário',
                        icon: Icons.shield,
                        color: Colors.green,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _GlassStatCard(
                  title: 'Próxima Vacina',
                  value: '15 dias',
                  subtitle: 'Gripe sazonal',
                  icon: Icons.schedule,
                  color: Colors.orange,
                  isDark: isDark,
                ),
                const SizedBox(height: 36),
                AdaptiveText(
                  'Vacinas por Categoria',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDark ? Colors.white : AppTheme.textColorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                _AnimatedCategoryBar(
                  name: 'COVID-19',
                  count: 2,
                  color: primaryColor,
                  percent: 0.66,
                  isDark: isDark,
                ),
                _AnimatedCategoryBar(
                  name: 'Gripe',
                  count: 1,
                  color: Colors.blue,
                  percent: 0.33,
                  isDark: isDark,
                ),
                _AnimatedCategoryBar(
                  name: 'Hepatite',
                  count: 0,
                  color: AppTheme.textColorSecondary,
                  percent: 0.0,
                  isDark: isDark,
                ),
                const SizedBox(height: 36),
                Center(
                  child: AdaptiveText(
                    'Mantenha sua carteira de vacinação sempre atualizada!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextColorSecondary
                              : AppTheme.textColorSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _GlassStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.45),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.12)
                : Colors.grey.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.18),
          width: 1.2,
        ),
        // Glass effect
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveText(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.textColorPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  AdaptiveText(
                    value,
                    style: TextStyle(
                      color: isDark ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  AdaptiveText(
                    subtitle,
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.darkTextColorSecondary
                          : AppTheme.textColorSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCategoryBar extends StatelessWidget {
  final String name;
  final int count;
  final Color color;
  final double percent;
  final bool isDark;

  const _AnimatedCategoryBar({
    required this.name,
    required this.count,
    required this.color,
    required this.percent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: AdaptiveCard(
        margin: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        showBorder: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      name,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppTheme.textColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          width: MediaQuery.of(context).size.width * percent * 0.5,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AdaptiveText(
                '$count doses',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}