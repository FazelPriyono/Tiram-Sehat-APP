import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/app_bottom_sheet.dart';
import '../../mock/mock_data.dart';
import 'widgets/camera_preview_placeholder.dart';
import 'widgets/scan_viewfinder_screen.dart';
import 'widgets/scan_result_sheet.dart';

enum ScanPhase { viewfinder, analyzing, result }

class ScanScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSavedToHistory;

  const ScanScreen({
    super.key,
    required this.onBack,
    required this.onSavedToHistory,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanPhase _phase = ScanPhase.viewfinder;
  bool _flashOn = false;

  void _capture() {
    setState(() => _phase = ScanPhase.analyzing);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _phase != ScanPhase.analyzing) return;
      setState(() => _phase = ScanPhase.result);
    });
  }

  void _reset() => setState(() => _phase = ScanPhase.viewfinder);

  void _toggleFlash() => setState(() => _flashOn = !_flashOn);

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case ScanPhase.viewfinder:
        return ScanViewfinderScreen(
          onBack: widget.onBack,
          onShutter: _capture,
          onGallery: _capture,
          flashOn: _flashOn,
          onToggleFlash: _toggleFlash,
        );
      case ScanPhase.analyzing:
        return const _AnalyzingOverlay();
      case ScanPhase.result:
        return _ResultView(
          flashOn: _flashOn,
          onToggleFlash: _toggleFlash,
          onClose: _reset,
          onScanAgain: _reset,
          onSaveToHistory: widget.onSavedToHistory,
        );
    }
  }
}

class _AnalyzingOverlay extends StatelessWidget {
  const _AnalyzingOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CameraPreviewPlaceholder(),
        Container(
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary400,
                  strokeWidth: 3,
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Menganalisis...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  final bool flashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onClose;
  final VoidCallback onScanAgain;
  final VoidCallback onSaveToHistory;

  const _ResultView({
    required this.flashOn,
    required this.onToggleFlash,
    required this.onClose,
    required this.onScanAgain,
    required this.onSaveToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final result = MockData.scanResult;

    return Stack(
      fit: StackFit.expand,
      children: [
        const CameraPreviewPlaceholder(),
        SafeArea(
          child: Column(
            children: [
              _ResultTopBar(
                flashOn: flashOn,
                onToggleFlash: onToggleFlash,
                onClose: onClose,
              ),
              const SizedBox(height: AppSpacing.s4),
              _DetectionBox(result: result),
            ],
          ),
        ),
        AppBottomSheet(
          builder: (context, snap) => ScanResultSheetContent(
            result: result,
            onSaveToHistory: onSaveToHistory,
            onScanAgain: onScanAgain,
          ),
        ),
      ],
    );
  }
}

class _ResultTopBar extends StatelessWidget {
  final bool flashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onClose;

  const _ResultTopBar({
    required this.flashOn,
    required this.onToggleFlash,
    required this.onClose,
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
            icon: Icons.flashlight_on_rounded,
            active: flashOn,
            onTap: onToggleFlash,
          ),
          const Spacer(),
          _ResultStatusPill(),
          const Spacer(),
          _CircleAction(icon: Icons.close_rounded, onTap: onClose),
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

class _ResultStatusPill extends StatelessWidget {
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
            'KAMERA OFFLINE AI AKTIF',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.04 * 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectionBox extends StatelessWidget {
  final ScanResult result;

  const _DetectionBox({required this.result});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        height: 190,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const CustomPaint(
              size: Size(240, 190),
              painter: _DetectionCornerPainter(),
            ),
            Positioned(
              top: -14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning500,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '⚠ ${result.scientificName} 94%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetectionCornerPainter extends CustomPainter {
  const _DetectionCornerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const cornerLen = 34.0;
    final paint = Paint()
      ..color = AppColors.warning500
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final tl = Offset.zero;
    final tr = Offset(size.width, 0);
    final bl = Offset(0, size.height);
    final br = Offset(size.width, size.height);

    canvas.drawLine(tl + const Offset(0, cornerLen), tl, paint);
    canvas.drawLine(tl, tl + Offset(cornerLen, 0), paint);

    canvas.drawLine(tr + Offset(-cornerLen, 0), tr, paint);
    canvas.drawLine(tr, tr + const Offset(0, cornerLen), paint);

    canvas.drawLine(bl + const Offset(0, -cornerLen), bl, paint);
    canvas.drawLine(bl, bl + Offset(cornerLen, 0), paint);

    canvas.drawLine(br + Offset(-cornerLen, 0), br, paint);
    canvas.drawLine(br, br + const Offset(0, -cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
