import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';

class ScanReticle extends StatelessWidget {
  final double size;

  const ScanReticle({super.key, this.size = 300});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ReticlePainter()),
    );
  }
}

class _ReticlePainter extends CustomPainter {
  static const _green = AppColors.primary400;

  @override
  void paint(Canvas canvas, Size size) {
    final cornerLen = size.width * 0.14;
    final stroke = size.width * 0.017;

    final cornerPaint = Paint()
      ..color = _green
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final tl = Offset.zero;
    final tr = Offset(size.width, 0);
    final bl = Offset(0, size.height);
    final br = Offset(size.width, size.height);

    canvas.drawLine(tl + Offset(0, cornerLen), tl, cornerPaint);
    canvas.drawLine(tl, tl + Offset(cornerLen, 0), cornerPaint);

    canvas.drawLine(tr + Offset(-cornerLen, 0), tr, cornerPaint);
    canvas.drawLine(tr, tr + Offset(0, cornerLen), cornerPaint);

    canvas.drawLine(bl + Offset(0, -cornerLen), bl, cornerPaint);
    canvas.drawLine(bl, bl + Offset(cornerLen, 0), cornerPaint);

    canvas.drawLine(br + Offset(-cornerLen, 0), br, cornerPaint);
    canvas.drawLine(br, br + Offset(0, -cornerLen), cornerPaint);

    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      size.width * 0.036,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center,
      size.width * 0.023,
      Paint()..color = _green,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
