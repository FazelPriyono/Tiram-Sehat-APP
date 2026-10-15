import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/components/neu_surface.dart';
import '../../../core/components/status_badge.dart';
import '../../../core/components/action_button.dart';
import '../../../mock/mock_data.dart';
import 'baglog_thumbnail.dart';

/// Kartu riwayat inspeksi baglog berbasis accordion (expand/collapse)
/// dengan styling Neumorphism dan penyesuaian nada semantik (danger/warning/success).
class HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onActionPress;

  const HistoryCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    this.onActionPress,
  });

  NeuTone get _neuTone {
    if (item.tone == 'danger') return NeuTone.danger;
    if (item.tone == 'warning' && isExpanded) return NeuTone.warning;
    return NeuTone.defaultTone;
  }

  ThumbnailIndicatorType get _indicatorType {
    if (item.tone == 'danger') return ThumbnailIndicatorType.dangerTriangle;
    if (item.tone == 'warning') return ThumbnailIndicatorType.warningDot;
    return ThumbnailIndicatorType.successDot;
  }

  StatusBadge _buildHeaderBadge() {
    switch (item.badge) {
      case 'Harus Dibuang':
        return const StatusBadge(
          label: 'Harus Dibuang',
          tone: StatusTone.danger,
          icon: Icons.delete_outline_rounded,
          solid: true,
        );
      case 'Bisa Diobati':
        return const StatusBadge(
          label: 'Bisa Diobati',
          tone: StatusTone.warning,
          icon: Icons.healing_rounded,
          solid: true,
        );
      case 'Sedang Diobati':
        return const StatusBadge(
          label: 'Sedang Diobati',
          tone: StatusTone.success,
          icon: Icons.healing_rounded,
          solid: true,
        );
      case 'Selesai Diobati':
      default:
        return const StatusBadge(
          label: 'Selesai Diobati',
          tone: StatusTone.success,
          icon: Icons.check_circle_outline_rounded,
          solid: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeuSurface(
      variant: NeuVariant.raised,
      radius: AppRadius.card,
      tone: _neuTone,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu (Dapat diketuk untuk toggle accordion)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaglogThumbnail(indicatorType: _indicatorType),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _buildHeaderBadge(),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.when,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: AppColors.primary600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.rackLocation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Tombol Chevron
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.raisedSm,
                  ),
                  child: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Expanded
          if (isExpanded && item.status != null) ...[
            const SizedBox(height: AppSpacing.s4),
            _buildExpandedDetail(context),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedDetail(BuildContext context) {
    Color boxBg;
    Border boxBorder;
    Color titleColor;
    IconData titleIcon;

    if (item.tone == 'danger') {
      boxBg = const Color(0xFFFDE8E8);
      boxBorder = Border.all(color: AppColors.dangerBorder, width: 1);
      titleColor = AppColors.danger600;
      titleIcon = Icons.error_outline_rounded;
    } else if (item.tone == 'warning') {
      boxBg = const Color(0xFFFEF3DC);
      boxBorder = Border.all(color: const Color(0xFFF7D59A), width: 1);
      titleColor = AppColors.warning500;
      titleIcon = Icons.cleaning_services_rounded;
    } else {
      boxBg = const Color(0xFFEAF4E9);
      boxBorder = Border.all(color: const Color(0xFFC6E2C4), width: 1);
      titleColor = AppColors.textPrimary;
      titleIcon = Icons.check_circle_outline_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: boxBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kotak Status
          Row(
            children: [
              Icon(titleIcon, size: 16, color: titleColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.status ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
              ),
              if (item.tag != null) ...[
                const SizedBox(width: 8),
                _buildTagBadge(item.tag!),
              ],
            ],
          ),
          if (item.note != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(
              item.note!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
          if (item.actionLabel != null) ...[
            const SizedBox(height: AppSpacing.s3),
            _buildActionButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildTagBadge(String tag) {
    if (tag == 'Urgen') {
      return const StatusBadge(
        label: 'Urgen',
        tone: StatusTone.danger,
        solid: true,
      );
    }
    if (tag == 'Perawatan Ringan') {
      return const StatusBadge(
        label: 'Perawatan Ringan',
        tone: StatusTone.warning,
      );
    }
    if (tag == 'Observasi' || tag == 'Aman') {
      return StatusBadge(
        label: tag,
        tone: StatusTone.success,
      );
    }
    if (tag == 'Karantina Tuntas' || tag == 'Stabil') {
      return StatusBadge(
        label: tag,
        tone: StatusTone.success,
      );
    }
    return StatusBadge(
      label: tag,
      tone: StatusTone.neutral,
    );
  }

  Widget _buildActionButton() {
    ActionVariant variant;
    IconData icon;

    if (item.tone == 'danger') {
      variant = ActionVariant.danger;
      icon = Icons.check_circle_outline_rounded;
    } else if (item.tone == 'warning') {
      variant = ActionVariant.warning;
      icon = Icons.check_circle_outline_rounded;
    } else {
      variant = ActionVariant.secondary;
      icon = item.actionLabel!.contains('Perbarui')
          ? Icons.refresh_rounded
          : Icons.check_circle_outline_rounded;
    }

    return ActionButton(
      label: item.actionLabel!,
      icon: icon,
      variant: variant,
      fullWidth: true,
      onPress: onActionPress,
    );
  }
}
