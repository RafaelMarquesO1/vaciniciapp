import 'package:flutter/material.dart';
import 'package:vaciniciapp/data/mock_data.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/widgets/theme_toggle_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

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
    final nurses = MockData.enfermeiros;

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
                padding: const EdgeInsets.fromLTRB(20, 45, 20, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _AnimatedVaccineIcon(),
                    const SizedBox(height: 6),
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
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
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                          : [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkCardShadow
                        : [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimaryColor.withOpacity(0.2)
                          : AppTheme.primaryColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar vacinas, agendamentos...',
                      hintStyle: TextStyle(
                        color: AppTheme.textColorSecondary.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.darkPrimaryColor
                              : AppTheme.primaryColor).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.darkPrimaryColor
                              : AppTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
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
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
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
                      icon: Icons.analytics_outlined,
                      label: 'Estatísticas',
                      color: const Color(0xFF2196F3),
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.statistics),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Seção de profissionais
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkPrimaryColor
                          : AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Profissionais de Saúde',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.professionals),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Lista horizontal de enfermeiros
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: nurses.length,
                    itemBuilder: (context, index) {
                      final nurse = nurses[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.professionalDetail,
                          arguments: nurse,
                        ),
                        child: _ProfessionalCard(
                          name: nurse.nomeCompleto,
                          role: nurse.cargo ?? 'Enfermeiro(a)',
                          isFirst: index == 0,
                        ),
                      );
                    },
                  ),
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
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
                      : [Colors.white, widget.color.withOpacity(0.02)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: Theme.of(context).brightness == Brightness.dark
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: widget.color.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                border: Border.all(
                  color: widget.color.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.1),
                          widget.color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(widget.icon, size: 28, color: widget.color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkCardColor
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkCardShadow
            : [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkPrimaryColor.withOpacity(0.2)
                : AppTheme.primaryColorLight,
            child: Icon(
              Icons.medical_services_outlined,
              size: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkPrimaryColor
                  : AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
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