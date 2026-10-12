import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/neu_surface.dart';
import '../../core/components/section_card.dart';
import '../../core/components/segmented_tabs.dart';
import '../../core/components/action_button.dart';
import '../../core/format/format_helper.dart';
import '../../mock/mock_data.dart';
import 'widgets/trend_chart.dart';

/// Layar Evaluasi & Laporan (Anggota E)
/// Sesuai dengan spesifikasi DESIGN Tiram-Sehat.md §8.7 & §9.2 dan screenshot laporan.png
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedTabIndex = 0;
  static const _tabs = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Rekap laporan (CSV / PDF) berhasil disiapkan di penyimpanan lokal',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.primary800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const report = MockData.report;

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
          _buildHeader(),
          const SizedBox(height: AppSpacing.s4),
          _buildSubtitle(),
          const SizedBox(height: AppSpacing.s5),
          SegmentedTabs(
            items: _tabs,
            value: _selectedTabIndex,
            onChange: (index) => setState(() => _selectedTabIndex = index),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildTodayTiles(report),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildEfficiencySection(report),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildMonthlyAccumulationSection(report),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildBatchCard(report.batch),
          const SizedBox(height: AppSpacing.sectionGap),
          ActionButton(
            label: 'Unduh Rekap Laporan (CSV / PDF)',
            icon: Icons.download_rounded,
            variant: ActionVariant.secondary,
            fullWidth: true,
            onPress: _downloadReport,
          ),
          const SizedBox(height: AppSpacing.s4),
          _buildFooterNote(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Evaluasi & Laporan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Ikhtisar produksi jamur tiram dan performa finansial kumbung berbasis pencatatan mandiri.',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 13.5,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildTodayTiles(ReportData report) {
    return Row(
      children: [
        // Total Panen Hari Ini
        Expanded(
          child: NeuSurface(
            variant: NeuVariant.raised,
            radius: AppRadius.card,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.hourglass_empty_rounded,
                        color: AppColors.primary800,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            size: 14,
                            color: AppColors.primary600,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '+18%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                Text(
                  'Total Panen Hari Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '24,5',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Kg',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s2),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14,
                      color: AppColors.primary600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '+4,2 Kg dr kemarin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        // Penjualan Hari Ini
        Expanded(
          child: NeuSurface(
            variant: NeuVariant.raised,
            radius: AppRadius.card,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: AppColors.primary800,
                        size: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'Tunai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),
                Text(
                  'Penjualan Hari Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp 367.500',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s2),
                Row(
                  children: [
                    const Icon(
                      Icons.sell_outlined,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Rp 15.000 / Kg',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencySection(ReportData report) {
    return SectionCard(
      icon: Icons.eco_rounded,
      title: 'Tingkat Keberhasilan Panen',
      trailing: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primary100,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.spa_rounded,
          color: AppColors.primary600,
          size: 20,
        ),
      ),
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle EFISIENSI SIKLUS KUMBUNG di atas judul atau di dalam kartu
          Text(
            'EFISIENSI SIKLUS KUMBUNG',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.04 * 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          // Inset Well Persentase Keberhasilan
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  '89,4%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary800,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dari',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '2.400 Baglog',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          // Header Tren Kualitas Panen (4 Pekan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tren Kualitas Panen (4 Pekan)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '+7,4% akumulatif',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          // Custom Painter Chart 4 titik
          const TrendChart(
            values: [82.0, 85.0, 88.0, 89.4],
            labels: ['M1: 82%', 'M2: 85%', 'M3: 88%', '89,4%'],
          ),
          const SizedBox(height: AppSpacing.s3),
          // Legenda Sehat & Terkontaminasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary600,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '2.146 Sehat & Berbuah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.danger600,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '254 Terkontaminasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          // Progress Bar (proporsi 2146 / 2400 ≈ 0.894)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: AppColors.danger100),
                  FractionallySizedBox(
                    widthFactor: 2146 / 2400,
                    child: Container(color: AppColors.primary400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyAccumulationSection(ReportData report) {
    return SectionCard(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Akumulasi Bulan Ini',
      trailing: Text(
        'Okt 2026',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Pemasukan Panen Inset
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Pemasukan Panen',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        FormatHelper.rupiah(report.monthIncome),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Total bersih ${FormatHelper.kg(report.monthKg)} jamur segar',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppShadows.raisedSm,
                  ),
                  child: const Icon(
                    Icons.savings_rounded,
                    color: AppColors.primary600,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          // Estimasi Kerugian Baglog Inset
          NeuSurface(
            variant: NeuVariant.inset,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Estimasi Kerugian Baglog',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.danger600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppColors.warning500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        FormatHelper.rupiah(report.monthLoss),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.danger600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.danger100,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              size: 13,
                              color: AppColors.danger600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ditekan ${report.lossReducedPct}% via deteksi dini',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.danger600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppShadows.raisedSm,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    color: AppColors.warning500,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          // Tip Lampu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.primary800,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Tindakan isolasi cepat pada ',
                      ),
                      TextSpan(
                        text: 'Rak Kumbung B',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' berhasil menyelamatkan sekitar 120 baglog terdekat dari spora jamur hijau (*Trichoderma*).',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(BatchData batch) {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail jamur
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.surfaceInset,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8D735C),
                          Color(0xFF5A4433),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.grass_rounded,
                    color: Color(0xFFE8DACD),
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.code,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Varietas ${batch.variety} • Hari ke-${batch.day}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        batch.grade,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Timbang ${batch.weighedAt}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
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

  Widget _buildFooterNote() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 15,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            'Data disimpan di memori HP, siap dicetak kapan saja',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
