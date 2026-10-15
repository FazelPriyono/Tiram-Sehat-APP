import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiram_sehat/core/theme/app_theme.dart';
import 'package:tiram_sehat/features/harvest/harvest_screen.dart';
import 'package:tiram_sehat/features/shell/app_shell.dart';
import 'package:tiram_sehat/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TiramSehatApp()));
    await tester.pumpAndSettle();
    expect(find.text('TiramSehat'), findsOneWidget);
  });

  testWidgets('Buku Panen menampilkan salinan §8.2 dan estimasi realtime',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: HarvestScreen()),
      ),
    );

    expect(find.text('Catat Hasil Panen'), findsOneWidget);
    expect(find.text('18,5 Kg × Rp 15.000'), findsOneWidget);
    expect(find.text('Rp 277.500'), findsOneWidget);
    expect(find.text('18,5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();

    expect(find.text('19,0'), findsOneWidget);
    expect(find.text('Rp 285.000'), findsOneWidget);
  });

  testWidgets('App shell membuka tab Buku Panen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppShell()),
    );

    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pump();

    expect(find.text('Catat Hasil Panen'), findsOneWidget);
  });
}
