import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'neu_surface.dart';

class SegmentedTabs extends StatelessWidget {
  final List<String> items;
  final int value;
  final ValueChanged<int> onChange;

  const SegmentedTabs({
    super.key,
    required this.items,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.inset,
      radius: AppRadius.pill,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = i == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChange(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: isActive ? AppShadows.raisedSm : null,
                ),
                child: Center(
                  child: Text(
                    items[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColors.primary600 : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
