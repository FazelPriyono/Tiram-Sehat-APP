class FormatHelper {
  static String rupiah(int value) {
    final str = value.toString();
    final buffer = StringBuffer('Rp ');
    final len = str.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  static String rupiahPerKg(int value) => '${rupiah(value)} /Kg';

  static String kg(double value) {
    final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
    return '$formatted Kg';
  }

  static String persen(double value) {
    final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
    return '$formatted%';
  }

  static String deltaKg(double value) {
    final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
    return '+$formatted Kg';
  }

  static String deltaPct(double value) {
    final formatted = value.toStringAsFixed(1).replaceAll('.', ',');
    return '+$formatted%';
  }

  static String baglog(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    final len = str.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    buffer.write(' baglog');
    return buffer.toString();
  }
}
