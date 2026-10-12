import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class StepItem {
  final String title;
  final String description;

  const StepItem({required this.title, required this.description});
}

class StepList extends StatelessWidget {
  final List<StepItem> steps;

  const StepList({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) => _StepRow(
        index: i + 1,
        step: steps[i],
        isLast: i == steps.length - 1,
      )),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final StepItem step;
  final bool isLast;

  const _StepRow({required this.index, required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
                boxShadow: AppShadows.raisedSm,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  step.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
