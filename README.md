# TiramSehat

> **Aplikasi manajemen kesehatan baglog & panen jamur tiram untuk petani BUMDes Margomulyo.**

TiramSehat adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk membantu petani jamur tiram di bawah naungan BUMDes Margomulyo dalam memantau kondisi kesehatan baglog, mencatat hasil panen, mendeteksi dini penyakit jamur melalui kamera, serta menghasilkan laporan produksi secara ringkas — semua dalam satu genggaman.

---

## Tujuan Aplikasi

| Masalah | Solusi TiramSehat |
|---|---|
| Deteksi penyakit baglog yang terlambat & subjektif | Scan kamera dengan analisis visual langsung di perangkat |
| Pencatatan panen masih manual & rawan hilang | Form pencatatan digital dengan kalkulasi otomatis |
| Tidak ada gambaran kondisi kumbung secara real-time | Beranda ringkasan dengan data siklus baglog & estimasi pendapatan |
| Laporan produksi sulit dibuat & tidak konsisten | Halaman laporan dengan grafik tren & ringkasan bulanan |

---

## Fitur Utama

### Beranda (Home)
- Sapaan otomatis sesuai waktu & informasi kumbung yang sedang dipantau
- **Estimasi pendapatan panen hari ini** — dihitung otomatis dari berat × harga jual
- **Ringkasan siklus baglog** — total aktif, sehat produktif, bisa diobati, afkir, dan tingkat kesehatan
- **Target pengecekan harian** — indikator pencapaian jumlah baglog yang sudah diperiksa
- Tombol **"Mulai Scan Kumbung"** yang langsung membuka halaman scan

### Scan Kumbung (Scan)
- Tampilan kamera layar penuh agar proses pemindaian baglog lebih leluasa dan jelas
- Deteksi otomatis kondisi baglog melalui kamera — mendeteksi jenis penyakit jamur, lokasi infeksi, dan tingkat keparahannya
- Hasil scan menampilkan: nama diagnosis, nama ilmiah, tingkat akurasi deteksi, dan rekomendasi langkah penanganan bertahap
- Opsi simpan hasil ke riwayat

### Catat Panen (Harvest)
- Form pencatatan berat panen (Kg) dan harga jual per Kg
- Hitung otomatis total pendapatan kotor (sebelum dikurangi biaya)
- Pilihan tanggal & waktu panen
- Kolom catatan tambahan (jika diperlukan)

### Riwayat Diagnosa (History)
- Daftar riwayat scan tersusun dalam 3 kategori: **Perlu Tindakan**, **Selesai Diobati & Pulih**, dan **Riwayat Terarsip**
- Daftar riwayat yang bisa diklik untuk melihat detail lengkap dengan detail status, catatan penanganan, dan tombol konfirmasi
- Label warna sesuai kondisi baglog (Kuning: Waspada, Merah: Bahaya, Hijau: Sehat/Pulih)

### Laporan Produksi (Report)
- Ringkasan produksi harian: berat panen serta selisihnya (naik/turun) dibandingkan hari sebelumnya
- Grafik tren tingkat kesehatan baglog
- Rangkuman bulanan: pendapatan, total panen Kg, estimasi kerugian yang berhasil dicegah
- Informasi kelompok (batch) tanam yang sedang berjalan (jenis jamur, usia hari, dan kualitas/grade)

### Autentikasi (Auth)
- **Onboarding screen** bertahap — memperkenalkan fitur utama aplikasi kepada pengguna baru
- **Login screen** — mendukung login email/password dan Google Sign-In
- Desain visual modern dengan ilustrasi animasi

---

## Alur Penggunaan

```
Buka Aplikasi
     │
     ▼
[Onboarding] ──► [Login / Google Sign-In]
                        │
                        ▼
              ┌─────[Beranda]─────┐
              │         │         │
              ▼         ▼         ▼
           [Scan]   [Panen]   [Laporan]
              │
              ▼
       [Hasil Diagnosa]
              │
      ┌───────┴───────┐
      ▼               ▼
  Simpan ke        Abaikan
  [Riwayat]
      │
      ▼
  Konfirmasi
  Tindakan Lanjut
```

---

## Struktur Inti Proyek

```
lib/
├── main.dart                    # Entry point — ProviderScope + MaterialApp
│
├── core/
│   ├── theme/
│   │   ├── tokens.dart          # Design tokens: warna, spacing, radius, dll.
│   │   └── app_theme.dart       # ThemeData utama aplikasi
│   ├── components/              # Widget reusable (15 komponen)
│   │   ├── neu_surface.dart     # Komponen neumorphic raised/inset
│   │   ├── section_card.dart    # Card section berheader
│   │   ├── bottom_nav.dart      # Bottom navigation bar kustom
│   │   ├── app_header.dart      # AppBar kustom
│   │   ├── metric_tile.dart     # Tile metrik animasi
│   │   ├── status_badge.dart    # Badge status warna
│   │   ├── step_list.dart       # Daftar langkah penanganan
│   │   └── ...                  # Dan komponen lainnya
│   └── format/
│       └── format_helper.dart   # Helper format angka & tanggal
│
├── features/
│   ├── auth/
│   │   ├── onboarding_screen.dart    # Onboarding multi-langkah
│   │   ├── onboarding_content.dart   # Konten tiap slide onboarding
│   │   ├── login_screen.dart         # Halaman login
│   │   └── widgets/
│   │       └── onboarding_illustration.dart  # Ilustrasi SVG animasi
│   ├── home/
│   │   └── home_screen.dart     # Beranda dengan count-up animation
│   ├── scan/
│   │   ├── scan_screen.dart     # Kamera scan fullscreen
│   │   └── widgets/             # Widget hasil scan & langkah penanganan
│   ├── harvest/
│   │   └── harvest_screen.dart  # Form pencatatan panen
│   ├── history/
│   │   ├── history_screen.dart  # Daftar riwayat diagnosa
│   │   └── widgets/             # Kartu riwayat (aktif & arsip)
│   ├── report/
│   │   └── report_screen.dart   # Laporan produksi & grafik
│   └── shell/
│       └── app_shell.dart       # Scaffold utama + bottom nav + routing tab
│
├── mock/
│   └── mock_data.dart           # Data dummy seluruh fitur (dev/prototype)
│
assets/
├── logo.png                     # Logo TiramSehat
└── Google_Icon_Colored.png      # Ikon Google untuk tombol login

docs/
└── design/                      # Screenshot & mockup desain UI
    ├── Login_Page.png
    └── onboarding.png

test/
├── login_screen_test.dart
├── onboarding_screen_test.dart
└── widget_test.dart
```

