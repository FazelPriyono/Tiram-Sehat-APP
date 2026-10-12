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
    if (items.isEmpty) return const SizedBox.shrink();

    // Map index 0..items.length-1 to alignment -1.0 .. +1.0
    final alignX = items.length > 1
        ? -1.0 + (value.clamp(0, items.length - 1) / (items.length - 1)) * 2.0
        : 0.0;

    return NeuSurface(
      variant: NeuVariant.inset,
      radius: AppRadius.pill,
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / items.length;

          return SizedBox(
            height: 40,
            child: Stack(
              children: [
                // Sliding raised pill background
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment(alignX, 0.0),
                  child: Container(
                    width: tabWidth,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: AppShadows.raisedSm,
                    ),
                  ),
                ),
                // Text items on top
                Row(
                  children: List.generate(items.length, (i) {
                    final isActive = i == value;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChange(i),
                        child: SizedBox(
                          height: 40,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? AppColors.primary600
                                    : AppColors.textMuted,
                              ),
                              child: Text(items[i]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
