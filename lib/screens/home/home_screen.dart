import 'package:flutter/material.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/theme_toggle_button.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Map<String, dynamic>? currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar personalizada com ícone de vacina animado
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ThemeToggleButton(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 45, 20, 10),
                child: const Center(
                  child: _AnimatedVaccineIcon(),
                ),
              ),
            ),
          ),
          
          // Conteúdo principal
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Barra de pesquisa
                GradientCard(
                  borderRadius: BorderRadius.circular(20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar vacinas, agendamentos...',
                      hintStyle: TextStyle(
                        color: isDark ? AppTheme.darkTextColorTertiary : AppTheme.textColorSecondary.withOpacity(0.7),
                        fontSize: AppTheme.getResponsiveFontSize(context, 14),
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search,
                          color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Saudação personalizada
                if (currentUser != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [AppTheme.darkPrimaryColor.withOpacity(0.1), AppTheme.darkPrimaryColor.withOpacity(0.05)]
                            : [AppTheme.primaryColor.withOpacity(0.1), AppTheme.primaryColor.withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                          child: Text(
                            currentUser!['nomeCompleto']?.toString().substring(0, 1).toUpperCase() ?? 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${currentUser!['nomeCompleto']?.toString().split(' ').first ?? 'Usuário'}!',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentUser!['tipoUsuario'] == 'Funcionario' ? 'Funcionário' : 'Paciente',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Seção de ações rápidas
                Row(
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimaryColor
                          : AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ações Rápidas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Grid de categorias
                ResponsiveGrid(
                  childAspectRatio: context.isMobile ? 0.85 : 1.0,
                  children: [
                    _CategoryCard(
                      icon: Icons.vaccines_outlined,
                      label: 'Carteira',
                      color: AppTheme.primaryColor,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.vaccineCard),
                    ),
                    _CategoryCard(
                      icon: Icons.calendar_today_outlined,
                      label: 'Agendar',
                      color: const Color(0xFF4CAF50),
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.schedule),
                    ),
                    _CategoryCard(
                      icon: Icons.event_available_outlined,
                      label: 'Agendamentos',
                      color: const Color(0xFFFF9800),
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.appointments),
                    ),
                    _CategoryCard(
                      icon: Icons.analytics_outlined,
                      label: 'Estatísticas',
                      color: const Color(0xFF2196F3),
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.statistics),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Seção de acesso rápido
                Row(
                  children: [
                    Icon(
                      Icons.star_outline,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimaryColor
                          : AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Acesso Rápido',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Cards de acesso rápido
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.professionals),
                        child: AdaptiveCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Profissionais',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                        child: AdaptiveCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.settings_outlined,
                                  color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Configurações',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GradientCard(
              gradientColors: isDark
                  ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                  : [Colors.white, widget.color.withOpacity(0.02)],
              borderRadius: BorderRadius.circular(24),
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(context.isMobile ? 16 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.1),
                          widget.color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      widget.icon, 
                      size: context.isMobile ? 24 : 28, 
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AdaptiveText(
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isFirst;
  
  const _ProfessionalCard({
    required this.name,
    required this.role,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AdaptiveCard(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: context.isMobile ? 120 : 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: context.isMobile ? 16 : 20,
              backgroundColor: isDark
                  ? AppTheme.darkPrimaryColor.withOpacity(0.2)
                  : AppTheme.primaryColorLight,
              child: Icon(
                Icons.medical_services_outlined,
                size: context.isMobile ? 16 : 20,
                color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            AdaptiveText(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            AdaptiveText(
              role,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedVaccineIcon extends StatefulWidget {
  const _AnimatedVaccineIcon();

  @override
  State<_AnimatedVaccineIcon> createState() => _AnimatedVaccineIconState();
}

class _AnimatedVaccineIconState extends State<_AnimatedVaccineIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [
                          AppTheme.darkPrimaryColor.withOpacity(0.2),
                          AppTheme.darkPrimaryColor.withOpacity(0.1),
                        ]
                      : [
                          AppTheme.primaryColor.withOpacity(0.2),
                          AppTheme.primaryColor.withOpacity(0.1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkPrimaryColor
                        : AppTheme.primaryColor).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.vaccines,
                size: 24,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkPrimaryColor
                    : AppTheme.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}