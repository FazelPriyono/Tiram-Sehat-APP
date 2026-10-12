import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import 'metric_tile.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final MetricTileTone tone;

  const AppProgressBar({super.key, required this.value, this.tone = MetricTileTone.defaultTone});

  Color get _fillColor {
    switch (tone) {
      case MetricTileTone.success:
      case MetricTileTone.defaultTone:
        return AppColors.primary400;
      case MetricTileTone.warning:
        return AppColors.warning500;
      case MetricTileTone.danger:
        return AppColors.danger600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surfaceInset,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _fillColor,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
