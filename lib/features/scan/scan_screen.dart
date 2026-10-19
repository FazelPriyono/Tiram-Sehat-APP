import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/tokens.dart';
import '../../core/components/app_bottom_sheet.dart';
import '../../mock/mock_data.dart';
import 'widgets/app_camera_preview.dart';
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

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  bool _isInitializing = true;
  String? _cameraError;
  bool _flashOn = false;
  bool _macroOn = false;

  Uint8List? _capturedBytes;

  ScanPhase _phase = ScanPhase.viewfinder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _controller;

    // Abaikan jika controller belum siap
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      cameraController.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _cameraError = null;
    });

    try {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }

      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
            _cameraError =
                'Tidak ada perangkat kamera yang terdeteksi di perangkat ini.';
          });
        }
        return;
      }

      // Prioritaskan kamera belakang untuk pemindaian baglog jamur
      final selectedCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _controller = controller;

      await controller.initialize();

      if (mounted) {
        setState(() {
          _isInitializing = false;
          _flashOn = false;
          _macroOn = false;
        });
      }
    } on CameraException catch (e) {
      debugPrint('CameraException [${e.code}]: ${e.description}');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _cameraError = _mapCameraErrorCode(e.code, e.description);
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _cameraError = 'Terjadi kendala saat mengakses kamera perangkat ($e).';
        });
      }
    }
  }

  String _mapCameraErrorCode(String code, String? description) {
    switch (code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Izin akses kamera belum diberikan. Harap aktifkan izin kamera di Pengaturan perangkat Anda.';
      case 'CameraAccessRestricted':
        return 'Akses kamera dibatasi oleh kebijakan keamanan perangkat.';
      default:
        return description ??
            'Kamera belum dapat digunakan ($code). Pastikan kamera tidak sedang dipakai aplikasi lain.';
    }
  }

  Future<void> _toggleFlash() async {
    final nextFlash = !_flashOn;
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.setFlashMode(
          nextFlash ? FlashMode.torch : FlashMode.off,
        );
        if (mounted) {
          setState(() => _flashOn = nextFlash);
        }
      } catch (e) {
        debugPrint('Flash mode toggle error: $e');
      }
    } else {
      setState(() => _flashOn = nextFlash);
    }
  }

  Future<void> _toggleMacro() async {
    final nextMacro = !_macroOn;
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final minZoom = await _controller!.getMinZoomLevel();
        final maxZoom = await _controller!.getMaxZoomLevel();
        final targetZoom =
            nextMacro ? (2.0).clamp(minZoom, maxZoom) : minZoom;
        await _controller!.setZoomLevel(targetZoom);
        if (mounted) {
          setState(() => _macroOn = nextMacro);
        }
      } catch (e) {
        debugPrint('Macro zoom toggle error: $e');
      }
    } else {
      setState(() => _macroOn = nextMacro);
    }
  }

  Future<void> _capture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final xFile = await _controller!.takePicture();
        final bytes = await xFile.readAsBytes();
        if (mounted) {
          setState(() {
            _capturedBytes = bytes;
            _phase = ScanPhase.analyzing;
          });
        }
      } catch (e) {
        debugPrint('Take picture error: $e');
        if (mounted) {
          setState(() => _phase = ScanPhase.analyzing);
        }
      }
    } else {
      setState(() => _phase = ScanPhase.analyzing);
    }

    _startAnalysisTimer();
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        if (mounted) {
          setState(() {
            _capturedBytes = bytes;
            _phase = ScanPhase.analyzing;
          });
          _startAnalysisTimer();
        }
      }
    } catch (e) {
      debugPrint('Pick image gallery error: $e');
    }
  }

  void _startAnalysisTimer() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _phase != ScanPhase.analyzing) return;
      setState(() => _phase = ScanPhase.result);
    });
  }

  void _reset() {
    setState(() {
      _capturedBytes = null;
      _phase = ScanPhase.viewfinder;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cameraPreviewWidget = AppCameraPreview(
      controller: _controller,
      isInitialized: _controller != null && _controller!.value.isInitialized,
      isLoading: _isInitializing,
      errorMessage: _cameraError,
      capturedBytes: _capturedBytes,
      onRetry: _initializeCamera,
      onPickGallery: _pickFromGallery,
    );

    switch (_phase) {
      case ScanPhase.viewfinder:
        return ScanViewfinderScreen(
          onBack: widget.onBack,
          onShutter: _capture,
          onGallery: _pickFromGallery,
          flashOn: _flashOn,
          onToggleFlash: _toggleFlash,
          macroOn: _macroOn,
          onToggleMacro: _toggleMacro,
          cameraPreview: cameraPreviewWidget,
        );
      case ScanPhase.analyzing:
        return _AnalyzingOverlay(cameraPreview: cameraPreviewWidget);
      case ScanPhase.result:
        return _ResultView(
          cameraPreview: cameraPreviewWidget,
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
  final Widget cameraPreview;

  const _AnalyzingOverlay({required this.cameraPreview});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        cameraPreview,
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
  final Widget cameraPreview;
  final bool flashOn;
  final VoidCallback onToggleFlash;
  final VoidCallback onClose;
  final VoidCallback onScanAgain;
  final VoidCallback onSaveToHistory;

  const _ResultView({
    required this.cameraPreview,
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
        cameraPreview,
        SafeArea(
          child: Column(
            children: [
              _ResultTopBar(
                flashOn: flashOn,
                onToggleFlash: onToggleFlash,
                onClose: onClose,
              ),
              const Spacer(),
              _DetectionBox(result: result),
              const SizedBox(height: AppSpacing.s4),
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
            iconColor: AppColors.warning500,
            active: flashOn,
            onTap: onToggleFlash,
          ),
          const Spacer(),
          _CircleAction(
            icon: Icons.close_rounded,
            iconColor: AppColors.textSecondary,
            onTap: onClose,
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

class _DetectionBox extends StatelessWidget {
  final ScanResult result;

  const _DetectionBox({required this.result});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 240,
            height: 190,
            child: CustomPaint(
              size: Size(240, 190),
              painter: _DetectionCornerPainter(),
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        ],
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