---

## Tech Stack

| Kategori | Teknologi |
|---|---|
| Framework | Flutter 3.x (Dart ≥ 3.13.1) |
| State Management | [flutter_riverpod](https://riverpod.dev/) `^2.6.1` |
| Routing | [go_router](https://pub.dev/packages/go_router) `^14.6.1` |
| Tipografi | [google_fonts](https://pub.dev/packages/google_fonts) `^6.2.1` — Plus Jakarta Sans |
| Desain | Neumorphic design system berbasis `NeuSurface` |
| Ikon | Material Icons (bawaan Flutter) |
| Linting | flutter_lints `^6.0.0` |

---

## Cara Menjalankan

### Prasyarat

- Flutter SDK `>=3.13.1` — [Panduan instalasi](https://docs.flutter.dev/get-started/install)
- Dart SDK (sudah termasuk dalam Flutter)
- Android Studio / VS Code dengan ekstensi Flutter
- Emulator Android / iOS **atau** perangkat fisik

### Langkah

```bash
# 1. Clone repositori
git clone https://github.com/IlhamDharm/Tiram-Sehat-APP.git
cd Tiram-Sehat-APP

# 2. Ambil branch pengembangan
git checkout Dev

# 3. Install dependensi
flutter pub get

# 4. Jalankan aplikasi (mode debug)
flutter run

# 5. Atau jalankan di perangkat/emulator tertentu
flutter devices          # lihat daftar perangkat
flutter run -d <device_id>
```

---

## Build Produksi

```bash
# Android — APK release
flutter build apk --release

# Android — App Bundle (direkomendasikan untuk Play Store)
flutter build appbundle --release

# Output APK:
# build/app/outputs/flutter-apk/app-release.apk
```

> **Catatan:** Pastikan file `android/key.properties` dan keystore sudah dikonfigurasi sebelum build release untuk distribusi.

---

## Menjalankan Tes

```bash
# Jalankan semua unit & widget test
flutter test

# Jalankan file test tertentu
flutter test test/login_screen_test.dart
flutter test test/onboarding_screen_test.dart
```

---

## Alur Git & Branching

| Branch | Fungsi |
|---|---|
| `Dev` | Branch pengembangan utama — semua fitur di-merge ke sini |
| `fazel`, `ilham`, dll. | Branch per-kontributor — dikerjakan lalu PR ke `Dev` |
| `main` / `master` | *(Jika ada)* Branch produksi stabil |

**Alur kontribusi:**
```
Branch pribadi → Commit → Push → Pull Request ke Dev → Review → Merge
```

---


## Tim Pengembang

Proyek ini dikembangkan sebagai bagian dari mata kuliah **Project Based Learning (PBL)**, Program Studi Sarjana Terapan Teknik Informatika — **Politeknik Negeri Malang**, Tahun Akademik 2026/2027.

| No. | Nama | NIM |
|:---:|---|:---:|
| 1 | Achmad Nabil Afgareza | 244107020001 |
| 2 | Amin Aziz Sudjud | 244107020079 |
| 3 | Aryan Zuda Firdaus | 244107020060 |
| 4 | Fazel Priyono | 244107020033 |
| 5 | Ilham Dharma Atmaja | 244107020220 |

---

## Konteks Proyek

**TiramSehat** menggunakan **Computer Vision** dengan model CNN/MobileNet yang dikonversi ke **TensorFlow Lite** dan dijalankan secara **on-device** pada smartphone. Pengguna mengambil gambar baglog melalui kamera, lalu sistem melakukan klasifikasi dan menampilkan status **Sehat / Terkontaminasi** beserta confidence score serta rekomendasi mitigasi apabila ditemukan kontaminasi.

- **Target Pengguna:** Petani dan pengelola BUMDes Desa Margomulyo, Kabupaten Banyuwangi
- **Lokasi Pengujian:** Kumbung budidaya jamur tiram BUMDes Desa Margomulyo
- **Durasi Pengembangan:** 16 minggu (PBL Semester 5)

---

## Lisensi

Proyek ini bersifat **privat** dan dikembangkan untuk keperluan akademik dan operasional BUMDes Margomulyo. Dilarang mendistribusikan atau mereplikasi tanpa izin.
