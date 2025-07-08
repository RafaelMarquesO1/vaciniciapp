import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showBorder;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppTheme.darkCardColor : Colors.white;
    final defaultElevation = isDark ? 8.0 : 4.0;
    
    Widget card = Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? defaultColor,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.4)
                : AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: elevation ?? defaultElevation,
            offset: Offset(0, (elevation ?? defaultElevation) / 2),
          ),
        ],
        border: showBorder
            ? Border.all(
                color: isDark
                    ? AppTheme.darkPrimaryColor.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.1),
                width: 1,
              )
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: card,
        ),
      );
    }

    return card;
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradientColors,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultGradient = isDark
        ? [AppTheme.darkCardColor, AppTheme.darkSurfaceColor]
        : [Colors.white, AppTheme.primaryColor.withOpacity(0.02)];

    Widget card = Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? defaultGradient,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : AppTheme.primaryColor.withOpacity(0.15),
            blurRadius: isDark ? 15 : 20,
            offset: Offset(0, isDark ? 6 : 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: card,
        ),
      );
    }

    return card;
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
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
            child: AdaptiveCard(
              padding: widget.padding,
              margin: widget.margin,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}