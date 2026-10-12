import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiram_sehat/features/report/report_screen.dart';

void main() {
  testWidgets('ReportScreen renders title, segmented tabs, and all report cards', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReportScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Subtitle
    expect(find.text('Evaluasi & Laporan'), findsOneWidget);
    expect(
      find.text('Ikhtisar produksi jamur tiram dan performa finansial kumbung berbasis pencatatan mandiri.'),
      findsOneWidget,
    );

    // Verify Segmented Tabs
    expect(find.text('Minggu Ini'), findsOneWidget);
    expect(find.text('Bulan Ini'), findsOneWidget);
    expect(find.text('Tahun Ini'), findsOneWidget);

    // Verify Metric Tiles
    expect(find.text('Total Panen Hari Ini'), findsOneWidget);
    expect(find.text('24,5'), findsOneWidget);
    expect(find.text('Penjualan Hari Ini'), findsOneWidget);
    expect(find.text('Rp 367.500'), findsOneWidget);

    // Verify SectionCards
    expect(find.text('Tingkat Keberhasilan Panen'), findsOneWidget);
    expect(find.text('89,4%'), findsWidgets); // metric and chart
    expect(find.text('Akumulasi Bulan Ini'), findsOneWidget);
    expect(find.text('Total Pemasukan Panen'), findsOneWidget);
    expect(find.text('Rp 8.420.000'), findsOneWidget);
    expect(find.text('Estimasi Kerugian Baglog'), findsOneWidget);
    expect(find.text('Rp 420.000'), findsOneWidget);

    // Verify Batch Card & Action Button
    expect(find.text('Batch Panen K-04 Margomulyo'), findsOneWidget);
    expect(find.text('Unduh Rekap Laporan (CSV / PDF)'), findsOneWidget);
  });
}
