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

<<<<<<< HEAD
class ScanStep {
  final String title;
  final String description;

  const ScanStep({required this.title, required this.description});
}

enum ScanSeverity { treatable, mustDiscard }

class ScanResult {
  final String id;
  final String diagnosisName;
  final String scientificName;
  final double confidence;
  final String infectionLocation;
  final ScanSeverity severity;
  final List<ScanStep> steps;
  final String rack;
  final int column;
  final String scannedAt;

  const ScanResult({
    required this.id,
    required this.diagnosisName,
    required this.scientificName,
    required this.confidence,
    required this.infectionLocation,
    required this.severity,
    required this.steps,
    required this.rack,
    required this.column,
    required this.scannedAt,
  });
=======
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
>>>>>>> Dev
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

<<<<<<< HEAD
  static const scanResult = ScanResult(
    id: 'scan-0001',
    diagnosisName: 'Green Mold',
    scientificName: 'Trichoderma sp.',
    confidence: 0.942,
    infectionLocation: 'Cincin & Leher Baglog',
    severity: ScanSeverity.treatable,
    steps: [
      ScanStep(
        title: 'Pindahkan ke Rak Karantina',
        description:
            'Segera pisahkan baglog dari rak utama kumbung untuk mencegah penularan spora via sirkulasi udara lembap.',
      ),
      ScanStep(
        title: 'Kerik Lembut Spora Hijau',
        description:
            'Gunakan sendok makan bersih yang telah disterilkan alkohol 70%. Kerik hingga batas miselium putih yang masih segar.',
      ),
      ScanStep(
        title: 'Oles Larutan Kapur Tohor (CaCO3)',
        description:
            'Oleskan pasta kapur tohor pekat atau fungisida nabati rebusan daun sirih ke bekas kerokan untuk menaikkan pH lokal.',
      ),
      ScanStep(
        title: 'Observasi Pemulihan 48 Jam',
        description:
            'Jika miselium putih tumbuh menutupi bekas luka, baglog aman. Jika spora menghitam/meluas, segera buang dari kumbung.',
      ),
    ],
    rack: 'Rak Kumbung B-04',
    column: 3,
    scannedAt: 'Hari ini, 09:15',
=======
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

  static const report = ReportData(
    todayKg: 24.5,
    deltaKg: 4.2,
    deltaPct: 18.0,
    salesToday: 367500,
    pricePerKg: 15000,
    success: 0.894,
    totalBaglog: 2400,
    healthy: 2146,
    contaminated: 254,
    trend: [82.0, 85.0, 88.0, 89.4],
    trendDelta: 7.4,
    monthIncome: 8420000,
    monthKg: 561.3,
    monthLoss: 420000,
    lossReducedPct: 65,
    batch: BatchData(
      code: 'Batch Panen K-04 Margomulyo',
      variety: 'Florida Putih',
      day: 42,
      grade: '98% Grade A',
      weighedAt: '07:30 WIB',
    ),
>>>>>>> Dev
  );
}

class BatchData {
  final String code;
  final String variety;
  final int day;
  final String grade;
  final String weighedAt;

  const BatchData({
    required this.code,
    required this.variety,
    required this.day,
    required this.grade,
    required this.weighedAt,
  });
}

class ReportData {
  final double todayKg;
  final double deltaKg;
  final double deltaPct;
  final int salesToday;
  final int pricePerKg;
  final double success;
  final int totalBaglog;
  final int healthy;
  final int contaminated;
  final List<double> trend;
  final double trendDelta;
  final int monthIncome;
  final double monthKg;
  final int monthLoss;
  final int lossReducedPct;
  final BatchData batch;

  const ReportData({
    required this.todayKg,
    required this.deltaKg,
    required this.deltaPct,
    required this.salesToday,
    required this.pricePerKg,
    required this.success,
    required this.totalBaglog,
    required this.healthy,
    required this.contaminated,
    required this.trend,
    required this.trendDelta,
    required this.monthIncome,
    required this.monthKg,
    required this.monthLoss,
    required this.lossReducedPct,
    required this.batch,
  });
}

