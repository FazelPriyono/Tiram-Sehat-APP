import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiram_sehat/features/history/history_screen.dart';

void main() {
  testWidgets('HistoryScreen renders title, search, filter chips, and sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HistoryScreen(),
        ),
      ),
    );
    await tester.pump();

    // Pastikan judul dan subtitle tampil
    expect(find.text('Riwayat Deteksi Baglog'), findsOneWidget);
    expect(
      find.text('Arsip inspeksi kamera & diagnosis on-device'),
      findsOneWidget,
    );

    // Pastikan filter chip tampil
    expect(find.textContaining('Semua Temuan'), findsOneWidget);
    expect(find.textContaining('Perlu Tindakan'), findsOneWidget);
    expect(find.text('Harus Dibuang (3)'), findsOneWidget);

    // Pastikan kartu pertama tampil
    expect(find.text('Green Mold (Trichoderma sp.)'), findsOneWidget);
  });
}
