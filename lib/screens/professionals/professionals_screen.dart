import 'package:flutter/material.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/services/api_service.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  List<dynamic> _professionals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    try {
      final users = await ApiService.getUsuarios();
      // Filtra apenas enfermeiros (masculino e feminino)
      final professionals = users.where((user) {
        final cargo = (user['cargo']?.toLowerCase() ?? '');
        return cargo == 'enfermeiro' || cargo == 'enfermeira';
      }).toList();
      setState(() {
        _professionals = professionals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profissionais de Saúde'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.primaryColor.withOpacity(0.08)
                          : AppTheme.primaryColorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Conheça nossa equipe de profissionais qualificados',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Nossa Equipe',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _professionals.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary).withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum profissional encontrado',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _professionals.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final professional = _professionals[index];
                            return _buildProfessionalCard(context, professional, isDark, theme);
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context,
    Map<String, dynamic> professional,
    bool isDark,
    ThemeData theme,
  ) {
    return AdaptiveCard(
      margin: EdgeInsets.zero,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.professionalDetail,
          arguments: professional,
        );
      },
      child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.primaryColorLight,
                  child: Text(
                    (professional['nomeCompleto'] ?? 'P').split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdaptiveText(
                      professional['nomeCompleto'] ?? 'Profissional',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AdaptiveText(
                      professional['cargo'] ?? 'Profissional de Saúde',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 4),
                        Text(
                          '4.9',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.textColorPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.vaccines_outlined, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          '1.2k vacinas',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.grey[300] : AppTheme.textColorSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppTheme.textColorSecondary,
              ),
            ],
          ),
    );
  }
}