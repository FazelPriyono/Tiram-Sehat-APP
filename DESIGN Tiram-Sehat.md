# TiramSehat — DESIGN.md
> PRD ringkas + Design System + Spesifikasi Layar untuk **slicing UI** oleh 5 anggota dengan bantuan AI agent.
> Dokumen ini adalah **konteks wajib** yang dibaca AI agent sebelum menulis kode apa pun.

---

## 0. Cara Memakai Dokumen Ini

**Untuk AI agent (WAJIB):**
1. Baca seluruh dokumen ini sebelum menulis kode.
2. Lihat screenshot layar yang menjadi tugasmu di `docs/design/` (nama file = nama layar, lihat §8).
3. **Urutan otoritas jika ada konflik:** `DESIGN.md` (terutama §5 token, §7 format, §10 keputusan) **>** screenshot. Screenshot hasil generate AI punya banyak ketidakkonsistenan yang sudah dikoreksi di §10.
4. Jangan menambah fitur, warna, font, ukuran, atau teks yang tidak ada di dokumen ini. Jika butuh, tulis di `docs/CHANGE_REQUESTS.md` dan tanyakan ke anggota yang bertanggung jawab (§4).
5. Jangan mengukur dari piksel screenshot (skala tiap gambar berbeda: lebar 399–487 px). Pakai token di §5.

**Untuk anggota tim sebelum membagikan file ini:**
- [ ] Isi bagian **§11.1 Tech Stack** (saat ini dikosongkan).
- [ ] Salin 7 screenshot ke `docs/design/` dengan nama persis seperti §8.
- [ ] Salin logo aplikasi (ikon jamur di header `beranda.png`) ke `assets/logo.png`.
- [ ] Sepakati bersama semua item di §10 (boleh diubah, tapi ubah **di dokumen ini**, bukan di kode masing-masing).
- [ ] Nilai warna di §5 adalah **estimasi dari screenshot**. Jika Stitch bisa mengekspor design system/CSS, ganti nilainya di sini sekali, lalu semua anggota ikut.

---

## 1. Ringkasan Produk

**TiramSehat** adalah aplikasi mobile **offline-first** untuk petani jamur tiram (konteks: petani BUMDes Margomulyo, kumbung berisi ribuan *baglog*). Fungsi utama:

1. **Scan baglog** memakai kamera. Model CNN **on-device** mendiagnosis kontaminasi (mis. *Green Mold / Trichoderma*) tanpa internet.
2. **Panduan mitigasi** langkah demi langkah per diagnosis (karantina, kerik, oles, observasi).
3. **Buku Panen** digital: catat berat panen + harga, estimasi pendapatan dihitung otomatis.
4. **Riwayat deteksi** baglog beserta status penanganan.
5. **Laporan** produksi dan finansial (mingguan/bulanan/musim tanam).

**Pengguna:** petani non-teknis, dipakai di kumbung (lembap, cahaya minim/terik, tangan basah). Bahasa Indonesia sederhana, tombol besar, teks terbaca jelas.

**Prinsip UX:** offline-first (tidak ada indikator loading jaringan), data tersimpan lokal (UI selalu menegaskan "Tersimpan Lokal"), satu tindakan utama per layar.

---

## 2. Lingkup Pekerjaan

**Fase ini (slicing UI) — IN SCOPE**
- 7 layar sesuai §8, dengan **data mock** (fixture di §9).
- Navigasi antar tab dan alur Scan → Hasil → Mitigasi → Riwayat.
- Interaksi UI dasar: stepper berat, chip harga, tab segmen, accordion kartu, bottom sheet, toggle, input teks.
- Responsif minimal untuk lebar 360–430 dp, safe area, scroll aman dari bottom nav.

**OUT OF SCOPE (jangan dikerjakan, jangan di-mock rumit)**
- Inferensi model CNN sungguhan, akses kamera sungguhan (pakai placeholder gambar/preview statis dulu kecuali tim memutuskan lain).
- Database SQLite / persistensi nyata, autentikasi, halaman Profil, sinkronisasi cloud.
- Ekspor CSV/PDF sungguhan (tombol cukup menampilkan feedback dummy).

---

## 3. Struktur Folder (feature-first)

```
assets/            logo.png, ikon/gambar contoh
docs/design/       7 screenshot sumber (jangan diedit)
docs/CHANGE_REQUESTS.md
src/
  core/theme/      tokens (warna, tipografi, radius, shadow, spacing)  ← Anggota A
  core/components/ komponen bersama (§6)                               ← Anggota A
  core/format/     helper format Rupiah, Kg, tanggal, persen (§7)      ← Anggota A
  mock/            fixture data (§9)
  features/
    home/          Beranda                                            ← Anggota B
    harvest/       Buku Panen                                         ← Anggota A
    scan/          Scan + Hasil Scan + Mitigasi                       ← Anggota C
    history/       Riwayat                                            ← Anggota D
    report/        Laporan                                            ← Anggota E
```
Sesuaikan ekstensi/konvensi nama dengan tech stack (§11.1). Jangan mengubah struktur ini sepihak.

---

## 4. Pembagian Kerja (5 anggota)

