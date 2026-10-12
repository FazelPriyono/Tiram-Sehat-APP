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
}
