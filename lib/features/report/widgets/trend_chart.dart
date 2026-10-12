import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/tokens.dart';

class TrendChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const TrendChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(
        painter: _TrendChartPainter(values: values, labels: labels),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  _TrendChartPainter({required this.values, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    const leftPadding = 18.0;
    const rightPadding = 24.0;
    const topPadding = 18.0;
    const bottomPadding = 32.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Draw horizontal dashed grid lines
    final gridPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final y = topPadding + (chartHeight / 3) * i;
      _drawDashedLine(
        canvas,
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }

    // Min and max for scaling
    // Values: 82, 85, 88, 89.4
    const minY = 78.0;
    const maxY = 92.0;

    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = leftPadding + (chartWidth / (values.length - 1)) * i;
      final normalizedY = (values[i] - minY) / (maxY - minY);
      final y = topPadding + chartHeight * (1.0 - normalizedY);
      points.add(Offset(x, y));
    }

    // Fill gradient path under the curve
    final path = Path();
    path.moveTo(points.first.dx, size.height - bottomPadding);
    path.lineTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    path.lineTo(points.last.dx, size.height - bottomPadding);
    path.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary600.withValues(alpha: 0.28),
          AppColors.primary400.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, topPadding, size.width, chartHeight));

    canvas.drawPath(path, gradientPaint);

    // Line stroke path
    final linePaint = Paint()
      ..color = AppColors.primary600
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Draw dots and text labels
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final isLast = i == points.length - 1;

      // Draw point dot
      final dotBgPaint = Paint()
        ..color = isLast ? AppColors.primary800 : AppColors.surface
        ..style = PaintingStyle.fill;
      final dotBorderPaint = Paint()
        ..color = isLast ? AppColors.primary400 : AppColors.primary600
        ..strokeWidth = isLast ? 3.0 : 2.5
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(pt, isLast ? 6.5 : 4.5, dotBgPaint);
      canvas.drawCircle(pt, isLast ? 6.5 : 4.5, dotBorderPaint);

      // Label below dot or point
      final labelText = labels[i];
      final textSpan = TextSpan(
        text: labelText,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: isLast ? FontWeight.w700 : FontWeight.w500,
          color: isLast ? AppColors.primary800 : AppColors.textSecondary,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Position text
      double labelY;
      if (isLast) {
        // Show 89,4% above or near last point
        labelY = pt.dy - 20;
      } else {
        labelY = pt.dy + 10;
      }
      textPainter.paint(
        canvas,
        Offset(pt.dx - (textPainter.width / 2), labelY),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = p1.dx;
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset((startX + dashWidth).clamp(p1.dx, p2.dx), p1.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}
