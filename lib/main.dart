import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/onboarding_screen.dart';

void main() {
  runApp(const ProviderScope(child: TiramSehatApp()));
}

class TiramSehatApp extends StatelessWidget {
  const TiramSehatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiramSehat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Onboarding tampil sebelum login (lihat docs/CHANGE_REQUESTS.md CR-001).
      home: const OnboardingScreen(),
    );
  }
}

