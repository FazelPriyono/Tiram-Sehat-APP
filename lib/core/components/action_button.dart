import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

enum ActionVariant { primary, secondary, danger, warning }

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ActionVariant variant;
  final bool fullWidth;
  final VoidCallback? onPress;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    this.variant = ActionVariant.primary,
    this.fullWidth = false,
    this.onPress,
  });

  Color get _bg {
    switch (variant) {
      case ActionVariant.primary: return AppColors.primary800;
      case ActionVariant.secondary: return AppColors.surface;
      case ActionVariant.danger: return AppColors.surface;
      case ActionVariant.warning: return AppColors.surface;
    }
  }

  Color get _textColor {
    switch (variant) {
      case ActionVariant.primary: return AppColors.textOnPrimary;
      case ActionVariant.secondary: return AppColors.primary800;
      case ActionVariant.danger: return AppColors.danger600;
      case ActionVariant.warning: return AppColors.warning500;
    }
  }

  List<BoxShadow> get _shadows {
    switch (variant) {
      case ActionVariant.primary: return AppShadows.buttonPrimary;
      case ActionVariant.secondary:
      case ActionVariant.danger:
      case ActionVariant.warning:
        return AppShadows.raisedSm;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: _textColor, size: 18),
          const SizedBox(width: AppSpacing.s2),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: fullWidth ? double.infinity : null,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: _shadows,
        ),
        child: Center(child: content),
      ),
    );
  }
}
