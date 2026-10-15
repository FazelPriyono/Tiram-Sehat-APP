import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiram_sehat/core/theme/app_theme.dart';
import 'package:tiram_sehat/features/auth/login_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('LoginScreen menampilkan elemen header, form field, dan tombol aksi',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );

    // Jalankan animasi opening hingga selesai
    await tester.pumpAndSettle();

    // Verifikasi identitas brand & header
    expect(find.text('TiramSehat'), findsOneWidget);
    expect(find.text('Selamat Datang, Petani!'), findsOneWidget);
    expect(
      find.text('Masuk untuk mencatat hasil panen dan memantau kesehatan baglog.'),
      findsOneWidget,
    );

    // Verifikasi form fields
    expect(find.text('Nomor WhatsApp / ID Petani'), findsOneWidget);
    expect(find.text('Contoh: 0812×xxx atau P-01'), findsOneWidget);
    expect(find.text('PIN Masuk'), findsOneWidget);
    expect(find.text('Ketik 4–6 angka PIN'), findsOneWidget);

    // Verifikasi tombol bantuan Lupa PIN
    expect(find.text('Lupa PIN?'), findsOneWidget);

    // Verifikasi CTA utama & Google Login
    expect(find.text('Masuk ke Kumbung'), findsOneWidget);
    expect(find.text('ATAU'), findsOneWidget);
    expect(find.text('Lanjutkan dengan Google'), findsOneWidget);

    // Verifikasi info footer
    expect(find.textContaining('Daftar lewat Pengurus BUMDes'), findsOneWidget);
  });

  testWidgets('Toggle obscure text PIN berfungsi dengan baik',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Awalnya ikon visibility_off_outlined aktif
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    // Tap icon mata untuk menampilkan PIN
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();

    // Sekarang ikon berubah menjadi visibility_outlined
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('Mengetuk Lupa PIN menampilkan modal bantuan pemulihan PIN',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lupa PIN?'));
    await tester.pumpAndSettle();

    expect(find.text('Lupa PIN Masuk?'), findsOneWidget);
    expect(find.text('Bantuan Pemulihan Akun Petani'), findsOneWidget);
    expect(find.text('Mengerti'), findsOneWidget);

    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();

    expect(find.text('Lupa PIN Masuk?'), findsNothing);
  });

  testWidgets('Login berhasil memanggil callback onLoginSuccess',
      (WidgetTester tester) async {
    bool loginSuccessCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: LoginScreen(
          onLoginSuccess: () {
            loginSuccessCalled = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Input data petani
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), '081234567890');
    await tester.enterText(textFields.at(1), '123456');
    await tester.pump();

    // Pastikan tombol terlihat di viewport scroll
    final cta = find.text('Masuk ke Kumbung');
    await tester.ensureVisible(cta);
    await tester.tap(cta);
    await tester.pump(); // memicu loading

    // Tunggu delay simulasi autentikasi
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(loginSuccessCalled, isTrue);
  });
}
