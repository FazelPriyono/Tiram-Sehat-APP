# Change Requests

Permintaan perubahan untuk file yang **bukan** folder fitur ini (DESIGN.md §0.4, §11.2).
Diajukan oleh **Anggota A** — layar **Buku Panen** (`lib/features/harvest`).

## Permintaan ke pemilik `core/`

| # | File | Permintaan | Alasan |
|---|---|---|---|
| 1 | `lib/core/format/format_helper.dart` | Tambahkan `static String tanggalPanjang(DateTime date)` yang menghasilkan `"Kamis, 24 Okt 2024"` (nama hari penuh + tanggal + bulan 3 huruf + tahun), sesuai DESIGN.md §7. | Saat ini `FormatHelper` belum punya formatter tanggal. Sementara saya implementasikan sebagai helper privat `_formatTanggalPanjang` di dalam `harvest_screen.dart`; pindahkan ke core agar dipakai bersama (Riwayat/Laporan). |
| 2 | `lib/core/format/format_helper.dart` | Pertimbangkan `tanggalPendek(DateTime)` → `"22 Okt, 11:20"` dan `jamWib(DateTime)` → `"07:30 WIB"`. | Dibutuhkan Riwayat (§8.6) dan Laporan (§8.7). |

## Perubahan yang saya lakukan di luar folder fitur (mohon review)

| # | File | Perubahan | Alasan |
|---|---|---|---|
| 3 | `lib/features/shell/app_shell.dart` | Ganti placeholder tab `harvest` menjadi `HarvestScreen(onSaved: ...)`; tambah 1 import. | App shell + navigasi adalah tanggung jawab Anggota A (§4). Hanya 1 case + 1 import berubah. |
| 4 | `test/widget_test.dart` | Ganti test bawaan (rusak: mereferensikan `MyApp` yang tidak ada) menjadi smoke test Buku Panen + AppShell. | `flutter analyze` gagal karena error ini; perlu agar Definition of Done §12 (tanpa error analyzer) terpenuhi. |

## Catatan kesesuaian DESIGN.md (§10)

| # | Topik | Status |
|---|---|---|
| 5 | Logo header pakai `Icons.eco_rounded` (bukan `assets/logo.png`) | Sudah demikian di `AppHeader` bawaan `Dev`; konsisten §10 #1. Tidak diubah. |
| 6 | Font **Plus Jakarta Sans** | Sudah via `google_fonts` di fondasi `Dev`. Selesai. |
| 7 | Chip harga `14k / 15k / 16k` | Memakai `AppChip` fondasi `Dev` (label pendek), sesuai §8.2. |
