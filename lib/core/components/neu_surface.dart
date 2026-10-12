import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class NeuSurface extends StatelessWidget {
  final Widget child;
  final NeuVariant variant;
  final double radius;
  final NeuTone tone;
  final EdgeInsetsGeometry? padding;

  const NeuSurface({
    super.key,
    required this.child,
    this.variant = NeuVariant.raised,
    this.radius = AppRadius.card,
    this.tone = NeuTone.defaultTone,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    List<BoxShadow> shadows;
    Border? border;

    switch (tone) {
      case NeuTone.danger:
        bgColor = AppColors.danger100;
        border = Border.all(color: AppColors.dangerBorder, width: 1);
        shadows = variant == NeuVariant.raised ? AppShadows.raisedSm : [];
      case NeuTone.warning:
        bgColor = AppColors.warning100;
        border = Border.all(color: AppColors.warning500.withValues(alpha: 0.4), width: 1);
        shadows = variant == NeuVariant.raised ? AppShadows.raisedSm : [];
      case NeuTone.success:
        bgColor = AppColors.success100;
        border = Border.all(color: AppColors.success600.withValues(alpha: 0.3), width: 1);
        shadows = variant == NeuVariant.raised ? AppShadows.raisedSm : [];
      case NeuTone.defaultTone:
        switch (variant) {
          case NeuVariant.raised:
            bgColor = AppColors.surface;
            shadows = AppShadows.raised;
          case NeuVariant.inset:
            bgColor = AppColors.surfaceInset;
            shadows = [
              const BoxShadow(
                color: Color(0x4D96A896),
                offset: Offset(4, 4),
                blurRadius: 8,
              ),
              const BoxShadow(
                color: Color(0xCCFFFFFF),
                offset: Offset(-4, -4),
                blurRadius: 8,
              ),
            ];
          case NeuVariant.flat:
            bgColor = AppColors.surface;
            shadows = [];
        }
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: variant == NeuVariant.inset ? null : shadows,
        border: border,
      ),
      child: variant == NeuVariant.inset
          ? _InsetPainter(radius: radius, child: Padding(padding: padding ?? EdgeInsets.zero, child: child))
          : Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}

class _InsetPainter extends StatelessWidget {
  final double radius;
  final Widget child;
  const _InsetPainter({required this.radius, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        painter: _InsetShadowPainter(radius: radius),
        child: child,
      ),
    );
  }
}

class _InsetShadowPainter extends CustomPainter {
  final double radius;
  const _InsetShadowPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final darkPaint = Paint()
      ..color = const Color(0x4D96A896)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final lightPaint = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(rrect.shift(const Offset(4, 4)), darkPaint);
    canvas.drawRRect(rrect.shift(const Offset(-4, -4)), lightPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum NeuVariant { raised, inset, flat }
enum NeuTone { defaultTone, danger, warning, success }
