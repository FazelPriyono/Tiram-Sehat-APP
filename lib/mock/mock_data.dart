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
  );
}
