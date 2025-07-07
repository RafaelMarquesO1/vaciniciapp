import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vaciniciapp/theme/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? AppTheme.darkCardColor : Colors.grey.shade300,
      highlightColor: isDark ? AppTheme.darkSurfaceColor : Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardColor : Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkCardShadow
            : AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          const ShimmerLoading(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoading(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                ShimmerLoading(width: MediaQuery.of(context).size.width * 0.4, height: 12),
                const SizedBox(height: 8),
                ShimmerLoading(width: MediaQuery.of(context).size.width * 0.3, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}