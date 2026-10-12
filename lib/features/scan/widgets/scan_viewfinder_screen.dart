import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import 'camera_preview_placeholder.dart';
import 'scan_reticle.dart';

class ScanViewfinderScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShutter;
  final VoidCallback onGallery;
  final bool flashOn;
  final VoidCallback onToggleFlash;

  const ScanViewfinderScreen({
    super.key,
    required this.onBack,
    required this.onShutter,
    required this.onGallery,
    required this.flashOn,
    required this.onToggleFlash,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CameraPreviewPlaceholder(),
        SafeArea(
          child: Column(
            children: [
              _TopBar(
                flashOn: flashOn,
                onBack: onBack,
                onToggleFlash: onToggleFlash,
              ),
              const SizedBox(height: AppSpacing.s3),
              const _DistanceChip(),
              const Spacer(),
              const ScanReticle(),
              const SizedBox(height: AppSpacing.s3),
              const _FrameLabel(),
              const Spacer(),
              const _TipsCard(),
              _BottomBar(onShutter: onShutter, onGallery: onGallery),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool flashOn;
  final VoidCallback onBack;
  final VoidCallback onToggleFlash;

  const _TopBar({
    required this.flashOn,
    required this.onBack,
    required this.onToggleFlash,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePaddingX,
        vertical: AppSpacing.s2,
      ),
      child: Row(
        children: [
          _CircleAction(icon: Icons.arrow_back_rounded, onTap: onBack),
          const Spacer(),
          const _StatusPill(),
          const Spacer(),
          _CircleAction(
            icon: Icons.flashlight_on_rounded,
            active: flashOn,
            onTap: onToggleFlash,
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _CircleAction({
    required this.icon,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.tapTargetMin,
        height: AppSpacing.tapTargetMin,
        decoration: BoxDecoration(
          color: active ? AppColors.warning500 : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.raisedSm,
        ),
        child: Icon(
          icon,
          size: 22,
          color: active ? AppColors.textOnPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            'Offline AI Siap',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '• 1:1 FOCUS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistanceChip extends StatelessWidget {
  const _DistanceChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.straighten_rounded,
            size: 16,
            color: AppColors.warning500,
          ),
          const SizedBox(width: 6),
          Text(
            'Jarak Optimal: ',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          Text(
            '15 - 30 cm',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary400,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameLabel extends StatelessWidget {
  const _FrameLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.center_focus_strong_rounded,
            size: 16,
            color: AppColors.primary400,
          ),
          const SizedBox(width: 6),
          Text(
            'Posisikan Cincin / Mulut Baglog',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.pagePaddingX,
        0,
        AppSpacing.pagePaddingX,
        AppSpacing.s4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        boxShadow: AppShadows.raised,
      ),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            const TextSpan(
              text: 'Tips Petani: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary800,
              ),
            ),
            const TextSpan(
              text:
                  'Pastikan permukaan miselium bebas bayangan gelap tangan Anda.',
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onShutter;
  final VoidCallback onGallery;

  const _BottomBar({required this.onShutter, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SideButton(icon: Icons.center_focus_strong_rounded, label: 'Makro', onTap: () {}),
          _Shutter(onTap: onShutter),
          _SideButton(
            icon: Icons.photo_library_rounded,
            label: 'Galeri',
            onTap: onGallery,
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SideButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.tapTargetMin,
            height: AppSpacing.tapTargetMin,
            decoration: BoxDecoration(
              color: AppColors.surfaceInset,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.raisedSm,
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Shutter extends StatelessWidget {
  final VoidCallback onTap;

  const _Shutter({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: AppColors.primary600,
          shape: BoxShape.circle,
          boxShadow: AppShadows.fab,
        ),
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
