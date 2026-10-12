class HarvestEntry {
  final String date;
  final double weightKg;
  final int pricePerKg;
  final int grossIncome;
  final String? note;

  const HarvestEntry({
    required this.date,
    required this.weightKg,
    required this.pricePerKg,
    required this.grossIncome,
    this.note,
  });
}

class BaglogCycle {
  final int cycleNo;
  final int total;
  final int healthy;
  final int treatable;
  final int discarded;
  final double healthRatio;

  const BaglogCycle({
    required this.cycleNo,
    required this.total,
    required this.healthy,
    required this.treatable,
    required this.discarded,
    required this.healthRatio,
  });
}

class SelfCheckData {
  final int checked;
  final int target;

  const SelfCheckData({required this.checked, required this.target});
}

enum HistorySectionCategory {
  actionRequired,
  recovered,
  archived,
}

class HistoryItem {
  final String id;
  final String name;
  final String badge;
  final String tone; // 'warning', 'danger', 'success', 'neutral'
  final String when;
  final String rack;
  final int col;
  final HistorySectionCategory category;
  final String? status;
  final String? tag;
  final String? note;
  final String? actionLabel;
  final bool isInitiallyExpanded;

  const HistoryItem({
    required this.id,
    required this.name,
    required this.badge,
    required this.tone,
    required this.when,
    required this.rack,
    required this.col,
    required this.category,
    this.status,
    this.tag,
    this.note,
    this.actionLabel,
    this.isInitiallyExpanded = false,
  });

  String get rackLocation => '$rack • Kolom $col';
}

class MockData {
  static const harvestLast = HarvestEntry(
    date: 'Kamis, 24 Okt 2024 - 07:30 WIB',
    weightKg: 18.5,
    pricePerKg: 15000,
    grossIncome: 277500,
  );

  static const cycle = BaglogCycle(
    cycleNo: 4,
    total: 2450,
    healthy: 2210,
    treatable: 165,
    discarded: 75,
    healthRatio: 0.902,
  );

  static const selfCheck = SelfCheckData(checked: 80, target: 100);

  static const List<HistoryItem> historyList = [
    // 1. Perlu Tindakan
    HistoryItem(
      id: 'h-01',
      name: 'Green Mold (Trichoderma sp.)',
      badge: 'Bisa Diobati',
      tone: 'warning',
      when: 'Hari ini, 09:15',
      rack: 'Rak Kumbung B-04',
      col: 3,
      category: HistorySectionCategory.actionRequired,
      isInitiallyExpanded: false,
    ),
    HistoryItem(
      id: 'h-02',
      name: 'Black Bread Mold (Rhizopus)',
      badge: 'Harus Dibuang',
      tone: 'danger',
      when: '22 Okt, 11:20',
      rack: 'Rak Kumbung C-01',
      col: 5,
      category: HistorySectionCategory.actionRequired,
      status: 'Status: Menunggu Pemusnahan',
      tag: 'Urgen',
      note: 'Segera bakar atau buang jauh dari kumbung agar spora hitam tidak menyebar ke baglog sehat di sekitarnya.',
      actionLabel: 'Konfirmasi Buang Baglog',
      isInitiallyExpanded: true,
    ),
    HistoryItem(
      id: 'h-03',
      name: 'Bacterial Brown Blotch',
      badge: 'Bisa Diobati',
      tone: 'warning',
      when: '21 Okt, 08:45',
      rack: 'Rak Kumbung A-07',
      col: 2,
      category: HistorySectionCategory.actionRequired,
      status: 'Status: Menunggu Desinfeksi',
      tag: 'Perawatan Ringan',
      note: 'Pembersihan permukaan bercak cokelat dengan lap bersih kering & semprot larutan kalsium hipoklorit encer.',
      actionLabel: 'Konfirmasi Selesai Diobati',
      isInitiallyExpanded: true,
    ),

    // 2. Selesai Diobati & Pulih
    HistoryItem(
      id: 'h-06',
      name: 'Cobweb Mold (Dactylium)',
      badge: 'Selesai Diobati',
      tone: 'success',
      when: '20 Okt, 14:10',
      rack: 'Rak Kumbung A-02',
      col: 1,
      category: HistorySectionCategory.recovered,
      status: 'Miselium Kembali Merambat Aktif',
      tag: 'Karantina Tuntas',
      note: 'Telah disemprot fungisida nabati rebusan sirih & kapur tohor. Spora putih laba-laba mati tuntas, miselium sehat telah menutup 95% kembali ke rak produksi.',
      isInitiallyExpanded: true,
    ),
    HistoryItem(
      id: 'h-07',
      name: 'Bacterial Wet Spot',
      badge: 'Selesai Diobati',
      tone: 'success',
      when: '19 Okt, 16:30',
      rack: 'Rak Kumbung B-09',
      col: 4,
      category: HistorySectionCategory.recovered,
      status: 'Area Berlendir Kering Sempurna',
      tag: 'Stabil',
      note: 'Sanitasi klorin encer berhasil membendung bakteri anaerob. Sirkulasi kumbung ditingkatkan, pinhead baru mulai terbentuk normal.',
      isInitiallyExpanded: true,
    ),

    // 3. Riwayat Terarsip
    HistoryItem(
      id: 'h-08',
      name: 'Yellow Mold (Mycelium …)',
      badge: 'Tersanitasi',
      tone: 'warning',
      when: '18 Okt',
      rack: 'Rak Kumbung A-03',
      col: 7,
      category: HistorySectionCategory.archived,
    ),
    HistoryItem(
      id: 'h-09',
      name: 'Neurospora crassa',
      badge: 'Telah Dibuang',
      tone: 'danger',
      when: '17 Okt',
      rack: 'Rak Kumbung D-02',
      col: 3,
      category: HistorySectionCategory.archived,
    ),
  ];
}
