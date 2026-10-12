import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class InfoNote extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoNote({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
