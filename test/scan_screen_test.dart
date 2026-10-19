import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiram_sehat/features/scan/widgets/app_camera_preview.dart';
import 'package:tiram_sehat/features/scan/widgets/scan_viewfinder_screen.dart';

void main() {
  group('AppCameraPreview tests', () {
    testWidgets('AppCameraPreview renders loading state when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCameraPreview(
              isInitialized: false,
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.text('Menyiapkan kamera...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'AppCameraPreview renders error message and action buttons on failure',
        (WidgetTester tester) async {
      bool retried = false;
      bool galleryOpened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCameraPreview(
              isInitialized: false,
              isLoading: false,
              errorMessage: 'Izin kamera ditolak.',
              onRetry: () => retried = true,
              onPickGallery: () => galleryOpened = true,
            ),
          ),
        ),
      );

      expect(find.text('Kamera Tidak Tersedia'), findsOneWidget);
      expect(find.text('Izin kamera ditolak.'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);
      expect(find.text('Galeri'), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      expect(retried, isTrue);

      await tester.tap(find.text('Galeri'));
      expect(galleryOpened, isTrue);
    });

    testWidgets(
        'AppCameraPreview renders image when capturedBytes is provided',
        (WidgetTester tester) async {
      // 1x1 transparent PNG byte array
      final dummyBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
        0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
        0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
        0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
        0x42, 0x60, 0x82,
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCameraPreview(
              isInitialized: false,
              isLoading: false,
              capturedBytes: dummyBytes,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('ScanViewfinderScreen tests', () {
    testWidgets('ScanViewfinderScreen renders reticle, pills, tips, and buttons',
        (WidgetTester tester) async {
      bool shutterClicked = false;
      bool macroClicked = false;
      bool galleryClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanViewfinderScreen(
              cameraPreview: const SizedBox.expand(),
              onBack: () {},
              onShutter: () => shutterClicked = true,
              onGallery: () => galleryClicked = true,
              flashOn: false,
              onToggleFlash: () {},
              macroOn: false,
              onToggleMacro: () => macroClicked = true,
            ),
          ),
        ),
      );

      // Pastikan label panduan & jarak tampil
      expect(find.text('Jarak Optimal: '), findsOneWidget);
      expect(find.text('15 - 30 cm'), findsOneWidget);
      expect(find.text('Posisikan Cincin / Mulut Baglog'), findsOneWidget);

      // Pastikan tips kartu tampil
      expect(find.textContaining('Tips!: '), findsOneWidget);

      // Pastikan tombol bawah (Makro, Shutter, Galeri) tampil
      expect(find.text('Makro'), findsOneWidget);
      expect(find.text('Galeri'), findsOneWidget);

      await tester.tap(find.text('Makro'));
      expect(macroClicked, isTrue);

      await tester.tap(find.text('Galeri'));
      expect(galleryClicked, isTrue);

      // Ketuk shutter
      final shutterFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).shape == BoxShape.circle &&
            widget.constraints?.maxWidth == 76,
      );
      expect(shutterFinder, findsOneWidget);
      await tester.tap(shutterFinder);
      expect(shutterClicked, isTrue);
    });
  });
}