| Anggota | Tanggung jawab | Catatan |
|---|---|---|
| **A** | **Fondasi**: tokens/theme, semua komponen bersama (§6), helper format (§7), app shell + BottomNav + navigasi. Lalu layar **Buku Panen**. | **Blocker tim.** Hari pertama harus push token + *stub* komponen (props sesuai §6, tampilan boleh kasar) agar yang lain bisa import. Polish menyusul. |
| **B** | **Beranda** (`beranda.png`) | Banyak memakai MetricTile, SectionCard, ProgressBar. |
| **C** | **Alur Scan**: `scan.png`, `hasil_scan.png`, `mitigasi.png` | BottomSheet bertingkat + StepList. Paling kompleks secara interaksi. |
| **D** | **Riwayat** (`riwayat.png`) | Filter chip, pencarian, accordion kartu status, grup section. |
| **E** | **Laporan** (`laporan.png`) | SegmentedTabs, grafik garis 4 titik, kartu akumulasi, kartu batch. |

**Aturan lintas-anggota**
- Komponen yang dipakai ≥2 layar **hanya** dibuat/diubah oleh A (lewat PR kecil). Anggota lain **dilarang** membuat versi duplikat.
- Komponen yang hanya dipakai satu layar (mis. `HistoryItemCard`, `TrendChart`) boleh dibuat di folder fitur masing-masing.
- Jika komponen bersama kurang prop/variannya: buka PR kecil ke A atau tulis di `CHANGE_REQUESTS.md`; jangan menyalin-modifikasi.

---

## 5. Design Tokens

Gaya visual: **Soft UI / Neumorphism hijau**. Permukaan kartu berwarna hampir sama dengan latar, dibedakan oleh **bayangan ganda** (terang kiri-atas, gelap kanan-bawah). Nilai "angka penting" ditaruh di **inset well** (cekung). Tidak ada garis border tebal; border hanya tint tipis untuk kartu status (merah/amber/hijau).

> ⚠️ Nilai di bawah **estimasi dari screenshot**. Setelah dikunci tim, jangan ada hex di luar daftar ini.

### 5.1 Warna
```css
:root {
  /* Brand */
  --color-primary-800: #0F5E1B; /* angka/teks hijau tua, tombol primer */
  --color-primary-600: #2E7D32; /* FAB Scan, ikon & label tab aktif */
  --color-primary-400: #66BB6A; /* isi progress bar */
  --color-primary-100: #DDEBDC; /* latar lingkaran ikon lembut */
  --color-accent-chip: #B6F2B0; /* chip "Otomatis" */

  /* Surface */
  --color-bg:            #F2F7F1; /* latar halaman */
  --color-surface:       #EBEFEA; /* kartu raised */
  --color-surface-inset: #E1E5E0; /* well/inset */

  /* Text */
  --color-text-primary:   #1C201C;
  --color-text-secondary: #4B554B;
  --color-text-muted:     #6F7A6F;
  --color-text-on-primary:#FFFFFF;

  /* Semantic */
  --color-warning-500: #F59E0B; /* "Bisa Diobati", angka 165 */
  --color-warning-100: #FCEBCB;
  --color-danger-600:  #D32F2F; /* "Harus Dibuang", angka 75, kerugian */
  --color-danger-100:  #F8DADA;
  --color-danger-border:#E8B8B8;
  --color-success-600: #2E7D32; /* "Selesai Diobati" */
  --color-success-100: #DDEBDC;
}
```
Pemetaan status baglog → tone: **sehat/selesai = success**, **bisa diobati = warning**, **harus dibuang/afkir/terkontaminasi = danger**, **diarsipkan (tersanitasi/telah dibuang) = neutral dengan ikon**.

### 5.2 Tipografi
Satu keluarga font: **Plus Jakarta Sans** (fallback: system sans-serif). Jangan tambah font lain.

| Token | Ukuran/Line-height | Weight | Contoh |
|---|---|---|---|
| `metric-xl` | 40/48 | 800 | "Rp 277.500" |
| `metric-lg` | 28/34 | 700 | "2.450", "89,4%" |
| `metric-md` | 22/28 | 700 | "2.210", "18,5" |
| `h1` | 28/34 | 700 | "Kumbung Blok A", "Catat Hasil Panen" |
| `title-lg` | 18/24 | 700 | judul SectionCard |
| `title-md` | 16/22 | 600 | judul item, label field |
| `body` | 14/20 | 400 | paragraf, deskripsi |
| `body-sm` | 13/18 | 400 | helper text, footnote |
| `label` | 12/16 | 600 | badge, chip kecil |
| `eyebrow` | 12/16 | 700 | HURUF KAPITAL, letter-spacing 0.04em ("ESTIMASI PANEN HARI INI") |

Satuan (Kg, baglog, /Kg, rasio) memakai `body-sm` weight 500, warna `--color-text-secondary`, sejajar baseline dengan angka.

### 5.3 Radius, Spacing, Ukuran
```css
--radius-card: 28px;   /* SectionCard, kartu besar */
--radius-tile: 20px;   /* MetricTile, input well */
--radius-button: 18px; /* tombol lebar penuh */
--radius-pill: 999px;  /* badge, chip, tab */

/* skala 4 dp */
--space-1:4px; --space-2:8px; --space-3:12px; --space-4:16px;
--space-5:20px; --space-6:24px; --space-8:32px;

--page-padding-x: 20px;   /* tepi layar */
--card-padding: 20px;
--section-gap: 20px;      /* jarak antar kartu */
--tap-target-min: 48px;   /* semua elemen yang bisa disentuh */
--bottom-nav-height: 72px;/* + safe area; konten scroll beri padding-bottom >= 96px */
--design-width: 390px;    /* lebar acuan, layout harus fleksibel */
```

