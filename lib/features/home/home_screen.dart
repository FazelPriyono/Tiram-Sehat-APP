import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/neu_surface.dart';
import '../../core/components/section_card.dart';
import '../../core/components/metric_tile.dart';
import '../../core/components/app_progress_bar.dart';
import '../../core/components/info_note.dart';
import '../../core/format/format_helper.dart';
import '../../mock/mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingX,
        AppSpacing.s4,
        AppSpacing.pagePaddingX,
        96,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(),
          const SizedBox(height: AppSpacing.sectionGap),
          _OfflinePill(),
          const SizedBox(height: AppSpacing.sectionGap),
          _IncomeCard(),
          const SizedBox(height: AppSpacing.sectionGap),
          _BaglogCard(),
          const SizedBox(height: AppSpacing.sectionGap),
          _SelfCheckCard(),
          const SizedBox(height: AppSpacing.s4),
          const InfoNote(
            icon: Icons.cloud_off_rounded,
            text: 'Semua catatan tersimpan di memori perangkat ini',
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Pagi, Petani BUMDes',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Kumbung Blok A',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            boxShadow: AppShadows.raisedSm,
          ),
          child: const Icon(
            Icons.eco_rounded,
            color: AppColors.primary600,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _OfflinePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.raisedSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Offline-Ready • Model Vision On-Device Aktif',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary800,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final harvest = MockData.harvestLast;

    return SectionCard(
      icon: Icons.payments_rounded,
      title: 'Estimasi Pendapatan Panen',
      trailing: _SmallChip(label: 'Buku Panen', onTap: () {}),
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESTIMASI PANEN HARI INI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.04 * 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        FormatHelper.rupiah(harvest.grossIncome),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 36,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.savings_rounded,
                    color: AppColors.primary800,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Berat Panen Terakhir',
                  value: '18,5',
                  unit: 'Kg',
                  tone: MetricTileTone.success,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: MetricTile(
                  label: 'Harga Jual Rata-rata',
                  value: 'Rp 15.000',
                  unit: '/Kg',
                  tone: MetricTileTone.defaultTone,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s3,
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: AppSpacing.s2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Panen Terakhir:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      harvest.date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BaglogCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycle = MockData.cycle;

    return SectionCard(
      icon: Icons.inventory_2_rounded,
      title: 'Ringkasan Siklus Baglog',
      trailing: _CycleChip(label: 'Siklus #04'),
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL BAGLOG AKTIF',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.04 * 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '2.450',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'baglog',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    color: AppColors.primary800,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Sehat Produktif',
                  value: '2.210',
                  tone: MetricTileTone.success,
                  icon: Icons.eco_rounded,
                  progress: cycle.healthy / cycle.total,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: MetricTile(
                  label: 'Bisa Diobati',
                  value: '165',
                  tone: MetricTileTone.warning,
                  icon: Icons.healing_rounded,
                  progress: cycle.treatable / cycle.total,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'Afkir / Dibuang',
                  value: '75',
                  tone: MetricTileTone.danger,
                  icon: Icons.delete_rounded,
                  progress: cycle.discarded / cycle.total,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: MetricTile(
                  label: 'Tingkat Sehat',
                  value: '90,2%',
                  unit: 'rasio',
                  tone: MetricTileTone.success,
                  icon: Icons.show_chart_rounded,
                  progress: cycle.healthRatio,
                  variant: NeuVariant.raised,
                  size: MetricSize.md,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelfCheckCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final check = MockData.selfCheck;
    final progress = check.checked / check.target;

    return SectionCard(
      icon: Icons.checklist_rounded,
      title: 'Pengecekan Mandiri Hari Ini',
      trailing: Text(
        'Target: 100',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary600,
        ),
      ),
      children: Column(
        children: [
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${check.checked} dari ${check.target} baglog dicek',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '80% Selesai',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                AppProgressBar(value: progress, tone: MetricTileTone.success),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          NeuSurface(
            variant: NeuVariant.raised,
            radius: AppRadius.tile,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.tile),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s4,
                    vertical: AppSpacing.s3,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          color: AppColors.primary800,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Text(
                          'Mulai Scan Kumbung',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.primary600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary100,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primary800,
          ),
        ),
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  final String label;
  const _CycleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentChip,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary800,
        ),
      ),
    );
  }
}
