import 'package:flutter/material.dart';
import 'package:vaciniciapp/screens/home/home_screen.dart';
import 'package:vaciniciapp/theme/app_theme.dart';
import 'package:vaciniciapp/data/mock_data.dart';
import 'package:vaciniciapp/routes/app_routes.dart';
import 'package:vaciniciapp/widgets/adaptive_card.dart';
import 'package:vaciniciapp/widgets/responsive_widget.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeScreen(),
          const _ScheduleScreen(),
          const _ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardColor : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Início',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _NavBarItem(
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_today,
                  label: 'Agenda',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _NavBarItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Perfil',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: widget.isSelected
              ? LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.15),
                    primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(25),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isSelected ? _scaleAnimation.value : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: widget.isSelected
                        ? BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    child: Icon(
                      widget.isSelected ? widget.activeIcon : widget.icon,
                      color: widget.isSelected
                          ? primaryColor
                          : (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
                      size: 24,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: widget.isSelected
                    ? primaryColor
                    : (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary),
                fontSize: 11,
                fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleScreen extends StatelessWidget {
  const _ScheduleScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 80,
              color: (isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary).withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            AdaptiveText(
              'Agendamentos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            AdaptiveText(
              'Gerencie seus agendamentos de vacinação',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.schedule);
              },
              icon: const Icon(Icons.add),
              label: const Text('Novo Agendamento'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do App'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = MockData.loggedInUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsivePadding(
          child: Column(
            children: [
            const SizedBox(height: 20),
            AdaptiveCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isDark ? AppTheme.darkPrimaryColor.withOpacity(0.2) : AppTheme.primaryColorLight,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AdaptiveText(
                    user.nomeCompleto,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AdaptiveText(
                    'CPF: ${user.cpf}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AdaptiveCard(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                title: AdaptiveText(
                  'Editar Perfil',
                  style: TextStyle(
                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AdaptiveCard(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.vaccineCard),
              child: ListTile(
                leading: Icon(
                  Icons.vaccines,
                  color: isDark ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
                ),
                title: AdaptiveText(
                  'Carteira de Vacinação',
                  style: TextStyle(
                    color: isDark ? AppTheme.darkTextColorPrimary : AppTheme.textColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AdaptiveCard(
              onTap: () => _showLogoutDialog(context),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const AdaptiveText(
                  'Sair do App',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppTheme.darkTextColorSecondary : AppTheme.textColorSecondary,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}