### 5.4 Bayangan (neumorphic)
```css
--shadow-raised:    8px 8px 18px rgba(150,168,150,.35), -8px -8px 18px rgba(255,255,255,.85);
--shadow-raised-sm: 4px 4px 10px rgba(150,168,150,.30), -4px -4px 10px rgba(255,255,255,.80);
--shadow-inset:     inset 4px 4px 8px rgba(150,168,150,.30), inset -4px -4px 8px rgba(255,255,255,.80);
--shadow-fab:       0 8px 20px rgba(46,125,50,.35);
--shadow-button-primary: 0 6px 14px rgba(15,94,27,.30);
```
Jika stack tidak mendukung inset shadow bawaan, **A membuat `NeuSurface` sekali** dan semua anggota memakainya. Jangan menirunya sendiri-sendiri.

### 5.5 Ikon
Satu set: **Material Symbols (Rounded/Outlined), weight 400**. Ikon di dalam lingkaran/rounded-square berlatar `--color-primary-100` (atau tint semantik) berukuran 40–48 dp. Jangan campur dengan set ikon lain.

Ikon yang dipakai (nama Material Symbols, perkiraan): `home`, `menu_book`, `photo_camera`, `bar_chart`, `history`, `person`, `payments`, `inventory_2`, `eco`, `bandage`/`healing`, `delete`, `monitoring`, `calendar_month`, `expand_more`, `add`, `remove`, `flashlight_on`, `photo_library`, `close`, `arrow_back`, `search`, `tune`, `check_circle`, `warning`, `cloud_off`, `database`, `download`, `savings`, `shield`, `lightbulb`.

---

## 6. Komponen Bersama (kontrak props)

Dimiliki **Anggota A** di `core/components/`. Nama prop di bawah dipatenkan agar semua anggota memakai API yang sama (sesuaikan sintaks dengan stack).

| Komponen | Props | Keterangan |
|---|---|---|
| `AppHeader` | `statusText = "Offline-Ready • Tersimpan Lokal"`, `onProfilePress` | Logo `assets/logo.png` + "TiramSehat" (title-lg, primary-800) + titik hijau + status (body-sm) + tombol profil bulat hijau di kanan. Dipakai di semua layar tab. **Tidak** dipakai di kamera fullscreen. |
| `BottomNav` | `active: 'home'\|'harvest'\|'scan'\|'report'\|'history'`, `onChange` | Urutan tetap: **Beranda, Buku Panen, Scan (tengah), Laporan, Riwayat**. Scan = FAB hijau bulat menonjol ke atas, label "Scan". Aktif: ikon+label `primary-600`; nonaktif: `text-muted`. |
| `NeuSurface` | `variant: 'raised'\|'inset'\|'flat'`, `radius`, `tone?: 'default'\|'danger'\|'warning'\|'success'` | Fondasi semua kartu. `tone` memberi tint border/latar tipis (kartu "Harus Dibuang" merah, "Bisa Diobati" amber). |
| `SectionCard` | `icon`, `title`, `trailing?`, `children` | Kartu besar `raised` dengan header ikon + judul (+ aksesori kanan, mis. chip "Siklus #04"). |
| `MetricTile` | `label`, `value`, `unit?`, `tone?`, `progress?: 0..1`, `icon?`, `variant: 'raised'\|'inset'`, `size: 'xl'\|'lg'\|'md'` | Label di atas, nilai besar, satuan kecil, progress bar opsional di bawah, ikon di pojok kanan. |
| `StatusBadge` | `label`, `tone: 'success'\|'warning'\|'danger'\|'info'\|'neutral'`, `icon?`, `solid?: boolean` | Pill. `solid` = latar penuh teks putih (mis. "Bisa Diobati" di sheet scan); non-solid = tint lembut. |
| `ProgressBar` | `value: 0..1`, `tone` | Tinggi 8 dp, track `surface-inset`, ujung membulat. |
| `Chip` | `label`, `selected`, `dotColor?`, `onPress` | Filter & pilihan cepat harga. |
| `SegmentedTabs` | `items: string[]`, `value`, `onChange` | Wadah inset, item aktif raised + teks hijau. |
| `ActionButton` | `label`, `icon?`, `variant: 'primary'\|'secondary'\|'danger'\|'warning'`, `fullWidth`, `onPress` | `primary` = isi hijau tua teks putih (+`shadow-button-primary`). `secondary` = raised, teks hijau. `danger`/`warning` = raised, teks & ikon merah/amber ("Konfirmasi Buang Baglog", "Konfirmasi Selesai Diobati"). Tinggi ≥ 52 dp. |
| `InfoNote` | `icon`, `text` | Catatan kaki ber-ikon (mis. ikon `cloud_off` + "Semua catatan tersimpan di memori perangkat ini"). |
| `StepList` | `steps: {title, description}[]` | Lingkaran bernomor + judul (title-md) + deskripsi (body-sm). Dipakai di Mitigasi. |
| `BottomSheet` | `snapPoints: ['peek','expanded']`, `onSnapChange`, `children` | Handle di atas, sudut atas radius 28. Dipakai di Hasil Scan. |
| `NumericStepperField` | `value`, `onChange`, `step=0.5`, `min=0`, `unit` | Input angka dengan tombol +/− (Buku Panen). |
| `CurrencyField` | `value`, `onChange`, `prefix="Rp"` | Tampilkan pemisah ribuan titik. |

---

## 7. Format Data & Copywriting (WAJIB konsisten)

