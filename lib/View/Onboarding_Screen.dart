import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indian_farmer/View/Auth/Login_Screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<double> _scale;

  static const _bg = Color(0xFF0E2A10);
  static const _gold = Color(0xFFF9A825);

  List<_Slide> _buildSlides(bool isHindi) => [
    _Slide(
      emoji: '🚜',
      title: isHindi ? 'किसान साथी में\nआपका स्वागत है' : 'Welcome to\nKisaan Saathi',
      desc: isHindi
          ? 'बुवाई से मंडी तक — खेती के हर पड़ाव पर\nसही जानकारी, सही समय पर।'
          : 'From sowing to market — the right information\nat every step of farming.',
      features: [
        _Feature('🌾', isHindi ? 'फसल गाइड' : 'Crop Guide'),
        _Feature('🌦️', isHindi ? 'मौसम' : 'Weather'),
        _Feature('📰', isHindi ? 'कृषि खबरें' : 'Agri News'),
      ],
    ),
    _Slide(
      emoji: '💰',
      title: isHindi ? 'मंडी भाव\nरोज़ जानें' : 'Know Mandi Rates\nEvery Day',
      desc: isHindi
          ? 'गेहूं, धान, सरसों, आलू — हर फसल का\nताज़ा भाव। बिचौलिए नहीं, सीधे मंडी।'
          : 'Wheat, rice, mustard, potato — fresh rates\nfor every crop. No middlemen, direct mandi.',
      features: [
        _Feature('📈', isHindi ? 'ताज़ा भाव' : 'Live Rates'),
        _Feature('📍', isHindi ? 'नज़दीकी मंडी' : 'Near Mandi'),
        _Feature('🔔', isHindi ? 'भाव अलर्ट' : 'Rate Alert'),
      ],
    ),
    _Slide(
      emoji: '🌱',
      title: isHindi ? 'सही बीज और\nखाद की सलाह' : 'Right Seeds &\nFertilizer Advice',
      desc: isHindi
          ? 'मिट्टी की जाँच से लेकर सही उर्वरक तक —\nहर किसान के लिए विशेषज्ञ सलाह।'
          : 'From soil testing to the right fertilizer —\nexpert advice for every farmer.',
      features: [
        _Feature('🌿', isHindi ? 'उन्नत बीज' : 'Hybrid Seeds'),
        _Feature('🧪', isHindi ? 'मिट्टी जाँच' : 'Soil Test'),
        _Feature('🌻', isHindi ? 'जैविक खाद' : 'Organic Manure'),
      ],
    ),
    _Slide(
      emoji: '🏛️',
      title: isHindi ? 'सरकारी योजनाएं —\nआपका हक पाएं' : 'Government Schemes —\nClaim Your Right',
      desc: isHindi
          ? 'PM-Kisan, फसल बीमा और KCC लोन —\nसब एक जगह, सरल भाषा में।'
          : 'PM-Kisan, crop insurance and KCC loan —\nall in one place, in simple language.',
      features: [
        _Feature('💳', 'PM-Kisan'),
        _Feature('🛡️', isHindi ? 'फसल बीमा' : 'Crop Insurance'),
        _Feature('📞', isHindi ? 'हेल्पलाइन' : 'Helpline'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.78, end: 1.0).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));
    _anim.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _onPage(int p) {
    setState(() => _currentPage = p);
    _anim.reset();
    _anim.forward();
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ));
  }

  void _next(int slideCount) {
    if (_currentPage < slideCount - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final slides = _buildSlides(isHindi);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E2A10), Color(0xFF1B5E20), Color(0xFF0E2A10)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05, vertical: h * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/app logo.png',
                            width: w * 0.09,
                            height: w * 0.09,
                            fit: BoxFit.cover),
                      ),
                      SizedBox(width: w * 0.025),
                      Text(
                        isHindi ? 'किसान साथी' : 'Kisaan Saathi',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                    if (!isLastPage)
                      GestureDetector(
                        onTap: _finish,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            isHindi ? 'छोड़ें' : 'Skip',
                            style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: w * 0.033,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Page content (swipeable) ─────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPage,
                  itemCount: slides.length,
                  itemBuilder: (_, i) => _buildPage(slides[i], w, h),
                ),
              ),

              // ── Bottom: dots + button ─────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    w * 0.06, 0, w * 0.06, h * 0.035),
                child: Column(
                  children: [
                    // Dot indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentPage
                                ? _gold
                                : Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.025),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _next(slides.length),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isLastPage
                                  ? [const Color(0xFFE65100), _gold]
                                  : [
                                      Colors.white.withValues(alpha: 0.18),
                                      Colors.white.withValues(alpha: 0.12),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isLastPage
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.3),
                            ),
                            boxShadow: isLastPage
                                ? [
                                    BoxShadow(
                                      color: _gold.withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : null,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLastPage
                                      ? (isHindi ? 'शुरू करें' : 'Get Started')
                                      : (isHindi ? 'अगला' : 'Next'),
                                  style: GoogleFonts.poppins(
                                    fontSize: w * 0.047,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  isLastPage
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildPage(_Slide slide, double w, double h) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Column(
        children: [
          SizedBox(height: h * 0.02),

          // ── Emoji badge ──────────────────────────────────────────
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: _buildEmojiBadge(slide.emoji, w),
            ),
          ),

          SizedBox(height: h * 0.035),

          // ── Feature chips ─────────────────────────────────────────
          FadeTransition(
            opacity: _fade,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: slide.features.map((f) => _buildChip(f, w)).toList(),
            ),
          ),

          SizedBox(height: h * 0.04),

          // ── Title ─────────────────────────────────────────────────
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: w * 0.072,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.25,
            ),
          ),

          SizedBox(height: h * 0.018),

          // ── Gold divider ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w * 0.08,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    _gold.withValues(alpha: 0.8),
                  ]),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: _gold, shape: BoxShape.circle),
              ),
              Container(
                width: w * 0.08,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    _gold.withValues(alpha: 0.8),
                    Colors.transparent,
                  ]),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),

          SizedBox(height: h * 0.018),

          // ── Description ───────────────────────────────────────────
          Text(
            slide.desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: w * 0.038,
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiBadge(String emoji, double w) {
    return SizedBox(
      width: w * 0.46,
      height: w * 0.46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer dashed ring
          CustomPaint(
            size: Size(w * 0.46, w * 0.46),
            painter: _DashedRingPainter(
                color: _gold.withValues(alpha: 0.22)),
          ),
          // Mid ring
          Container(
            width: w * 0.36,
            height: w * 0.36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: _gold.withValues(alpha: 0.38), width: 1.5),
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          // Inner circle
          Container(
            width: w * 0.25,
            height: w * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                  color: _gold.withValues(alpha: 0.55), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _gold.withValues(alpha: 0.2),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(emoji,
                  style: TextStyle(fontSize: w * 0.11)),
            ),
          ),

          // Wheat stalks at bottom of ring
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(w * 0.46, w * 0.12),
              painter: _WheatAccentPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(_Feature f, double w) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(f.emoji, style: TextStyle(fontSize: w * 0.062)),
          const SizedBox(height: 4),
          Text(
            f.label,
            style: GoogleFonts.poppins(
              fontSize: w * 0.028,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Models ──────────────────────────────────────────────────────────────────

class _Feature {
  final String emoji;
  final String label;
  const _Feature(this.emoji, this.label);
}

class _Slide {
  final String emoji;
  final String title;
  final String desc;
  final List<_Feature> features;
  const _Slide({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.features,
  });
}

// ─── Dashed ring ─────────────────────────────────────────────────────────────

class _DashedRingPainter extends CustomPainter {
  final Color color;
  const _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    const count = 28;
    const dashAngle = 2 * math.pi / count;

    for (int i = 0; i < count; i++) {
      final start = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashAngle * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter old) =>
      old.color != color;
}

// ─── Wheat accent (small, below badge) ───────────────────────────────────────

class _WheatAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sp = Paint()
      ..color = const Color(0xFFF9A825).withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final hf = Paint()
      ..color = const Color(0xFFFFCA28).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    const xs = [0.18, 0.28, 0.38, 0.5, 0.62, 0.72, 0.82];
    const hs = [18.0, 22.0, 20.0, 24.0, 20.0, 22.0, 18.0];

    for (int i = 0; i < xs.length; i++) {
      final x = size.width * xs[i];
      final h = hs[i];
      final by = size.height;
      canvas.drawLine(Offset(x, by), Offset(x, by - h), sp);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(x, by - h - 4), width: 4, height: 9),
          hf);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
