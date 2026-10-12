import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/neu_surface.dart';
import '../../core/components/app_chip.dart';
import '../../core/components/status_badge.dart';
import '../../mock/mock_data.dart';
import 'widgets/history_card.dart';
import 'widgets/history_archived_card.dart';

enum HistoryFilterType {
  all,
  actionRequired,
  mustDiscard,
}

/// Layar Riwayat Deteksi Baglog (Anggota D)
/// Mengimplementasikan arsip inspeksi kamera, pencarian, filter chips,
/// accordion kartu riwayat, bagian pengobatan, pemulihan, arsip, dan inspeksi manual.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryFilterType _selectedFilter = HistoryFilterType.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isArchivedOpen = true;

  // State ekspansi per item id
  final Map<String, bool> _expandedState = {};

  // Daftar data lokal untuk mendukung interaksi dinamis
  late List<HistoryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(MockData.historyList);
    for (final item in _items) {
      _expandedState[item.id] = item.isInitiallyExpanded;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpand(String id) {
    setState(() {
      _expandedState[id] = !(_expandedState[id] ?? false);
    });
  }

  void _handleAction(HistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.actionLabel != null
              ? '${item.actionLabel} berhasil dicatat lokal'
              : 'Status diperbarui',
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
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
    // Saring data berdasarkan query pencarian
    final query = _searchQuery.toLowerCase().trim();
    final filtered = _items.where((item) {
      if (query.isEmpty) return true;
      final matchName = item.name.toLowerCase().contains(query);
      final matchRack = item.rackLocation.toLowerCase().contains(query);
      final matchNote = item.note?.toLowerCase().contains(query) ?? false;
      final matchBadge = item.badge.toLowerCase().contains(query);
      return matchName || matchRack || matchNote || matchBadge;
    }).toList();

    // Saring per kategori dan filter aktif
    final actionItems = filtered.where((item) {
      if (item.category != HistorySectionCategory.actionRequired) return false;
      if (_selectedFilter == HistoryFilterType.mustDiscard) {
        return item.badge == 'Harus Dibuang';
      }
      return true;
    }).toList();

    final recoveredItems = filtered.where((item) {
      if (_selectedFilter == HistoryFilterType.mustDiscard) return false;
      return item.category == HistorySectionCategory.recovered;
    }).toList();

    final archivedItems = filtered.where((item) {
      if (_selectedFilter == HistoryFilterType.mustDiscard) {
        return item.badge == 'Telah Dibuang';
      }
      return item.category == HistorySectionCategory.archived;
    }).toList();

    // Hitung counter untuk chip filter sesuai §8.6
    const countAll = 10; // Semua Temuan (10)
    const countAction = 7; // Perlu Tindakan (7)
    const countDiscard = 3; // Harus Dibuang (3)

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
          // 1. Header Judul Layar
          _buildScreenHeader(),
          const SizedBox(height: AppSpacing.s4),

          // 2. Bar Pencarian Inset
          _buildSearchBar(),
          const SizedBox(height: AppSpacing.s4),

          // 3. Filter Chips Horizontal
          _buildFilterChips(countAll, countAction, countDiscard),
          const SizedBox(height: AppSpacing.sectionGap),

          // 4. Daftar Kartu Perlu Tindakan
          if (actionItems.isNotEmpty) ...[
            ...actionItems.map((item) {
              final isExp = _expandedState[item.id] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                child: HistoryCard(
                  item: item,
                  isExpanded: isExp,
                  onToggle: () => _toggleExpand(item.id),
                  onActionPress: () => _handleAction(item),
                ),
              );
            }),
          ],

          // 5. Bagian Selesai Diobati & Pulih (2 Baglog)
          if (recoveredItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s2),
            _buildSectionHeader(
              icon: Icons.check_circle_outline_rounded,
              title: 'Selesai Diobati & Pulih (${recoveredItems.length} Baglog)',
              trailingBadge: StatusBadge(
                label: '${recoveredItems.length} Sembuh',
                tone: StatusTone.success,
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            ...recoveredItems.map((item) {
              final isExp = _expandedState[item.id] ?? true;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                child: HistoryCard(
                  item: item,
                  isExpanded: isExp,
                  onToggle: () => _toggleExpand(item.id),
                ),
              );
            }),
          ],

          // 7. Bagian Riwayat Terarsip
          if (archivedItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s2),
            _buildArchivedHeader(),
            if (_isArchivedOpen) ...[
              const SizedBox(height: AppSpacing.s3),
              ...archivedItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s3),
                  child: HistoryArchivedCard(
                    item: item,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Arsip ${item.name} (${item.badge})',
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ],

          const SizedBox(height: AppSpacing.s3),

          // 8. Kartu Aksi Inspeksi Manual Baglog
          _buildManualInspectionCard(),
        ],
      ),
    );
  }

  Widget _buildScreenHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Deteksi Baglog',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Arsip inspeksi kamera & diagnosis on-device',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Tombol filter/tune raised
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Pengaturan filter & urutan riwayat',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.raisedSm,
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.primary600,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return NeuSurface(
      variant: NeuVariant.inset,
      radius: AppRadius.tile,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Cari rak, nomor baglog, atau diagnosis...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Buka filter tanggal
              showDatePicker(
                context: context,
                initialDate: DateTime(2024, 10, 24),
                firstDate: DateTime(2024, 1, 1),
                lastDate: DateTime(2025, 12, 31),
              );
            },
            child: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.textSecondary,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(int countAll, int countAction, int countDiscard) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          AppChip(
            label: 'Semua Temuan ($countAll)',
            selected: _selectedFilter == HistoryFilterType.all,
            dotColor: AppColors.primary600,
            onPress: () => setState(() => _selectedFilter = HistoryFilterType.all),
          ),
          const SizedBox(width: AppSpacing.s2),
          AppChip(
            label: 'Perlu Tindakan ($countAction)',
            selected: _selectedFilter == HistoryFilterType.actionRequired,
            dotColor: AppColors.warning500,
            onPress: () => setState(() => _selectedFilter = HistoryFilterType.actionRequired),
          ),
          const SizedBox(width: AppSpacing.s2),
          AppChip(
            label: 'Harus Dibuang ($countDiscard)',
            selected: _selectedFilter == HistoryFilterType.mustDiscard,
            dotColor: AppColors.danger600,
            onPress: () => setState(() => _selectedFilter = HistoryFilterType.mustDiscard),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Widget trailingBadge,
  }) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primary100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary600,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        trailingBadge,
      ],
    );
  }

  Widget _buildArchivedHeader() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _isArchivedOpen = !_isArchivedOpen),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary600,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Riwayat Terarsip',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isArchivedOpen ? 'Tutup arsip' : 'Klik untuk buka',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualInspectionCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Form inspeksi manual baglog',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: NeuSurface(
        variant: NeuVariant.raised,
        radius: AppRadius.card,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppShadows.raisedSm,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary600,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inspeksi Manual Baglog',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Input manual tanpa bantuan kamera',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.raisedSm,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.primary600,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
