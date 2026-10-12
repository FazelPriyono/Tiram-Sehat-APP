import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'neu_surface.dart';

class NumericStepperField extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChange;
  final double step;
  final double min;
  final String unit;

  const NumericStepperField({
    super.key,
    required this.value,
    required this.onChange,
    this.step = 0.5,
    this.min = 0,
    this.unit = 'Kg',
  });

  String get _displayValue {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(1).replaceAll('.', ',');
    }
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.inset,
      radius: AppRadius.tile,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _displayValue,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  unit,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                onTap: () {
                  final next = (value - step).clamp(min, double.infinity);
                  if (next != value) {
                    HapticFeedback.lightImpact();
                    onChange(double.parse(next.toStringAsFixed(1)));
                  }
                },
              ),
              const SizedBox(width: AppSpacing.s2),
              _StepButton(
                icon: Icons.add_rounded,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onChange(double.parse((value + step).toStringAsFixed(1)));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          boxShadow: AppShadows.raisedSm,
        ),
        child: Icon(icon, color: AppColors.primary800, size: 22),
      ),
    );
  }
}
