import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import 'scan_reticle.dart';

class ScanViewfinderScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShutter;
  final VoidCallback onGallery;
  final bool flashOn;
  final VoidCallback onToggleFlash;
  final bool macroOn;
  final VoidCallback onToggleMacro;
  final Widget cameraPreview;

  const ScanViewfinderScreen({
    super.key,
    required this.onBack,
    required this.onShutter,
    required this.onGallery,
    required this.flashOn,
    required this.onToggleFlash,
    this.macroOn = false,
    required this.onToggleMacro,
    required this.cameraPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        cameraPreview,
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Ukuran reticle proporsional terhadap tinggi layar agar tidak overflow
              final reticleSize =
                  (constraints.maxHeight * 0.35).clamp(180.0, 280.0);

              return Column(
                children: [
                  _TopBar(
                    flashOn: flashOn,
                    onBack: onBack,
                    onToggleFlash: onToggleFlash,
                  ),
                  const Spacer(),
                  ScanReticle(size: reticleSize),
                  const SizedBox(height: AppSpacing.s3),
                  const _FrameLabel(),
                  const Spacer(),
                  const _TipsCard(),
                  _BottomBar(
                    onShutter: onShutter,
                    onGallery: onGallery,
                    macroOn: macroOn,
                    onToggleMacro: onToggleMacro,
                  ),
                ],
              );
            },
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
          _CircleAction(
            icon: Icons.arrow_back_rounded,
            iconColor: AppColors.primary800,
            onTap: onBack,
          ),
          const Spacer(),
          const _DistancePill(),
          const Spacer(),
          _CircleAction(
            icon: Icons.flashlight_on_rounded,
            iconColor: AppColors.warning500,
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
  final Color iconColor;
  final bool active;
  final VoidCallback onTap;

  const _CircleAction({
    required this.icon,
    required this.iconColor,
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
          color: active ? AppColors.textOnPrimary : iconColor,
        ),
      ),
    );
  }
}

class _DistancePill extends StatelessWidget {
  const _DistancePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              fontWeight: FontWeight.w600,
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
          children: const [
            TextSpan(
              text: 'Tips!: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary800,
              ),
            ),
            TextSpan(
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
  final bool macroOn;
  final VoidCallback onToggleMacro;

  const _BottomBar({
    required this.onShutter,
    required this.onGallery,
    required this.macroOn,
    required this.onToggleMacro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.card),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SideButton(
                icon: Icons.center_focus_strong_rounded,
                label: 'Makro',
                active: macroOn,
                onTap: onToggleMacro,
              ),
              _Shutter(onTap: onShutter),
              _SideButton(
                icon: Icons.photo_library_rounded,
                label: 'Galeri',
                onTap: onGallery,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            'Ketuk tombol untuk deteksi on-device instan',
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

class _SideButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SideButton({
    required this.icon,
    required this.label,
    this.active = false,
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
              color: active ? AppColors.primary600 : AppColors.surfaceInset,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.raisedSm,
            ),
            child: Icon(
              icon,
              size: 20,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              color: active ? AppColors.primary800 : AppColors.textSecondary,
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
