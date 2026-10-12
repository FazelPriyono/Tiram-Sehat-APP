# CHANGE REQUESTS

Dokumen permintaan perubahan lintas-anggota. Lihat `DESIGN Tiram-Sehat.md` §11.2.

---

## CR-001 — Aktivasi tab Scan ke layar immersive (Anggota C → Anggota A)

- **Oleh:** Anggota C (Ryan)
- **File terkait:** `lib/features/shell/app_shell.dart` (milik Anggota A)
- **Status:** MENUNGGU PERSETUJUAN A

### Alasan

`DESIGN Tiram-Sehat.md` §8.3–§8.5 & §10 #2 mensyaratkan layar Scan **fullscreen
immersif**: tanpa `AppHeader`, tanpa `BottomNav`. Layar ini sudah selesai
dikerjakan di `lib/features/scan/scan_screen.dart` tetapi belum direferensikan
dari shell, sehingga tab Scan masih menampilkan `_PlaceholderScreen`.

### Perubahan yang diminta

Di `_buildBody()`:

```dart
case BottomNavTab.scan:
  return ScanScreen(
    onBack: () => setState(() => _activeTab = BottomNavTab.home),
    onSavedToHistory: () => setState(() => _activeTab = BottomNavTab.history),
  );
```

Di `build()` — sembunyikan header & nav saat tab Scan aktif:

```dart
final immersive = _activeTab == BottomNavTab.scan;

return Scaffold(
  backgroundColor: AppColors.bg,
  appBar: immersive ? null : const AppHeader(),
  body: _buildBody(),
  bottomNavigationBar: immersive
      ? null
      : BottomNav(active: _activeTab, onChange: (tab) => setState(() => _activeTab = tab)),
);
```

### Catatan implementasi

- Import: `import '../scan/scan_screen.dart';`
- Tidak ada perubahan urutan tab, copy, maupun struktur folder.
- `onSavedToHistory` dipakai oleh tombol "Simpan ke Riwayat Scan" (§8.4 butir 6)
  untuk berpindah ke tab Riwayat. Saat layar Riwayat (Anggota D) belum ada,
  tab tersebut masih placeholder — tidak masalah.
