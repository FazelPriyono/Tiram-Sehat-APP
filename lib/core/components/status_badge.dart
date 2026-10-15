import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

enum StatusTone { success, warning, danger, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool solid;

  const StatusBadge({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
    this.solid = false,
  });

  Color get _bg {
    if (solid) return _solidBg;
    switch (tone) {
      case StatusTone.success: return AppColors.success100;
      case StatusTone.warning: return AppColors.warning100;
      case StatusTone.danger: return AppColors.danger100;
      case StatusTone.info: return AppColors.primary100;
      case StatusTone.neutral: return AppColors.surfaceInset;
    }
  }

  Color get _solidBg {
    switch (tone) {
      case StatusTone.success: return AppColors.success600;
      case StatusTone.warning: return AppColors.warning500;
      case StatusTone.danger: return AppColors.danger600;
      case StatusTone.info: return AppColors.primary600;
      case StatusTone.neutral: return AppColors.textSecondary;
    }
  }

  Color get _textColor {
    if (solid) return AppColors.textOnPrimary;
    switch (tone) {
      case StatusTone.success: return AppColors.success600;
      case StatusTone.warning: return AppColors.warning500;
      case StatusTone.danger: return AppColors.danger600;
      case StatusTone.info: return AppColors.primary800;
      case StatusTone.neutral: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: _textColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
