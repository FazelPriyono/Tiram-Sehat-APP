import 'package:flutter/material.dart';
import '../theme/tokens.dart';

enum BottomSheetSnap { peek, expanded }

class AppBottomSheet extends StatefulWidget {
  final Widget Function(BuildContext context, BottomSheetSnap snap) builder;
  final BottomSheetSnap initialSnap;
  final ValueChanged<BottomSheetSnap>? onSnapChange;

  const AppBottomSheet({
    super.key,
    required this.builder,
    this.initialSnap = BottomSheetSnap.peek,
    this.onSnapChange,
  });

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet>
    with SingleTickerProviderStateMixin {
  late BottomSheetSnap _snap;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  static const double _peekFactor = 0.75;
  static const double _expandedFactor = 0.97;

  @override
  void initState() {
    super.initState();
    _snap = widget.initialSnap;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = Tween<double>(
      begin: _snap == BottomSheetSnap.peek ? _peekFactor : _expandedFactor,
      end: _snap == BottomSheetSnap.peek ? _peekFactor : _expandedFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _snapTo(BottomSheetSnap target) {
    final begin = _heightFactor.value;
    final end = target == BottomSheetSnap.peek ? _peekFactor : _expandedFactor;
    _heightFactor = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0);
    setState(() => _snap = target);
    widget.onSnapChange?.call(target);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -300) {
            _snapTo(BottomSheetSnap.expanded);
          } else if (details.primaryVelocity! > 300) {
            _snapTo(BottomSheetSnap.peek);
          }
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: screenHeight * _heightFactor.value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s3),
              _Handle(
                snap: _snap,
                onTap: () => _snapTo(
                  _snap == BottomSheetSnap.peek
                      ? BottomSheetSnap.expanded
                      : BottomSheetSnap.peek,
                ),
              ),
              Expanded(
                child: widget.builder(context, _snap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  final BottomSheetSnap snap;
  final VoidCallback onTap;

  const _Handle({required this.snap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            if (snap == BottomSheetSnap.peek) ...[
              const SizedBox(height: 6),
              Text(
                '⌃ TARIK KE ATAS UNTUK DETAIL MITIGASI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted.withValues(alpha: 0.7),
                  letterSpacing: 0.04 * 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