- **Bahasa UI:** Bahasa Indonesia. **Salin teks persis** dari §8/§9; jangan diparafrasekan. Kode (nama variabel/komponen) memakai Bahasa Inggris.
- **Rupiah:** `Rp 277.500` (prefix "Rp" + spasi, pemisah ribuan **titik**). Helper: `formatRupiah(277500)`. Harga per kilo: `Rp 15.000 /Kg`.
- **Desimal:** **koma**. `18,5 Kg`, `90,2%`, `+7,4%`, `561,3 Kg`. (Beberapa screenshot salah memakai titik, lihat §10.)
- **Satuan:** `Kg` (K kapital), `baglog`, `cm`.
- **Tanggal:** `Kamis, 24 Okt 2024` (hari penuh + tanggal + bulan 3 huruf + tahun). Tanpa tahun untuk daftar: `22 Okt, 11:20`. Waktu 24-jam + zona: `07:30 WIB`. Bulan: Jan Feb Mar Apr Mei Jun Jul Agu Sep Okt Nov Des.
- **Persen:** `90,2%`, `80% Selesai`. Rasio baglog: `2.450 baglog` (titik ribuan).
- **Lokasi rak:** `Rak Kumbung B-04 • Kolom 3` (pemisah titik tengah `•` dengan spasi).
- **Teks panjang:** judul item daftar dipotong 1 baris dengan ellipsis (mis. "Green Mold (Trichoderm…").

---

## 8. Spesifikasi Layar

Pemetaan file → layar (`docs/design/`): `beranda.png`, `buku_panen.png`, `scan.png`, `hasil_scan.png`, `mitigasi.png`, `riwayat.png`, `laporan.png`.

Semua layar tab: `AppHeader` di atas, konten scroll, `BottomNav` melayang di bawah (konten diberi `padding-bottom` ≥ 96 dp).

### 8.1 Beranda — `beranda.png` — Anggota B
Sapaan: "Selamat Pagi, Petani BUMDes" (body, text-secondary) → **"Kumbung Blok A"** (h1) + tombol ikon `eco` raised di kanan. Pill: "● Offline-Ready • Model Vision On-Device Aktif".

1. **SectionCard "Estimasi Pendapatan Panen"** (ikon `payments`; chip kecil "Buku Panen" → navigasi ke Buku Panen)
   - Inset besar: eyebrow "ESTIMASI PANEN HARI INI", `metric-xl` "Rp 277.500", ikon `$` bulat di kanan.
   - Dua tile: "Berat Panen Terakhir" **18,5** Kg | "Harga Jual Rata-rata" **Rp 15.000** /Kg.
   - Baris inset: ikon jam + "Hasil Panen Terakhir:" / **"Kamis, 24 Okt 2024 - 07:30 WIB"**.
2. **SectionCard "Ringkasan Siklus Baglog"** (ikon `inventory_2`; trailing chip "Siklus #04")
   - Inset: eyebrow "TOTAL BAGLOG AKTIF", `metric-lg` **2.450** baglog, ikon daun.
   - Grid 2×2 MetricTile + ProgressBar: "Sehat Produktif" **2.210** (hijau) | "Bisa Diobati" **165** (amber, ikon bandage) | "Afkir / Dibuang" **75** (merah, ikon trash) | "Tingkat Sehat" **90,2%** rasio (hijau, ikon chart). Progress = nilai/2450 (kecuali "Tingkat Sehat" = 0,902).
3. **SectionCard "Pengecekan Mandiri Hari Ini"** (trailing teks hijau "Target: 100")
   - Inset: "80 dari 100 baglog dicek" + "**80% Selesai**" + ProgressBar 0,8.
   - Baris aksi raised: ikon kamera + **"Mulai Scan Kumbung"** + panah → navigasi ke Scan.
4. `InfoNote`: ikon `cloud_off` + "Semua catatan tersimpan di memori perangkat ini".

### 8.2 Buku Panen — `buku_panen.png` — Anggota A
Eyebrow "● BUKU PENCATATAN HARIAN" → h1 **"Catat Hasil Panen"** → subtitle "Buku kas panen digital harian mandiri tanpa internet".
1. **Tanggal Panen**: kartu raised, ikon kalender, label "TANGGAL PANEN" + "Kamis, 24 Okt 2024" + tombol bulat `expand_more` (buka date picker; default hari ini).
2. **"Berat Jamur Segar Dipanen"** (+ badge "Wajib"): `NumericStepperField` nilai **18,5**, unit "Kg", tombol +/− di kanan (step 0,5). Helper dengan ikon timbangan: "Timbang bersih hasil petik keranjang pagi ini".
3. **"Harga Jual per Kg"** (trailing "Tengkulak / Pasar"): `CurrencyField` "Rp **15.000**" + 3 Chip cepat `14k` `15k` `16k` (15k terpilih; menekan chip mengisi nilai 14.000/15.000/16.000). Helper ikon tag: "Rata-rata harga borongan saat ini Rp 14.000 - Rp 16.500".
4. **Kartu "Estimasi Pendapatan Kotor"** (chip "Otomatis"): baris "18,5 Kg × Rp 15.000" + "↗ Siap Buku Kas", nilai besar **Rp 277.500** (hasil = berat × harga, hitung realtime). Helper: "Estimasi langsung dikonversi ke riwayat laba petik".
5. **"Catatan Kumbung & Kondisi Petik"** (trailing "(Opsional)"): textarea inset, contoh isi: "Panen petik ke-3 kumbung selatan, kualitas baglog prima tanpa bercak."
6. `ActionButton primary fullWidth` ikon `save` **"Simpan Data Panen"**.
7. Footnote ikon centang: "Tersimpan di basis data lokal HP (Aman tanpa sinyal internet)".
- Validasi: berat wajib > 0, tombol Simpan nonaktif jika tidak valid. `[ASUMSI]` setelah simpan tampilkan snackbar "Data panen tersimpan" dan kembali ke Beranda.

