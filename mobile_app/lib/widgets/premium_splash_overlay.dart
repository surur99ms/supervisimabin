import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumSplashOverlay extends StatefulWidget {
  final bool isReady;
  final VoidCallback onTransitionComplete;

  const PremiumSplashOverlay({
    super.key,
    required this.isReady,
    required this.onTransitionComplete,
  });

  @override
  State<PremiumSplashOverlay> createState() => _PremiumSplashOverlayState();
}

class _PremiumSplashOverlayState extends State<PremiumSplashOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final AnimationController _exitController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _badgeFade;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _exitOpacity;
  late final Animation<double> _exitScale;

  bool _hasStartedExit = false;

  @override
  void initState() {
    super.initState();

    // 1. Entry Animation (Logo springs into view, text reveals)
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // 2. Pulse Animation (Subtle glowing breath on background)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 3. Exit Morph Animation (Expands smoothly into home screen)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOutCubic),
    );

    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTransitionComplete();
      }
    });

    _entryController.forward();
  }

  @override
  void didUpdateWidget(covariant PremiumSplashOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReady && !_hasStartedExit) {
      _hasStartedExit = true;
      // Smoothly transition away once ready
      _exitController.forward();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _entryController,
        _pulseController,
        _exitController,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _exitOpacity.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _exitScale.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Luxury Deep Brand Gradient
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F131D),
              Color(0xFF1A1C29),
              Color(0xFF0B0E17),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Radial Glow behind the logo
            Positioned(
              top: size.height * 0.28,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, _) {
                  return Container(
                    width: 280 * _pulseAnimation.value,
                    height: 280 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFF416C).withValues(alpha: 0.35),
                          const Color(0xFFFF4B2B).withValues(alpha: 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // 1. Animated Logo with Glassmorphic Glow Container
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: Container(
                        width: 140,
                        height: 140,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF416C).withValues(alpha: 0.4),
                              blurRadius: 35,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Image.asset(
                            'assets/images/home_screen.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 2. Animated Title & Subtitle
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          Text(
                            'SUPERVISI MABIN',
                            style: GoogleFonts.poppins(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 2.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'IASS JAWA TIMUR',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF6584),
                              letterSpacing: 3.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Slogan Pill Capsule
                  FadeTransition(
                    opacity: _badgeFade,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFFD166),
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Khidmah Lil Ma\'had, Khidmah Lil Ummah',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // 4. Loading Capsule at the Bottom
                  FadeTransition(
                    opacity: _badgeFade,
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFF416C),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Menyiapkan Tampilan Aplikasi...',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'v2.0.0 • Mobile Modern Edition',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.35),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

