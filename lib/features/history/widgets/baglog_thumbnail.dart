import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';

enum ThumbnailIndicatorType {
  warningDot,
  dangerTriangle,
  successDot,
}

/// Thumbnail baglog berukuran 56x56 dp yang bersih dan konsisten
/// dengan sistem desain TiramSehat (tanpa ornamen buatan/AI slop).
class BaglogThumbnail extends StatelessWidget {
  final ThumbnailIndicatorType indicatorType;

  const BaglogThumbnail({
    super.key,
    required this.indicatorType,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Widget indicatorWidget;

    switch (indicatorType) {
      case ThumbnailIndicatorType.dangerTriangle:
        badgeColor = AppColors.danger600;
        indicatorWidget = Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.danger600,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33D32F2F),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.priority_high_rounded,
            color: Colors.white,
            size: 11,
          ),
        );
      case ThumbnailIndicatorType.warningDot:
        badgeColor = AppColors.warning500;
        indicatorWidget = Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: AppColors.warning500,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33F59E0B),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        );
      case ThumbnailIndicatorType.successDot:
        badgeColor = AppColors.primary600;
        indicatorWidget = Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: AppColors.primary600,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332E7D32),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        );
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: AppShadows.raisedSm,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ikon baglog / media tanam bersih
          Icon(
            Icons.inventory_2_rounded,
            size: 24,
            color: AppColors.textMuted.withValues(alpha: 0.45),
          ),
          // Titik indikator status di pojok kanan-bawah
          Positioned(
            right: 5,
            bottom: 5,
            child: indicatorWidget,
          ),
        ],
      ),
    );
  }
}
