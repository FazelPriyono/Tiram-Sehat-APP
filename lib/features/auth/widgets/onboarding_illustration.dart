import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/tokens.dart';
import '../onboarding_content.dart';

/// Ilustrasi onboarding.
///
/// Tidak ada aset ilustrasi di repo, jadi scene digambar dengan `CustomPainter`
/// memakai token warna §5 (tanpa hex baru). Dua animasi halus dipakai agar layar
/// terasa hidup: garis pemindai yang menyapu layar ponsel dan kartu kecil yang
/// naik-turun perlahan.
class OnboardingIllustration extends StatefulWidget {
  final OnboardingStep step;

  const OnboardingIllustration({super.key, required this.step});

  @override
  State<OnboardingIllustration> createState() => _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<OnboardingIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _scan;
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scan.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color panelTop = AppColors.primary100;
    final Color panelBottom =
        Color.lerp(AppColors.primary100, AppColors.primary400, 0.5)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [panelTop, panelBottom],
        ),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _OnboardingScenePainter(
                    kind: widget.step.kind,
                    badgeLabel: widget.step.badgeLabel,
                    scan: _scan,
                    bob: _float,
                  ),
                ),
              ),
            ),
            Align(
              alignment: _cardAlignment,
              child: _HighlightCard(step: widget.step, bob: _float),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu melayang diletakkan di area yang tidak menutupi subjek utama scene.
  Alignment get _cardAlignment {
    switch (widget.step.kind) {
      case OnboardingStepKind.scan:
        return const Alignment(-0.66, 0.02);
      case OnboardingStepKind.solution:
      case OnboardingStepKind.harvest:
        return const Alignment(-0.7, -0.8);
    }
  }
}

/// Kartu kecil melayang dengan ikon + dua baris teks (teks asli, bukan gambar)
/// supaya tetap tajam di segala kerapatan layar.
class _HighlightCard extends StatelessWidget {
  final OnboardingStep step;
  final Animation<double> bob;

