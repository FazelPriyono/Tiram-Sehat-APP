import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiram_sehat/core/theme/app_theme.dart';
import 'package:tiram_sehat/features/auth/onboarding_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  // Ilustrasi memakai animasi yang berulang tanpa henti, jadi `pumpAndSettle`
  // tidak boleh dipakai. Semua penantian memakai `pump` dengan durasi tetap.
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    VoidCallback? onFinished,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: OnboardingScreen(onFinished: onFinished),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
  }

  testWidgets('Halaman pertama menampilkan brand, langkah, dan ajakan lanjut',
      (WidgetTester tester) async {
    await pumpOnboarding(tester);

    expect(find.text('TiramSehat'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);

    expect(find.text('Deteksi Cepat Kontaminasi Baglog'), findsOneWidget);
    expect(
      find.text(
        'Cukup arahkan kamera ke baglog jamur tiram untuk mengenali hama dan kontaminasi sejak dini dalam hitungan detik.',
      ),
      findsOneWidget,
    );

    expect(find.text('1. Pindai'), findsOneWidget);
    expect(find.text('2. Solusi'), findsOneWidget);
    expect(find.text('3. Panen'), findsOneWidget);

    expect(find.text('Lanjut'), findsOneWidget);
  });

  testWidgets('Menekan Lanjut berpindah ke halaman Solusi',
      (WidgetTester tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('Lanjut'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.text('Panduan Mitigasi Langkah demi Langkah'),
      findsOneWidget,
    );
  });

  testWidgets('Pill langkah terakhir mengubah tombol menjadi Mulai Sekarang',
      (WidgetTester tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('3. Panen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Catat Panen & Estimasi Pendapatan'), findsOneWidget);
    expect(find.text('Mulai Sekarang'), findsOneWidget);
  });

  testWidgets('Lewati memanggil onFinished', (WidgetTester tester) async {
    bool finished = false;
    await pumpOnboarding(tester, onFinished: () => finished = true);

    await tester.tap(find.text('Lewati'));
    await tester.pump();

    expect(finished, isTrue);
  });

  testWidgets('Mulai Sekarang memanggil onFinished', (WidgetTester tester) async {
    bool finished = false;
    await pumpOnboarding(tester, onFinished: () => finished = true);

    await tester.tap(find.text('3. Panen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Mulai Sekarang'));
    await tester.pump();

    expect(finished, isTrue);
  });

  // Definition of Done DESIGN §12: tampil benar pada lebar 360, 390, 430 dp.
  for (final double width in <double>[360, 390, 430]) {
    testWidgets('Tata letak aman pada lebar ${width.toInt()} dp',
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(width * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await pumpOnboarding(tester);

      expect(tester.takeException(), isNull);
    });
  }
}
