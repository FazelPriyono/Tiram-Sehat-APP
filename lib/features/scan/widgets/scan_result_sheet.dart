import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/components/neu_surface.dart';
import '../../../core/components/section_card.dart';
import '../../../core/components/status_badge.dart';
import '../../../core/components/step_list.dart';
import '../../../core/components/action_button.dart';
import '../../../core/format/format_helper.dart';
import '../../../mock/mock_data.dart';

class ScanResultSheetContent extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onSaveToHistory;
  final VoidCallback onScanAgain;

  const ScanResultSheetContent({
    super.key,
    required this.result,
    required this.onSaveToHistory,
    required this.onScanAgain,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingX,
        0,
        AppSpacing.pagePaddingX,
        AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DiagnosisHeader(result: result),
          const SizedBox(height: AppSpacing.s4),
          _ConfidenceCard(result: result),
          const SizedBox(height: AppSpacing.sectionGap),
          _VisualComparison(result: result),
          const SizedBox(height: AppSpacing.sectionGap),
          _MitigationCard(result: result),
          const SizedBox(height: AppSpacing.sectionGap),
          ActionButton(
            label: 'Simpan ke Riwayat Scan',
            variant: ActionVariant.primary,
            fullWidth: true,
            onPress: onSaveToHistory,
          ),
          const SizedBox(height: AppSpacing.s3),
          ActionButton(
            label: 'Scan Baglog Lainnya',
            icon: Icons.photo_camera_rounded,
            variant: ActionVariant.secondary,
            fullWidth: true,
            onPress: onScanAgain,
          ),
        ],
      ),
    );
  }
}

class _DiagnosisHeader extends StatelessWidget {
  final ScanResult result;

  const _DiagnosisHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HASIL DIAGNOSA VISUAL (ON-DEVICE AI)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.04 * 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                result.diagnosisName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  height: 34 / 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '(${result.scientificName})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const StatusBadge(
              label: 'Bisa Diobati',
              tone: StatusTone.warning,
              solid: true,
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              'Lokasi Infeksi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              result.infectionLocation,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  final ScanResult result;

  const _ConfidenceCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final percent = FormatHelper.persen(result.confidence * 100);

    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.tile,
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              size: 24,
              color: AppColors.primary800,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tingkat Keyakinan $percent',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'Sangat Akurat',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Model On-Device CNN (Lokal Tanpa Internet) • '
                  '${result.scannedAt}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisualComparison extends StatelessWidget {
  final ScanResult result;

  const _VisualComparison({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Perbandingan Visual Lapangan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 24 / 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              'Ketuk untuk zoom',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        const Row(
          children: [
            Expanded(
              child: _ComparisonCard(
                label: 'Spora Hijau',
                title: 'Bercak Terdeteksi',
                subtitle: 'Diameter 1,8 cm aktif',
                tone: StatusTone.warning,
                spore: true,
              ),
            ),
            SizedBox(width: AppSpacing.s3),
            Expanded(
              child: _ComparisonCard(
                label: 'Miselium Sehat',
                title: 'Target Normal',
                subtitle: 'Putih kapas tebal merata',
                tone: StatusTone.success,
                spore: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  final StatusTone tone;
  final bool spore;

  const _ComparisonCard({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.spore,
  });

  Color get _accent =>
      tone == StatusTone.warning ? AppColors.warning500 : AppColors.success600;

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.tile,
      padding: const EdgeInsets.all(AppSpacing.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 96,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _SamplePainter(spore: spore)),
                  Positioned(
                    left: AppSpacing.s2,
                    bottom: AppSpacing.s2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
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
        ],
      ),
    );
  }
}

class _SamplePainter extends CustomPainter {
  final bool spore;

  const _SamplePainter({required this.spore});

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = spore ? const Color(0xFF3E4A32) : const Color(0xFFF4F6F0);
    canvas.drawRect(Offset.zero & size, base);

    final blob = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    if (spore) {
      for (int i = 0; i < 26; i++) {
        final x = (i * 37) % size.width;
        final y = (i * 53) % size.height;
        blob.color = Color.fromRGBO(80, 150, 70, 0.25 + (i % 5) * 0.12);
        canvas.drawCircle(Offset(x, y), 5.0 + (i % 4) * 2.0, blob);
      }
    } else {
      for (int i = 0; i < 18; i++) {
        final x = (i * 41) % size.width;
        final y = (i * 29) % size.height;
        blob.color = Color.fromRGBO(255, 255, 255, 0.35 + (i % 4) * 0.1);
        canvas.drawCircle(Offset(x, y), 7.0 + (i % 3) * 3.0, blob);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MitigationCard extends StatelessWidget {
  final ScanResult result;

  const _MitigationCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.medical_services_rounded,
      title: 'Panduan Tindakan Cepat',
      trailing: Text(
        '${result.steps.length} Langkah',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
      children: StepList(
        steps: result.steps
            .map((s) => StepItem(title: s.title, description: s.description))
            .toList(),
      ),
    );
  }
}