  const _HighlightCard({required this.step, required this.bob});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bob,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -6 * bob.value),
        child: child,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s2 + 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            boxShadow: AppShadows.raisedSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.highlightIcon,
                  size: 19,
                  color: AppColors.primary800,
                ),
              ),
              const SizedBox(width: AppSpacing.s2 + 2),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.highlightTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.highlightSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingScenePainter extends CustomPainter {
  final OnboardingStepKind kind;
  final String badgeLabel;
  final Animation<double> scan;
  final Animation<double> bob;

  _OnboardingScenePainter({
    required this.kind,
    required this.badgeLabel,
    required this.scan,
    required this.bob,
  }) : super(repaint: Listenable.merge(<Listenable>[scan, bob]));

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Cahaya lembut supaya panel tidak terasa datar.
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.4),
      size.width * 0.45,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
    );

    switch (kind) {
      case OnboardingStepKind.scan:
        _paintScanScene(canvas, size);
      case OnboardingStepKind.solution:
        _paintSolutionScene(canvas, size);
      case OnboardingStepKind.harvest:
        _paintHarvestScene(canvas, size);
    }
  }

  // ---------------------------------------------------------------- Halaman 1

  void _paintScanScene(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Garis rak kumbung di belakang baglog.
    final Paint shelf = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = h * 0.012
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.06, h * 0.80), Offset(w * 0.94, h * 0.80), shelf);
    canvas.drawLine(Offset(w * 0.12, h * 0.87), Offset(w * 0.88, h * 0.87), shelf);

    _paintJar(canvas, size);
    _paintPhone(canvas, size);
  }

  /// Baglog dalam wadah transparan dengan miselium putih di dalamnya.
  void _paintJar(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final RRect body = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.18, h * 0.30, w * 0.27, h * 0.48),
      topLeft: Radius.circular(w * 0.02),
      topRight: Radius.circular(w * 0.02),
      bottomLeft: Radius.circular(w * 0.05),
      bottomRight: Radius.circular(w * 0.05),
    );
    canvas.drawRRect(
      body,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.005
        ..color = Colors.white.withValues(alpha: 0.9),
    );

    final Paint mycelium = Paint()..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.31, h * 0.60),
        width: w * 0.22,
        height: h * 0.15,
      ),
      mycelium,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.26, h * 0.70),
        width: w * 0.15,
        height: h * 0.12,
      ),
      mycelium,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.37, h * 0.72),
        width: w * 0.13,
        height: h * 0.10,
      ),
      mycelium,
    );

    // Cincin / mulut baglog (digambar setelah badan agar terlihat menutup).
    final RRect rim = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.255, w * 0.31, h * 0.09),
      Radius.circular(w * 0.02),
    );
    canvas.drawRRect(
      rim,
      Paint()
        ..color =
            Color.lerp(AppColors.primary100, AppColors.primary400, 0.6)!
                .withValues(alpha: 0.92),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.315, h * 0.262),
        width: w * 0.24,
        height: h * 0.05,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  /// Ponsel dengan frame deteksi dan garis pemindai yang bergerak.
  void _paintPhone(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Rect phone = Rect.fromLTWH(w * 0.50, h * 0.11, w * 0.37, h * 0.78);
    final RRect phoneRR = RRect.fromRectAndRadius(
      phone,
      Radius.circular(w * 0.055),
    );
    canvas.drawRRect(phoneRR, Paint()..color = AppColors.textPrimary);

    // Speaker atas.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(phone.center.dx, phone.top + phone.height * 0.035),
          width: w * 0.10,
          height: h * 0.012,
        ),
        Radius.circular(h * 0.006),
      ),
      Paint()..color = AppColors.textPrimary.withValues(alpha: 0.35),
    );

    final Rect screen = phone.deflate(w * 0.022);
    canvas.drawRRect(
      RRect.fromRectAndRadius(screen, Radius.circular(w * 0.04)),
      Paint()..color = Color.lerp(AppColors.primary100, Colors.white, 0.75)!,
    );

    final Rect frame = screen.deflate(w * 0.03);
    _paintCorners(
      canvas,
      frame,
      AppColors.primary600,
      w * 0.005,
      w * 0.05,
    );

    // Baglog yang sedang dipindai.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(frame.center.dx, frame.center.dy - h * 0.02),
        width: frame.width * 0.62,
        height: frame.height * 0.18,
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(frame.center.dx, frame.center.dy + h * 0.07),
        width: frame.width * 0.72,
        height: frame.height * 0.16,
      ),
      Paint()..color = Color.lerp(AppColors.surfaceInset, Colors.white, 0.4)!,
    );

    // Garis pemindai (animasi).
    final double scanY = frame.top + frame.height * (0.12 + 0.76 * scan.value);
    final RRect line = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(frame.center.dx, scanY),
        width: frame.width * 0.9,
        height: h * 0.014,
      ),
      Radius.circular(h * 0.01),
    );
    canvas.drawRRect(
      line.inflate(h * 0.01),
      Paint()
        ..color = AppColors.primary400.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawRRect(
      line,
      Paint()..color = AppColors.primary600.withValues(alpha: 0.9),
    );

    _paintBadge(
      canvas,
      Rect.fromLTWH(
        screen.left + w * 0.01,
        screen.top + phone.height * 0.06,
        screen.width - w * 0.02,
        h * 0.10,
      ),
      solid: true,
    );
  }

  // ---------------------------------------------------------------- Halaman 2

  void _paintSolutionScene(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    canvas.drawLine(
      Offset(w * 0.08, h * 0.84),
      Offset(w * 0.92, h * 0.84),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..strokeWidth = h * 0.012
        ..strokeCap = StrokeCap.round,
    );

    // Baglog tegak dengan pita perlakuan hijau.
    final RRect log = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.38, h * 0.34, w * 0.24, h * 0.48),
      topLeft: Radius.circular(w * 0.02),
      topRight: Radius.circular(w * 0.02),
      bottomLeft: Radius.circular(w * 0.06),
      bottomRight: Radius.circular(w * 0.06),
    );
    canvas.drawRRect(
      log,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    // Tutup atas baglog supaya terbaca sebagai tabung, bukan kotak datar.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.34),
        width: w * 0.24,
        height: h * 0.06,
      ),
      Paint()..color = Color.lerp(AppColors.primary100, Colors.white, 0.5)!,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.66),
        width: w * 0.18,
        height: h * 0.18,
      ),
      Paint()..color = Color.lerp(AppColors.surfaceInset, Colors.white, 0.5)!,
    );

    final RRect band = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, h * 0.54, w * 0.28, h * 0.11),
      Radius.circular(h * 0.02),
    );
    canvas.drawRRect(
      band,
      Paint()..color = AppColors.primary600.withValues(alpha: 0.9),
    );
    _paintCheck(canvas, Offset(w * 0.50, h * 0.595), h * 0.03, Colors.white);

    // Penanda pemulihan.
    canvas.drawCircle(
      Offset(w * 0.74, h * 0.42),
      h * 0.038,
      Paint()..color = AppColors.primary400.withValues(alpha: 0.85),
    );
    _paintCheck(canvas, Offset(w * 0.74, h * 0.42), h * 0.018, Colors.white);
    canvas.drawCircle(
      Offset(w * 0.26, h * 0.48),
      h * 0.030,
      Paint()..color = AppColors.primary400.withValues(alpha: 0.6),
    );
    _paintCheck(canvas, Offset(w * 0.26, h * 0.48), h * 0.014, Colors.white);

    _paintBadge(
      canvas,
      // Ditaruh di bawah garis meja agar tidak menabrak kartu melayang.
      Rect.fromLTWH(w * 0.08, h * 0.86, w * 0.42, h * 0.10),
      solid: true,
    );
  }

  // ---------------------------------------------------------------- Halaman 3

  void _paintHarvestScene(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    canvas.drawLine(
      Offset(w * 0.06, h * 0.82),
      Offset(w * 0.94, h * 0.82),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..strokeWidth = h * 0.012
        ..strokeCap = StrokeCap.round,
    );

    // Jamur digambar lebih dulu supaya terlihat berada di dalam keranjang.
    _paintMushroom(canvas, Offset(w * 0.41, h * 0.52), w * 0.17, h * 0.17);
    _paintMushroom(canvas, Offset(w * 0.60, h * 0.53), w * 0.15, h * 0.15);
    _paintMushroom(canvas, Offset(w * 0.50, h * 0.44), w * 0.13, h * 0.13);

    // Keranjang panen.
    final Path basket = Path()
      ..moveTo(w * 0.26, h * 0.58)
      ..lineTo(w * 0.74, h * 0.58)
      ..lineTo(w * 0.67, h * 0.82)
      ..lineTo(w * 0.33, h * 0.82)
      ..close();
    canvas.drawPath(
      basket,
      Paint()
        ..color = Color.lerp(AppColors.primary100, AppColors.primary400, 0.55)!,
    );

    final Paint weave = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = w * 0.005
      ..strokeCap = StrokeCap.round;
    for (int i = 1; i <= 4; i++) {
      final double y = h * (0.58 + i * 0.048);
      canvas.drawLine(Offset(w * 0.30, y), Offset(w * 0.70, y), weave);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.24, h * 0.53, w * 0.52, h * 0.08),
        Radius.circular(h * 0.03),
      ),
      Paint()
        ..color = Color.lerp(AppColors.primary100, AppColors.primary400, 0.8)!,
    );

    _paintBadge(
      canvas,
      Rect.fromLTWH(w * 0.08, h * 0.86, w * 0.42, h * 0.10),
      solid: true,
    );
  }

  void _paintMushroom(Canvas canvas, Offset center, double ww, double hh) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + hh * 0.24),
          width: ww * 0.26,
          height: hh * 0.62,
        ),
        Radius.circular(ww * 0.1),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );

    final Path cap = Path()
      ..moveTo(center.dx - ww * 0.5, center.dy + hh * 0.06)
      ..quadraticBezierTo(
        center.dx,
        center.dy - hh * 0.78,
        center.dx + ww * 0.5,
        center.dy + hh * 0.06,
      )
      ..close();
    canvas.drawPath(
      cap,
      Paint()..color = Color.lerp(AppColors.surfaceInset, Colors.white, 0.35)!,
    );
  }

  // ------------------------------------------------------------------- Utilitas

  void _paintCorners(
    Canvas canvas,
    Rect rect,
    Color color,
    double stroke,
    double len,
  ) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(rect.topLeft + Offset(0, len), rect.topLeft, paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + Offset(len, 0), paint);
    canvas.drawLine(rect.topRight + Offset(-len, 0), rect.topRight, paint);
    canvas.drawLine(rect.topRight, rect.topRight + Offset(0, len), paint);
    canvas.drawLine(rect.bottomLeft + Offset(0, -len), rect.bottomLeft, paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(len, 0), paint);
    canvas.drawLine(rect.bottomRight + Offset(-len, 0), rect.bottomRight, paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(0, -len), paint);
  }

  void _paintCheck(Canvas canvas, Offset center, double size, Color color) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = size * 0.26
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx - size * 0.5, center.dy),
      Offset(center.dx - size * 0.12, center.dy + size * 0.38),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - size * 0.12, center.dy + size * 0.38),
      Offset(center.dx + size * 0.52, center.dy - size * 0.38),
      paint,
    );
  }

  void _paintBadge(Canvas canvas, Rect rect, {required bool solid}) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      Paint()..color = solid ? AppColors.primary600 : AppColors.bg,
    );

    final TextPainter text = TextPainter(
      text: TextSpan(
        text: badgeLabel,
        style: GoogleFonts.plusJakartaSans(
          fontSize: (rect.height * 0.44).clamp(9.0, 13.0),
          fontWeight: FontWeight.w700,
          color: solid ? AppColors.textOnPrimary : AppColors.primary800,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: rect.width - AppSpacing.s3);

    text.paint(
      canvas,
      Offset(
        rect.center.dx - text.width / 2,
        rect.center.dy - text.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _OnboardingScenePainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.badgeLabel != badgeLabel;
}
