import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';
import 'neu_surface.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget children;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.s4),
          children,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final items = <Widget>[
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary800, size: 22),
      ),
      const SizedBox(width: AppSpacing.s3),
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    ];
    final t = trailing;
    if (t != null) items.add(t);
    return Row(children: items);
  }
}
