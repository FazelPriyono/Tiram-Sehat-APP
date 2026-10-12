import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'neu_surface.dart';
import 'app_progress_bar.dart';

enum MetricSize { xl, lg, md }
enum MetricTileTone { defaultTone, success, warning, danger }

class MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final MetricTileTone tone;
  final double? progress;
  final IconData? icon;
  final NeuVariant variant;
  final MetricSize size;

  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.tone = MetricTileTone.defaultTone,
    this.progress,
    this.icon,
    this.variant = NeuVariant.raised,
    this.size = MetricSize.md,
  });

  Color get _valueColor {
    switch (tone) {
      case MetricTileTone.success:
        return AppColors.success600;
      case MetricTileTone.warning:
        return AppColors.warning500;
      case MetricTileTone.danger:
        return AppColors.danger600;
      case MetricTileTone.defaultTone:
        return AppColors.textPrimary;
    }
  }

  MetricTileTone get _progressTone => tone;

  double get _valueFontSize {
    switch (size) {
      case MetricSize.xl:
        return 40;
      case MetricSize.lg:
        return 28;
      case MetricSize.md:
        return 22;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: variant,
      radius: AppRadius.tile,
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: _iconColor),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: _valueFontSize,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: _valueColor,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: AppSpacing.s2),
            AppProgressBar(value: progress!, tone: _progressTone),
          ],
        ],
      ),
    );
  }

  Color get _iconBg {
    switch (tone) {
      case MetricTileTone.success:
        return AppColors.primary100;
      case MetricTileTone.warning:
        return AppColors.warning100;
      case MetricTileTone.danger:
        return AppColors.danger100;
      case MetricTileTone.defaultTone:
        return AppColors.primary100;
    }
  }

  Color get _iconColor {
    switch (tone) {
      case MetricTileTone.success:
        return AppColors.success600;
      case MetricTileTone.warning:
        return AppColors.warning500;
      case MetricTileTone.danger:
        return AppColors.danger600;
      case MetricTileTone.defaultTone:
        return AppColors.primary600;
    }
  }
}