### 8.3 Scan (viewfinder) — `scan.png` — Anggota C
**Layar penuh imersif**: tanpa AppHeader, tanpa BottomNav. Latar = preview kamera (placeholder foto baglog).
- Kiri atas: tombol bulat `arrow_back`. Tengah atas: pill "● Offline AI Siap • 1:1 FOCUS". Kanan atas: tombol bulat **flash/lampu kumbung** (toggle; aktif = latar amber).
- Di bawah pill: chip "📏 Jarak Optimal: **15 - 30 cm**".
- Tengah: 4 sudut siku hijau (frame) + reticle lingkaran putus-putus + titik hijau + persegi putih tipis. Label bawah frame: "Posisikan Cincin / Mulut Baglog".
- Kartu tips (raised, lebar penuh): "**Tips Petani:** Pastikan permukaan miselium bebas bayangan gelap tangan Anda."
- Bar bawah (surface): kiri tombol **"Makro"** (ikon fokus), tengah **shutter** besar hijau (lingkaran putih di dalam), kanan **"Galeri"** (ikon `photo_library`).
- **Jangan implementasikan** teks "0.5x 1x 2x", "VIDEO", "PRO" yang tampak samar di screenshot (sisa gambar kamera bawaan, bukan fitur).
- Aksi: shutter → transisi ke Hasil Scan (8.4). `[ASUMSI]` tampilkan state singkat "Menganalisis…" (≤1 dtk, mock).

### 8.4 Hasil Scan (bottom sheet, peek) — `hasil_scan.png` — Anggota C
Kamera tetap tampil di atas dengan:
- Kiri atas tombol `close` (kembali ke viewfinder), kanan atas toggle lampu; pill tengah "● KAMERA OFFLINE AI AKTIF".
- Kotak deteksi amber bersudut siku dengan label melayang "⚠ Trichoderma sp. 94%".

**BottomSheet** (snap `peek` ≈ 75% tinggi layar): handle + teks kecil "⌃ TARIK KE ATAS UNTUK DETAIL MITIGASI".
1. Eyebrow "HASIL DIAGNOSA VISUAL (ON-DEVICE AI)" + `StatusBadge solid warning` "Bisa Diobati".
2. Judul **"Green Mold"** (h1) + nama ilmiah italic "(*Trichoderma* sp.)"; kanan: "Lokasi Infeksi" / **"Cincin & Leher Baglog"** (hijau).
3. Kartu keyakinan: ikon otak, "Tingkat Keyakinan **94,2%**" + "Sangat Akurat" (hijau), subteks "Model On-Device CNN (Lokal Tanpa Internet) • …".
4. "Perbandingan Visual Lapangan" (trailing "Ketuk untuk zoom") → dua kartu foto berdampingan:
   - "Spora Hijau" (label amber di foto) — **"Bercak Terdeteksi"** (amber) — "Diameter 1,8 cm aktif"
   - "Miselium Sehat" (label hijau di foto) — **"Target Normal"** (hijau) — "Putih kapas tebal merata"
