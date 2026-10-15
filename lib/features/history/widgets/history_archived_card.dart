import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/components/neu_surface.dart';
import '../../../core/components/status_badge.dart';
import '../../../mock/mock_data.dart';

/// Kartu ringkas untuk bagian Riwayat Terarsip (Tersanitasi / Telah Dibuang)
class HistoryArchivedCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback? onTap;

  const HistoryArchivedCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDanger = item.badge == 'Telah Dibuang';
    final iconColor = isDanger ? AppColors.danger600 : AppColors.warning500;
    final iconData = isDanger
        ? Icons.delete_outline_rounded
        : Icons.coronavirus_outlined;
    final badgeTone = isDanger ? StatusTone.danger : StatusTone.warning;

    return GestureDetector(
      onTap: onTap,
      child: NeuSurface(
        variant: NeuVariant.raised,
        radius: AppRadius.card,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          children: [
            // Ikon Squircle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppShadows.raisedSm,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            // Teks & Lokasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        label: item.badge,
                        tone: badgeTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.rack} • Kolom ${item.col} • ${item.when}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Trailing Chevron
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: AppShadows.raisedSm,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
