import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? dotColor;
  final VoidCallback? onPress;

  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    this.dotColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary100 : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: selected ? AppShadows.raisedSm : AppShadows.raisedSm,
          border: selected
              ? Border.all(color: AppColors.primary400.withValues(alpha: 0.5), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary800 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
