import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/components/action_button.dart';
import '../../core/components/neu_surface.dart';
import '../../core/theme/tokens.dart';
import 'login_screen.dart';
import 'onboarding_content.dart';
import 'widgets/onboarding_illustration.dart';

/// Halaman Onboarding (pra-login).
///
/// Referensi tata letak: `docs/design/onboarding.png`. Layar ini belum masuk
/// daftar layar kanonik `DESIGN_Tiram_Sehat.md` §8, jadi teks halaman 2-3 dan
/// tombol aksi utama adalah tambahan yang dicatat di `docs/CHANGE_REQUESTS.md`
/// (CR-001). Warna/ukuran tetap memakai token §5 dan komponen bersama §6.
class OnboardingScreen extends StatefulWidget {
  /// Dipanggil saat pengguna menekan "Lewati" atau menyelesaikan langkah akhir.
  /// Default: berpindah ke [LoginScreen].
  final VoidCallback? onFinished;

  const OnboardingScreen({super.key, this.onFinished});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final AnimationController _intro;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _cardFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _stepsFade;
  late final Animation<Offset> _stepsSlide;
  late final Animation<double> _footerFade;
  late final Animation<Offset> _footerSlide;

  int _index = 0;

  int get _lastIndex => OnboardingContent.steps.length - 1;

  @override
  void initState() {
    super.initState();

    // Animasi masuk bertahap (staggered) agar tiap elemen tampil berurutan.
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _intro,
            curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
          ),
        );

    _cardFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.10, 0.55, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.10, 0.60, curve: Curves.easeOutBack),
      ),
    );

    _stepsFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.36, 0.72, curve: Curves.easeOut),
    );
    _stepsSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _intro,
            curve: const Interval(0.36, 0.78, curve: Curves.easeOutCubic),
          ),
        );

    _footerFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.52, 1.0, curve: Curves.easeOut),
    );
    _footerSlide =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _intro,
            curve: const Interval(0.52, 0.95, curve: Curves.easeOutCubic),
          ),
        );

    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index == _index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_index >= _lastIndex) {
      _finish();
      return;
    }
    _goTo(_index + 1);
  }

  void _finish() {
    if (widget.onFinished != null) {
      widget.onFinished!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingX,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.s2),
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.s4),
                  Expanded(
                    child: ScaleTransition(
                      scale: _cardScale,
                      child: FadeTransition(
                        opacity: _cardFade,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) => setState(() => _index = i),
                          children: List.generate(
                            OnboardingContent.steps.length,
                            (i) => _buildAnimatedPage(i),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _buildStepPills(),
                  const SizedBox(height: AppSpacing.s5),
                  _buildPageDots(),
                  const SizedBox(height: AppSpacing.s5),
                  _buildCta(),
                  const SizedBox(height: AppSpacing.s4),
                  const SizedBox(height: AppSpacing.s4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------- Header

  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.tile),
                boxShadow: AppShadows.raisedSm,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.tile - 6),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primary100,
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.primary800,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                OnboardingContent.brandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary800,
                ),
              ),
            ),
            _PressScale(
              onTap: _finish,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: AppShadows.raisedSm,
                ),
                child: Text(
                  OnboardingContent.skipLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Halaman

  /// Membungkus tiap halaman dengan efek skala + fade berdasarkan posisi
  /// gulir, sehingga konten terasa "tumbuh" saat masuk ke tengah layar.
  Widget _buildAnimatedPage(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double delta = 0;
        if (_pageController.hasClients && _pageController.position.hasPixels) {
          delta = (_pageController.page ?? _index.toDouble()) - index;
        }
        final double d = delta.clamp(-1.0, 1.0);
        final double opacity = (1 - 0.35 * d.abs()).clamp(0.0, 1.0);
        final double scale = 1 - 0.06 * d.abs();

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: _buildPageCard(OnboardingContent.steps[index]),
    );
  }

  /// Kartu halaman dibuat "min-size" (bukan `Expanded`) supaya ilustrasi tidak
  /// terhimpit di layar pendek, lalu diletakkan dalam scroll view agar tetap
  /// aman di layar kecil maupun saat font diperbesar pengguna.
  Widget _buildPageCard(OnboardingStep step) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SizedBox(
                  width: double.infinity,
                  child: NeuSurface(
                    variant: NeuVariant.raised,
                    radius: AppRadius.card,
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: OnboardingIllustration(step: step),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.s3,
                            0,
                            AppSpacing.s3,
                            AppSpacing.s3,
                          ),
                          child: Column(
                            children: [
                              Text(
                                step.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.s2),
                              Text(
                                step.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
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
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------- Navigasi

  Widget _buildStepPills() {
    return SlideTransition(
      position: _stepsSlide,
      child: FadeTransition(
        opacity: _stepsFade,
        child: Row(
          children: List.generate(OnboardingContent.steps.length, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i == _lastIndex ? 0 : AppSpacing.s2,
                ),
                child: _StepPill(
                  label: OnboardingContent.steps[i].pillLabel,
                  selected: i == _index,
                  onTap: () => _goTo(i),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPageDots() {
    return FadeTransition(
      opacity: _stepsFade,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(OnboardingContent.steps.length, (i) {
          final bool selected = i == _index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
            width: selected ? 30 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary600 : AppColors.surfaceInset,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCta() {
    final bool isLast = _index == _lastIndex;

    return SlideTransition(
      position: _footerSlide,
      child: FadeTransition(
        opacity: _footerFade,
        child: ActionButton(
          label:
              isLast ? OnboardingContent.startLabel : OnboardingContent.nextLabel,
          icon: isLast ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
          variant: ActionVariant.primary,
          fullWidth: true,
          onPress: _next,
        ),
      ),
    );
  }
}

/// Pill langkah (1. Pindai / 2. Solusi / 3. Panen).
class _StepPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StepPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: selected ? AppShadows.raisedSm : null,
          border: Border.all(
            color: selected
                ? AppColors.primary400.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary600
                    : AppColors.textMuted.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s2 - 2),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppColors.primary800
                      : AppColors.textMuted,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pembungkus kecil yang mengecil saat ditekan (umpan balik sentuh).
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _PressScale({required this.child, this.onTap});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
