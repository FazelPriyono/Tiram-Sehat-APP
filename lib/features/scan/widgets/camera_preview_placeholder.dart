import 'package:flutter/material.dart';

class CameraPreviewPlaceholder extends StatelessWidget {
  const CameraPreviewPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3B4135), Color(0xFF242820), Color(0xFF151812)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _KumbungPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _KumbungPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.22),
      size.width * 0.7,
      Paint()
        ..color = const Color(0xFF7A8668).withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
    );

    final baglog = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    for (int row = 0; row < 5; row++) {
      final y = size.height * (0.40 + row * 0.12);
      final w = size.width * (0.19 - row * 0.008);
      final h = size.height * (0.055 - row * 0.004);
      final offset = row.isEven ? 0.0 : size.width * 0.1;

      for (int col = -1; col < 6; col++) {
        final x = size.width * (-0.04 + col * 0.2) + offset;
        final shade = (0.14 + row * 0.05 + (col.isEven ? 0.04 : 0.0)).clamp(0.0, 0.5);
        baglog.color = Color.fromRGBO(200, 192, 160, shade);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: w, height: h),
          baglog,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
