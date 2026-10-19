import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';
import 'camera_preview_placeholder.dart';

/// Widget preview kamera perangkat nyata dengan dukungan:
/// - Full-bleed / cover fit (aspek rasio sensor kamera dipertahankan tanpa distorsi)
/// - Freeze frame ketika gambar berhasil ditangkap
/// - Tampilan loading saat inisialisasi sensor kamera
/// - Tampilan penanganan error dan fallback anggun (kamera fisik tidak ditemukan/izin ditolak)
class AppCameraPreview extends StatelessWidget {
  final CameraController? controller;
  final bool isInitialized;
  final bool isLoading;
  final String? errorMessage;
  final Uint8List? capturedBytes;
  final VoidCallback? onRetry;
  final VoidCallback? onPickGallery;

  const AppCameraPreview({
    super.key,
    this.controller,
    required this.isInitialized,
    required this.isLoading,
    this.errorMessage,
    this.capturedBytes,
    this.onRetry,
    this.onPickGallery,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Jika ada foto hasil jepretan / pilihan galeri, tampilkan freeze-frame
    if (capturedBytes != null) {
      return Image.memory(
        capturedBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // 2. Jika controller kamera siap dan tidak error, tampilkan live preview
    if (isInitialized && controller != null && !controller!.value.hasError) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          final previewRatio = isLandscape
              ? controller!.value.aspectRatio
              : (1 / controller!.value.aspectRatio);

          return ClipRect(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth / previewRatio,
                  child: CameraPreview(controller!),
                ),
              ),
            ),
          );
        },
      );
    }

    // 3. Fallback: placeholder dengan status loading atau pesan error ramah pengguna
    return Stack(
      fit: StackFit.expand,
      children: [
        const CameraPreviewPlaceholder(),
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: CircularProgressIndicator(
                      color: AppColors.primary400,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'Menyiapkan kamera...',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (errorMessage != null)
          Container(
            color: Colors.black.withValues(alpha: 0.65),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.s5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: AppShadows.raised,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppColors.warning100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.videocam_off_rounded,
                        color: AppColors.warning500,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    Text(
                      'Kamera Tidak Tersedia',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Row(
                      children: [
                        if (onRetry != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onRetry,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Coba Lagi'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary800,
                                side: const BorderSide(
                                  color: AppColors.surfaceInset,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.button),
                                ),
                              ),
                            ),
                          ),
                        if (onRetry != null && onPickGallery != null)
                          const SizedBox(width: AppSpacing.s2),
                        if (onPickGallery != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onPickGallery,
                              icon: const Icon(Icons.photo_library_rounded, size: 18),
                              label: const Text('Galeri'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.button),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
