import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/neu_surface.dart';
import '../../core/components/section_card.dart';
import '../../mock/mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingX,
        AppSpacing.s2,
        AppSpacing.pagePaddingX,
        110,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _HomeGreetingHeader(),
          SizedBox(height: AppSpacing.sectionGap),
          _IncomeCard(),
          SizedBox(height: AppSpacing.sectionGap),
          _BaglogCard(),
          SizedBox(height: AppSpacing.sectionGap),
          _SelfCheckCard(),
        ],
      ),
    );
  }
}

class _HomeGreetingHeader extends StatelessWidget {
  const _HomeGreetingHeader();

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
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Kumbung Blok A',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        NeuSurface(
          variant: NeuVariant.raised,
          radius: 18,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: const Icon(
              Icons.yard_rounded,
              color: AppColors.primary800,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}

class _IncomeCard extends StatelessWidget {
  const _IncomeCard();

  @override
  Widget build(BuildContext context) {
    final harvest = MockData.harvestLast;

    return SectionCard(
      icon: Icons.payments_outlined,
      title: 'Estimasi Pendapatan Panen',
      children: Column(
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.04 * 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rp 277.500',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                NeuSurface(
                  variant: NeuVariant.raised,
                  radius: 16,
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary800,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          r'$',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: NeuSurface(
                  variant: NeuVariant.raised,
                  radius: AppRadius.tile,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Berat Panen Terakhir',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '18,5',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kg',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: NeuSurface(
                  variant: NeuVariant.raised,
                  radius: AppRadius.tile,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga Jual Rata-rata',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Rp 15.000',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '/Kg',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: AppColors.primary800,
                ),
                const SizedBox(width: AppSpacing.s3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Panen Terakhir:',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      harvest.date,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary800,
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
  const _BaglogCard();

  @override
  Widget build(BuildContext context) {
    final cycle = MockData.cycle;

    return SectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'Ringkasan Siklus Baglog',
      children: Column(
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.04 * 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '2.450',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'baglog',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                NeuSurface(
                  variant: NeuVariant.raised,
                  radius: 16,
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.primary800,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _CycleMetricTile(
                  label: 'Sehat Produktif',
                  value: '2.210',
                  unit: 'baglog',
                  valueColor: AppColors.primary800,
                  badgeIcon: Icons.check_circle_rounded,
                  badgeColor: const Color(0xFFDDEBDC),
                  iconColor: AppColors.primary800,
                  progress: cycle.healthy / cycle.total,
                  progressBarColor: AppColors.primary800,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _CycleMetricTile(
                  label: 'Bisa Diobati',
                  value: '165',
                  unit: 'baglog',
                  valueColor: AppColors.warning500,
                  badgeIcon: Icons.healing_rounded,
                  badgeColor: const Color(0xFFFCEBCB),
                  iconColor: AppColors.warning500,
                  progress: cycle.treatable / cycle.total,
                  progressBarColor: AppColors.warning500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _CycleMetricTile(
                  label: 'Afkir / Dibuang',
                  value: '75',
                  unit: 'baglog',
                  valueColor: AppColors.danger600,
                  badgeIcon: Icons.delete_outline_rounded,
                  badgeColor: const Color(0xFFF8DADA),
                  iconColor: AppColors.danger600,
                  progress: cycle.discarded / cycle.total,
                  progressBarColor: AppColors.danger600,
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: _CycleMetricTile(
                  label: 'Tingkat Sehat',
                  value: '90,2%',
                  unit: 'rasio',
                  valueColor: AppColors.primary800,
                  badgeIcon: Icons.query_stats_rounded,
                  badgeColor: const Color(0xFFDDEBDC),
                  iconColor: AppColors.primary800,
                  progress: cycle.healthRatio,
                  progressBarColor: AppColors.primary800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CycleMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color valueColor;
  final IconData badgeIcon;
  final Color badgeColor;
  final Color iconColor;
  final double progress;
  final Color progressBarColor;

  const _CycleMetricTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.valueColor,
    required this.badgeIcon,
    required this.badgeColor,
    required this.iconColor,
    required this.progress,
    required this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.tile,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(badgeIcon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              height: 5,
              width: double.infinity,
              color: const Color(0xFFE5EAE4),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.04, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: progressBarColor,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
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

class _SelfCheckCard extends StatelessWidget {
  const _SelfCheckCard();

  @override
  Widget build(BuildContext context) {
    final check = MockData.selfCheck;
    final progress = check.checked / check.target;

    return SectionCard(
      icon: Icons.checklist_rounded,
      title: 'Pengecekan Mandiri Hari Ini',
      trailing: Text(
        'Target: ${check.target}',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primary800,
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
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '80% Selesai',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    color: const Color(0xFFDCE2DB),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ),
                ),
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
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.photo_camera_outlined,
                        color: AppColors.primary800,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Text(
                          'Mulai Scan Kumbung',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary800,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
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
