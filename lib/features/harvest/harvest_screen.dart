import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/action_button.dart';
import '../../core/components/app_chip.dart';
import '../../core/components/currency_field.dart';
import '../../core/components/neu_surface.dart';
import '../../core/components/numeric_stepper_field.dart';
import '../../core/components/status_badge.dart';
import '../../core/format/format_helper.dart';
import '../../core/theme/tokens.dart';
import '../../mock/mock_data.dart';

/// Buku Panen — DESIGN.md §8.2 (Anggota A).
/// AppHeader disediakan AppShell; layar ini hanya konten scroll tab.
class HarvestScreen extends StatefulWidget {
  const HarvestScreen({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  static const _quickPrices = <int>[14000, 15000, 16000];
  static const _noteExample =
      'Panen petik ke-3 kumbung selatan, kualitas baglog prima tanpa bercak.';

  late DateTime _date;
  late double _weight;
  late int _price;
  late final TextEditingController _note;

  @override
  void initState() {
    super.initState();
    _date = DateTime(2024, 10, 24);
    _weight = MockData.harvestLast.weightKg;
    _price = MockData.harvestLast.pricePerKg;
    _note = TextEditingController(text: _noteExample);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  int get _grossIncome => (_weight * _price).round();

  bool get _isValid => _weight > 0;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data panen tersimpan')),
    );
    widget.onSaved?.call();
  }

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
          Text(
            '● BUKU PENCATATAN HARIAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.04 * 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            'Catat Hasil Panen',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            'Buku kas panen digital harian mandiri tanpa internet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildDateCard(),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildWeightField(),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildPriceField(),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildEstimateCard(),
          const SizedBox(height: AppSpacing.sectionGap),
          _buildNoteField(),
          const SizedBox(height: AppSpacing.s5),
          ActionButton(
            label: 'Simpan Data Panen',
            icon: Icons.save_rounded,
            variant: ActionVariant.primary,
            fullWidth: true,
            onPress: _isValid ? _save : null,
          ),
          const SizedBox(height: AppSpacing.s4),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.primary600,
              ),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: Text(
                  'Tersimpan di basis data lokal HP (Aman tanpa sinyal internet)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
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
              Icons.calendar_month_rounded,
              color: AppColors.primary800,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TANGGAL PANEN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTanggalPanjang(_date),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Material(
            color: AppColors.surfaceInset,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _pickDate,
              child: const SizedBox(
                width: AppSpacing.tapTargetMin,
                height: AppSpacing.tapTargetMin,
                child: Icon(
                  Icons.expand_more_rounded,
                  color: AppColors.primary800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Berat Jamur Segar Dipanen',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const StatusBadge(label: 'Wajib', tone: StatusTone.info),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        NumericStepperField(
          value: _weight,
          unit: 'Kg',
          step: 0.5,
          min: 0,
          onChange: (value) => setState(() => _weight = value),
        ),
        const SizedBox(height: AppSpacing.s2),
        _helper(
          Icons.scale_rounded,
          'Timbang bersih hasil petik keranjang pagi ini',
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Harga Jual per Kg',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              'Tengkulak / Pasar',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        CurrencyField(
          value: _price,
          onChange: (value) => setState(() => _price = value),
        ),
        const SizedBox(height: AppSpacing.s3),
        Row(
          children: [
            for (final price in _quickPrices)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s2),
                child: AppChip(
                  label: '${price ~/ 1000}k',
                  selected: _price == price,
                  onPress: () => setState(() => _price = price),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        _helper(
          Icons.sell_rounded,
          'Rata-rata harga borongan saat ini Rp 14.000 - Rp 16.500',
        ),
      ],
    );
  }

  Widget _buildEstimateCard() {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Estimasi Pendapatan Kotor',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentChip,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  'Otomatis',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${FormatHelper.kg(_weight)} × ${FormatHelper.rupiah(_price)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                '↗ Siap Buku Kas',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            FormatHelper.rupiah(_grossIncome),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: AppColors.primary800,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            'Estimasi langsung dikonversi ke riwayat laba petik',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Catatan Kumbung & Kondisi Petik',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '(Opsional)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        NeuSurface(
          variant: NeuVariant.inset,
          radius: AppRadius.tile,
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: TextField(
            controller: _note,
            maxLines: 4,
            cursorColor: AppColors.primary600,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _helper(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

const _namaHari = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const _namaBulan = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// "Kamis, 24 Okt 2024" (DESIGN.md §7).
String _formatTanggalPanjang(DateTime date) {
  final hari = _namaHari[date.weekday - 1];
  final bulan = _namaBulan[date.month - 1];
  return '$hari, ${date.day} $bulan ${date.year}';
}