5. **"Panduan Tindakan Cepat"** (ikon medkit; trailing "4 Langkah") → `StepList` (teks lengkap di §9.3).
6. `ActionButton primary` **"Simpan ke Riwayat Scan"** → buat entri di Riwayat (mock) lalu navigasi ke tab Riwayat.
7. `ActionButton secondary` ikon kamera **"Scan Baglog Lainnya"** → kembali ke viewfinder.
- BottomNav **tidak tampil** di layar scan (lihat §10 #2).

### 8.5 Mitigasi (sheet expanded) — `mitigasi.png` — Anggota C
Konten **sama** dengan 8.4 tetapi sheet pada snap `expanded` (menutup preview kamera, konten sheet bisa discroll). Gunakan `mitigasi.png` sebagai referensi tata letak **konten** (urutan: header diagnosa → keyakinan → perbandingan → panduan → tombol). Elemen dalam screenshot ini yang **tidak dipakai**: kartu kamera "Kamera Siap" + chip "Lampu Kumbung AKTIF / 15 - 30 cm" (itu varian layout lama), dan teks "Tingkat Awal" di samping judul panduan (pakai "4 Langkah").

### 8.6 Riwayat — `riwayat.png` — Anggota D
Judul **"Riwayat Deteksi Baglog"** (h1) + subtitle "Arsip inspeksi kamera & diagnosis on-device" + tombol ikon `tune` di kanan.
- **Search** inset: ikon `search`, placeholder "Cari rak, nomor baglog, atau diagnosis...", ikon kalender di kanan.
- **Chip filter** (scroll horizontal): "● Semua Temuan (10)" (terpilih, hijau) · "● Perlu Tindakan (7)" (amber) · chip ketiga terpotong di screenshot, default `[ASUMSI]` "● Harus Dibuang (n)" merah.
- **Daftar kartu** (accordion; tiap kartu: thumbnail 56 dp bertitik status, badge status, waktu kanan-atas, nama diagnosis, lokasi rak, chevron):
  1. *Green Mold (Trichoderma sp.)* — `Bisa Diobati` — "Hari ini, 09:15" — Rak Kumbung B-04 • Kolom 3 — **collapsed**.
  2. *Black Bread Mold (Rhizopus)* — `Harus Dibuang` — 22 Okt, 11:20 — Rak Kumbung C-01 • Kolom 5 — **expanded, tone danger**: kotak "Status: Menunggu Pemusnahan" + badge "Urgen"; teks "Segera bakar atau buang jauh dari kumbung agar spora hitam tidak menyebar ke baglog sehat di sekitarnya."; `ActionButton danger` **"Konfirmasi Buang Baglog"**.
  3. *Bacterial Brown Blotch* — `Bisa Diobati` — 21 Okt, 08:45 — Rak Kumbung A-07 • Kolom 2 — **expanded, tone warning**: "Status: Menunggu Desinfeksi" + badge "Perawatan Ringan"; teks "Pembersihan permukaan bercak cokelat dengan lap bersih kering & semprot larutan kalsium hipoklorit encer."; `ActionButton warning` **"Konfirmasi Selesai Diobati"**.
- **Section "Selesai Diobati & Pulih (2 Baglog)"** (trailing badge hijau "2 Sembuh"): kartu tone success: *Cobweb Mold (Dactylium)* 20 Okt, 14:10, A-02 • Kolom 1, "Miselium Kembali Merambat Aktif" + badge "Karantina Tuntas"; *Bacterial Wet Spot* 19 Okt, 16:30, B-09 • Kolom 4, "Area Berlendir Kering Sempurna" + badge "Stabil" (teks penuh di §9.2).
- **Section "Riwayat Terarsip"** (trailing "Klik untuk buka"): 2 baris ringkas: *Yellow Mold (Myc…)* badge "Tersanitasi" A-03 • Kolom 7 • 18 Okt; *Neurospora cra…* badge "Telah Dibuang" D-02 • Kolom 3 • 17 Okt.
- Kartu aksi **"Inspeksi Manual Baglog"** / "Input manual tanpa bantuan kamera" + tombol `add` (dummy).
- Footer: pill ikon database "Tersimpan di SQLite internal • Kapasitas: 4,8 MB" dan teks "Dikelola oleh BUMDes Margomulyo • Siap Bekerja Offline".
- Interaksi: ketuk kartu = expand/collapse; tombol konfirmasi memindahkan item ke section "Selesai" (state lokal/mock); chip & search menyaring daftar.

### 8.7 Laporan — `laporan.png` — Anggota E
Judul **"Evaluasi & Laporan"** (h1) + chip "✓ BUMDes Margomulyo" kanan. Subtitle: "Ikhtisar produksi jamur tiram dan performa finansial kumbung berbasis pencatatan mandiri."
- `SegmentedTabs`: **Minggu Ini** (default) · Bulan Ini · Musim Tanam.
- Dua tile berdampingan:
  - "Total Panen Hari Ini" **24,5** Kg, badge "↗ +18%", "✓ +4,2 Kg dr kemarin".
  - "Penjualan Hari Ini" **Rp 367.500**, badge "Tunai", "🏷 Rp 15.000 / Kg".
- **SectionCard "Efisiensi Siklus Kumbung"** / judul "Tingkat Keberhasilan Panen" (ikon tunas):
  - Inset: **89,4%** `metric-xl` + "dari 2.400 Baglog" + badge solid hijau "👍 Sangat Prima".
  - Grafik garis area (4 titik): "Tren Kualitas Panen (4 Pekan)" kanan "+7,4% akumulatif"; titik M1: 82%, M2: 85%, M3: 88%, M4: 89,4% (titik terakhir ditonjolkan, area gradien hijau di bawah garis).
  - Legenda: "● 2.146 Sehat & Berbuah" (hijau) | "● 254 Terkontaminasi" (merah) + ProgressBar hijau dominan.
- **SectionCard "Akumulasi Bulan Ini"** (trailing "Okt 2024", ikon dompet):
  - "Total Pemasukan Panen" **Rp 8.420.000** / "Total bersih 561,3 Kg jamur segar" (ikon celengan).
  - "Estimasi Kerugian Baglog" (label merah + ikon info) **Rp 420.000** + pill merah "🛡 Ditekan 65% via deteksi dini" (ikon perisai amber di kanan).
  - Tip (ikon lampu): "Tindakan isolasi cepat pada **Rak Kumbung B** berhasil menyelamatkan sekitar 120 baglog terdekat dari spora jamur hijau (*Trichoderma*)."
- **Kartu batch**: thumbnail jamur + "**Batch Panen K-04 Margomulyo**" / "Varietas Florida Putih • Hari ke-42" + badge "98% Grade A" + "Timbang 07:30 WIB".
- `ActionButton secondary` ikon `download` **"Unduh Rekap Laporan (CSV / PDF)"** (dummy: snackbar). `InfoNote`: "Data disimpan di memori HP, siap dicetak kapan saja".
- `[ASUMSI]` Tab "Bulan Ini"/"Musim Tanam" boleh memakai fixture yang sama (belum ada desainnya); jangan mengarang layout baru.

---

## 9. Model Data & Fixture Mock

Letakkan di `src/mock/`. Satu sumber, dipakai bersama.

### 9.1 Tipe
```
HarvestEntry { id, date, weightKg, pricePerKg, grossIncome (= weightKg*pricePerKg), note? }
BaglogCycle  { cycleNo, total, healthy, treatable, discarded, healthRatio }
ScanResult   { id, diagnosisName, scientificName, confidence(0..1), infectionLocation,
               severity: 'treatable'|'mustDiscard', steps: Step[], rack, column, scannedAt }
HistoryItem  { id, scanResult, status: 'pending'|'treated'|'sanitized'|'discarded',
               statusLabel, statusNote, urgencyLabel? }
Step         { title, description }
```

### 9.2 Fixture inti
```
harvestLast   = { date: "Kamis, 24 Okt 2024 - 07:30 WIB", weightKg: 18.5, pricePerKg: 15000, grossIncome: 277500 }
cycle         = { cycleNo: 4, total: 2450, healthy: 2210, treatable: 165, discarded: 75, healthRatio: 0.902 }
selfCheck     = { checked: 80, target: 100 }

history = [
 { name: "Green Mold (Trichoderma sp.)",  badge: "Bisa Diobati",  when: "Hari ini, 09:15", rack: "Rak Kumbung B-04", col: 3 },
 { name: "Black Bread Mold (Rhizopus)",   badge: "Harus Dibuang", when: "22 Okt, 11:20",   rack: "Rak Kumbung C-01", col: 5, status: "Menunggu Pemusnahan", tag: "Urgen" },
 { name: "Bacterial Brown Blotch",        badge: "Bisa Diobati",  when: "21 Okt, 08:45",   rack: "Rak Kumbung A-07", col: 2, status: "Menunggu Desinfeksi", tag: "Perawatan Ringan" },
 { name: "Cobweb Mold (Dactylium)",       badge: "Selesai Diobati", when: "20 Okt, 14:10", rack: "Rak Kumbung A-02", col: 1,
   result: "Miselium Kembali Merambat Aktif", tag: "Karantina Tuntas",
   note: "Telah disemprot fungisida nabati rebusan sirih & kapur tohor. Spora putih laba-laba mati tuntas, miselium sehat telah menutup 95% kembali ke rak produksi." },
 { name: "Bacterial Wet Spot",            badge: "Selesai Diobati", when: "19 Okt, 16:30", rack: "Rak Kumbung B-09", col: 4,
   result: "Area Berlendir Kering Sempurna", tag: "Stabil",
   note: "Sanitasi klorin encer berhasil membendung bakteri anaerob. Sirkulasi kumbung ditingkatkan, pinhead baru mulai terbentuk normal." },
 archived: [ { name: "Yellow Mold (Mycelium …)", tag: "Tersanitasi", rack: "Rak Kumbung A-03", col: 7, when: "18 Okt" },
             { name: "Neurospora crassa",        tag: "Telah Dibuang", rack: "Rak Kumbung D-02", col: 3, when: "17 Okt" } ]
]

report = { todayKg: 24.5, deltaKg: 4.2, deltaPct: 18, salesToday: 367500,
           success: 0.894, totalBaglog: 2400, healthy: 2146, contaminated: 254,
           trend: [82, 85, 88, 89.4], trendDelta: 7.4,
           monthIncome: 8420000, monthKg: 561.3, monthLoss: 420000, lossReducedPct: 65,
           batch: { code: "K-04 Margomulyo", variety: "Florida Putih", day: 42, grade: "98% Grade A", weighedAt: "07:30 WIB" } }
```
> Angka antar layar **sengaja tidak direkonsiliasi** (mis. Beranda 2.450 baglog/90,2% vs Laporan 2.400/89,4%). Itu artefak desain; tiap layar memakai fixture-nya sendiri sampai ada keputusan data nyata.

### 9.3 Teks Mitigasi (Green Mold) — versi kanonik
1. **Pindahkan ke Rak Karantina** — Segera pisahkan baglog dari rak utama kumbung untuk mencegah penularan spora via sirkulasi udara lembap.
2. **Kerik Lembut Spora Hijau** — Gunakan sendok makan bersih yang telah disterilkan alkohol 70%. Kerik hingga batas miselium putih yang masih segar.
3. **Oles Larutan Kapur Tohor (CaCO3)** — Oleskan pasta kapur tohor pekat atau fungisida nabati rebusan daun sirih ke bekas kerokan untuk menaikkan pH lokal.
4. **Observasi Pemulihan 48 Jam** — Jika miselium putih tumbuh menutupi bekas luka, baglog aman. Jika spora menghitam/meluas, segera buang dari kumbung.

---

## 10. Keputusan atas Ketidakkonsistenan Desain

Screenshot dibuat dengan AI sehingga ada kontradiksi. **Keputusan default di bawah mengikat sampai tim mengubahnya di sini.**

| # | Temuan di screenshot | Keputusan |
|---|---|---|
| 1 | Logo header berupa kotak abu bertuliskan "img" di `buku_panen`, `laporan`, `mitigasi`, `riwayat` (dan melebar menimpa judul di `riwayat`). | Semua layar memakai logo ikon jamur dari `beranda.png` (`assets/logo.png`) lewat `AppHeader` yang sama. Teks status tidak boleh terpotong. |
| 2 | `hasil_scan.png` memakai bottom nav berbeda (Kumbung, Baglog, Scan AI, Riwayat, Profil). | **Salah.** Navigasi kanonik hanya 5 tab di §6. Layar scan imersif (viewfinder & hasil) **menyembunyikan** BottomNav. |
| 3 | Ada dua layout scan: fullscreen (`scan.png`, `hasil_scan.png`) dan kartu-kamera + hasil dalam satu halaman scroll dengan nav (`mitigasi.png`). | Kanonik = **fullscreen + bottom sheet** (§8.3–8.5). `mitigasi.png` hanya referensi konten sheet *expanded*. |
| 4 | Pemisah desimal titik: "24.5 Kg", "89.4%", "561.3 Kg", "+7.4%", "+4.2 Kg". | Selalu **koma** (§7). |
| 5 | Input harga "Rp 15000" tanpa pemisah ribuan. | Tampilkan "Rp 15.000". |
| 6 | Judul section "Riwayat Terarsip (Unexpanded)". | Tulis **"Riwayat Terarsip"**; "(Unexpanded)" adalah catatan desainer. |
| 7 | Teks langkah mitigasi sedikit berbeda antara `hasil_scan` dan `mitigasi`. | Pakai versi §9.3 (dari `hasil_scan`). |
| 8 | Elemen kamera bawaan tampak samar di `scan.png` ("0.5x 1x 2x", "VIDEO", "PRO"); tombol kanan-atas kosong. | Tidak diimplementasikan. Kanan-atas = toggle lampu, kiri-atas = back/close (§8.3). |
| 9 | Chip filter ketiga di Riwayat terpotong. | Default "Harus Dibuang (n)" merah; ubah di sini bila tidak cocok. |
| 10 | Judul/teks terpotong di `riwayat` ("Trichoderm…", "(Myc…", "Neurospora cra…", "18 Ok…"). | Itu ellipsis layar sempit; implementasikan ellipsis 1 baris, **bukan** menyalin teks terpotong (nama lengkap di §9.2). |
| 11 | Kontras teks kecil abu-hijau di atas permukaan neumorphic rendah. | Jika ragu, pilih keterbacaan: teks body minimal kontras 4,5:1. Lapor ke A bila perlu token teks lebih gelap. |

---

## 11. Aturan Teknis & Kolaborasi

### 11.1 Tech Stack — ISI SEBELUM DIBAGIKAN
```
Platform / framework : flutter (mis. Flutter / React Native / Next.js PWA / HTML+Tailwind)
Bahasa               : dart
State management     : riverpod (untuk slicing cukup state lokal sederhana)
Router / navigasi    : go router
Library UI tambahan  : TIDAK ADA tanpa persetujuan A
Library grafik       : gunakan yang sesuai (satu saja, ditentukan E dan disetujui A)
Versi font/ikon      : Plus Jakarta Sans, Material Symbols
```

### 11.2 Aturan untuk AI agent
**Boleh:** memakai token & komponen bersama; menambah komponen khusus-layar di folder fitur sendiri; menambah fixture di `src/mock/` yang sesuai §9.
**Dilarang:**
- Hardcode warna/ukuran/font di layar (selalu token §5).
- Membuat versi baru dari komponen §6 (Card, Badge, Button, Chip, ProgressBar, dst.).
- Mengubah copy teks, urutan tab, atau struktur folder.
- Menambah fitur di luar §2, memasang dependensi baru, atau mengubah file milik anggota lain.
- Menulis komentar/penjelasan panjang di kode; cukup nama yang jelas.

Jika ada hal yang ambigu: **pilih opsi paling sederhana yang sesuai §5–§9 dan catat di `docs/CHANGE_REQUESTS.md`**, jangan mengarang desain.

### 11.3 Git
- Branch: `feat/<layar>` (mis. `feat/home`, `feat/scan`) dari `develop`.
- Urutan merge: **A (token + komponen stub) dulu**, lalu B–E rebase dan lanjut.
- 1 PR = 1 layar/komponen; judul `feat(home): ...`, `fix(core): ...`. Minta review silang 1 anggota lain.
- Dilarang mengedit `core/` dari branch layar kecuali lewat PR terpisah ke A.

---

## 12. Definition of Done per Layar

- [ ] Struktur, urutan elemen, dan **seluruh teks** sama dengan §8/§9 (copy persis).
- [ ] Hanya memakai token (§5) dan komponen bersama (§6); tidak ada hex/ukuran hardcode.
- [ ] Format data sesuai §7 (Rp, koma desimal, tanggal Indonesia).
- [ ] Tampil benar di lebar 360, 390, dan 430 dp; tidak ada overflow horizontal; teks panjang ber-ellipsis.
- [ ] Area sentuh ≥ 48 dp; konten tidak tertutup BottomNav / safe area.
- [ ] Interaksi di §8 berfungsi dengan data mock (accordion, tab, chip, stepper, sheet, navigasi).
- [ ] Perbandingan visual dengan screenshot: selisih tata letak ≤ 4 dp (selisih akibat koreksi §10 dibenarkan).
- [ ] Tidak ada warning/error di konsol atau analyzer.

---

## 13. Template Prompt untuk AI Agent (tempel di awal sesi tiap anggota)

```
Kamu adalah AI agent yang membantu saya melakukan slicing UI aplikasi TiramSehat.

1. Baca DESIGN.md sepenuhnya, terutama §5 (token), §6 (komponen), §7 (format), §10 (keputusan).
2. Lihat screenshot di docs/design/ untuk layar saya.

Peran saya: Anggota A
Tugas: Beranda (beranda.png) dan komponen 

Aturan keras:
- Ikuti DESIGN.md di atas screenshot jika konflik.
- Jangan membuat warna, font, ukuran, atau komponen baru di luar DESIGN.md.
- Salin teks UI persis dari §8/§9. Pakai fixture di src/mock/.
- Hanya ubah file di folder fitur milikku. Untuk perubahan di core/, tulis di docs/CHANGE_REQUESTS.md.
- Kerjakan bertahap: (1) kerangka layout, (2) isi + data mock, (3) interaksi, (4) cek Definition of Done §12.

Mulai dengan merangkum rencana implementasi layarku dalam maksimal 10 poin sebelum menulis kode.
```
