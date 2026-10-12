import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';

class ScanReticle extends StatelessWidget {
  final double size;

  const ScanReticle({super.key, this.size = 260});

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
    const cornerLen = 38.0;
    const cornerStroke = 5.0;

    final cornerPaint = Paint()
      ..color = _green
      ..strokeWidth = cornerStroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final tl = Offset.zero;
    final tr = Offset(size.width, 0);
    final bl = Offset(0, size.height);
    final br = Offset(size.width, size.height);

    canvas.drawLine(tl + const Offset(0, cornerLen), tl, cornerPaint);
    canvas.drawLine(tl, tl + Offset(cornerLen, 0), cornerPaint);

    canvas.drawLine(tr + Offset(-cornerLen, 0), tr, cornerPaint);
    canvas.drawLine(tr, tr + const Offset(0, cornerLen), cornerPaint);

    canvas.drawLine(bl + const Offset(0, -cornerLen), bl, cornerPaint);
    canvas.drawLine(bl, bl + Offset(cornerLen, 0), cornerPaint);

    canvas.drawLine(br + Offset(-cornerLen, 0), br, cornerPaint);
    canvas.drawLine(br, br + const Offset(0, -cornerLen), cornerPaint);

    final center = size.center(Offset.zero);

    final square = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final squareSide = size.width * 0.62;
    canvas.drawRect(
      Rect.fromCenter(center: center, width: squareSide, height: squareSide),
      square,
    );

    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    final radius = size.width * 0.31;
    const dashDeg = 6.0;
    const gapDeg = 5.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    for (double a = 0; a < 360; a += dashDeg + gapDeg) {
      canvas.drawArc(
        rect,
        a * math.pi / 180,
        dashDeg * math.pi / 180,
        false,
        dashPaint,
      );
    }

    canvas.drawCircle(
      center,
      26,
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );
    canvas.drawCircle(center, 22, Paint()..color = Colors.white.withValues(alpha: 0.22));
    canvas.drawCircle(center, 8, Paint()..color = _green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
