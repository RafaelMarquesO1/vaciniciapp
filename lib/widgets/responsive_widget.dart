import 'package:flutter/material.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= AppTheme.desktopBreakpoint && desktop != null) {
      return desktop!;
    } else if (width >= AppTheme.tabletBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(context, constraints),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = AppTheme.getResponsiveColumns(context);
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      childAspectRatio: childAspectRatio ?? 1.0,
      children: children,
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? customPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: customPadding ?? AppTheme.getResponsivePadding(context),
      child: child,
    );
  }
}

class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AdaptiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final adaptiveFontSize = AppTheme.getResponsiveFontSize(
      context, 
      baseStyle.fontSize ?? 14,
    );

    return Text(
      text,
      style: baseStyle.copyWith(fontSize: adaptiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

extension ResponsiveExtensions on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < AppTheme.mobileBreakpoint;
  bool get isTablet => MediaQuery.of(this).size.width >= AppTheme.mobileBreakpoint && 
                      MediaQuery.of(this).size.width < AppTheme.desktopBreakpoint;
  bool get isDesktop => MediaQuery.of(this).size.width >= AppTheme.desktopBreakpoint;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  EdgeInsets get responsivePadding => AppTheme.getResponsivePadding(this);
  int get responsiveColumns => AppTheme.getResponsiveColumns(this);
}