import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaciniciapp/data/mock_data.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/animated_fab.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';

class VaccineCardScreen extends StatefulWidget {
  const VaccineCardScreen({super.key});

  @override
  State<VaccineCardScreen> createState() => _VaccineCardScreenState();
}

class _VaccineCardScreenState extends State<VaccineCardScreen> {
  String _selectedFilter = 'Todas';
  final List<String> _filters = ['Todas', 'Recentes', 'Antigas'];

  List<dynamic> get _filteredVaccines {
    final vaccines = MockData.historicoDeVacinas;
    switch (_selectedFilter) {
      case 'Recentes':
        return vaccines.where((v) => 
          DateTime.now().difference(v.dataAplicacao).inDays <= 365
        ).toList();
      case 'Antigas':
        return vaccines.where((v) => 
          DateTime.now().difference(v.dataAplicacao).inDays > 365
        ).toList();
      default:
        return vaccines;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vaccines = _filteredVaccines;
    final user = MockData.loggedInUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar personalizada
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            foregroundColor: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Carteira de Vacinação',
                style: TextStyle(
                  color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppTheme.darkSurfaceColor, AppTheme.darkBackgroundColor]
                        : [AppTheme.primaryColorLight, AppTheme.backgroundColor],
                  ),
                ),
              ),
            ),
          ),
          
          // Header com informações do usuário
          SliverToBoxAdapter(
            child: AdaptiveCard(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              showBorder: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.darkPrimaryColor.withOpacity(0.2)
                          : AppTheme.primaryColorLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.person,
                      color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdaptiveText(
                          user.nomeCompleto,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AdaptiveText(
                          'CPF: ${user.cpf}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AdaptiveText(
                            '${vaccines.length} vacinas aplicadas',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Filtros
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                            : (isDark ? AppTheme.darkCardColor : Colors.white),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected 
                              ? (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor)
                              : (isDark ? AppTheme.darkTextColorTertiary : Theme.of(context).dividerColor),
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
                      child: AdaptiveText(
                        filter,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : (isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          
          // Lista de vacinas
          vaccines.isEmpty
              ? SliverToBoxAdapter(
                  child: AdaptiveCard(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.vaccines_outlined,
                          size: 64,
                          color: (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary).withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        AdaptiveText(
                          'Nenhuma vacina encontrada',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final vaccine = vaccines[index];
                        return _VaccineCard(
                          vaccine: vaccine,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.vaccineDetail,
                              arguments: vaccine,
                            );
                          },
                        );
                      },
                      childCount: vaccines.length,
                    ),
                  ),
                ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      
      // Botão flutuante para download
      floatingActionButton: vaccines.isNotEmpty
          ? AnimatedFab(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Download iniciado!'),
                      ],
                    ),
                    backgroundColor: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              icon: Icons.download_rounded,
              label: 'Baixar PDF',
            )
          : null,
    );
  }
}

class _VaccineCard extends StatefulWidget {
  final dynamic vaccine;
  final VoidCallback onTap;

  const _VaccineCard({
    required this.vaccine,
    required this.onTap,
  });

  @override
  State<_VaccineCard> createState() => _VaccineCardState();
}

class _VaccineCardState extends State<_VaccineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.02, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: GradientCard(
              margin: const EdgeInsets.only(bottom: 16),
              gradientColors: isDark
                  ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                  : [Colors.white, AppTheme.primaryColor.withOpacity(0.01)],
              borderRadius: BorderRadius.circular(24),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.vaccines_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdaptiveText(
                            widget.vaccine.nomeVacina,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: AdaptiveText(
                              widget.vaccine.dose,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AdaptiveText(
                                DateFormat('dd/MM/yyyy', 'pt_BR').format(widget.vaccine.dataAplicacao),
                                style: TextStyle(
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: primaryColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}