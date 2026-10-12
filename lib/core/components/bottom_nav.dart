import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

enum BottomNavTab { home, harvest, scan, report, history }

class BottomNav extends StatelessWidget {
  final BottomNavTab active;
  final ValueChanged<BottomNavTab> onChange;

  const BottomNav({super.key, required this.active, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A96A896),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                tab: BottomNavTab.home,
                active: active,
                onTap: onChange,
              ),
              _NavItem(
                icon: Icons.menu_book_rounded,
                label: 'Buku Panen',
                tab: BottomNavTab.harvest,
                active: active,
                onTap: onChange,
              ),
              _ScanFab(active: active, onTap: onChange),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Laporan',
                tab: BottomNavTab.report,
                active: active,
                onTap: onChange,
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'Riwayat',
                tab: BottomNavTab.history,
                active: active,
                onTap: onChange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final BottomNavTab tab;
  final BottomNavTab active;
  final ValueChanged<BottomNavTab> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = active == tab;
    final color = isActive ? AppColors.primary600 : AppColors.textMuted;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanFab extends StatelessWidget {
  final BottomNavTab active;
  final ValueChanged<BottomNavTab> onTap;

  const _ScanFab({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(BottomNavTab.scan),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary600,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.fab,
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  color: AppColors.textOnPrimary,
                  size: 28,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text(
                'Scan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
