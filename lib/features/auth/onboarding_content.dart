import 'package:flutter/material.dart';

/// Jenis ilustrasi untuk tiap langkah onboarding.
enum OnboardingStepKind { scan, solution, harvest }

/// Satu halaman onboarding.
///
/// [highlightTitle]/[highlightSubtitle] mengisi kartu kecil yang mengambang di
/// atas ilustrasi, sedangkan [badgeLabel] mengisi pill di dalam scene.
class OnboardingStep {
  final String pillLabel;
  final String title;
  final String description;
  final OnboardingStepKind kind;
  final IconData highlightIcon;
  final String highlightTitle;
  final String highlightSubtitle;
  final String badgeLabel;

  const OnboardingStep({
    required this.pillLabel,
    required this.title,
    required this.description,
    required this.kind,
    required this.highlightIcon,
    required this.highlightTitle,
    required this.highlightSubtitle,
    required this.badgeLabel,
  });
}

/// Teks onboarding dipisah dari widget agar mudah ditinjau tim.
///
/// Halaman 1 disalin persis dari `docs/design/onboarding.png`. Halaman 2 dan 3
/// belum punya mockup sehingga isinya diringkas dari ringkasan produk
/// `DESIGN_Tiram_Sehat.md` §1 (panduan mitigasi & buku panen), bukan fitur baru.
/// Klaim angka pada mockup ("98% Akurat", "Pertumbuhan 92%") tidak dipakai
/// karena tidak bisa dibuktikan.
class OnboardingContent {
  static const String brandName = 'TiramSehat';
  static const String skipLabel = 'Lewati';
  static const String nextLabel = 'Lanjut';
  static const String startLabel = 'Mulai Sekarang';
  static const String offlineNote =
      'Semua catatan tersimpan di memori perangkat ini';

  static const List<OnboardingStep> steps = [
    OnboardingStep(
      pillLabel: '1. Pindai',
      title: 'Deteksi Cepat Kontaminasi Baglog',
      description:
          'Cukup arahkan kamera ke baglog jamur tiram untuk mengenali hama dan kontaminasi sejak dini dalam hitungan detik.',
      kind: OnboardingStepKind.scan,
      highlightIcon: Icons.check_circle_rounded,
      highlightTitle: 'Deteksi On-Device',
      highlightSubtitle: 'Kontaminasi Baglog',
      badgeLabel: 'Offline AI Aktif',
    ),
    OnboardingStep(
      pillLabel: '2. Solusi',
      title: 'Panduan Mitigasi Langkah demi Langkah',
      description:
          'Setiap diagnosis disertai langkah penanganan yang jelas, dari karantina baglog, kerik spora, hingga observasi pemulihan.',
      kind: OnboardingStepKind.solution,
      highlightIcon: Icons.healing_rounded,
      highlightTitle: 'Bisa Diobati',
      highlightSubtitle: 'Panduan 4 Langkah',
      badgeLabel: '4 Langkah Mitigasi',
    ),
    OnboardingStep(
      pillLabel: '3. Panen',
      title: 'Catat Panen & Estimasi Pendapatan',
      description:
          'Catat berat panen dan harga jual per kilogram. Estimasi pendapatan dihitung otomatis dan tersimpan di buku kas digital kumbung.',
      kind: OnboardingStepKind.harvest,
      highlightIcon: Icons.savings_rounded,
      highlightTitle: 'Tersimpan Lokal',
      highlightSubtitle: 'Buku Kas Panen',
      badgeLabel: 'Estimasi Otomatis',
    ),
  ];
}
