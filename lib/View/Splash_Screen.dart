import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Provider/locale_provider.dart';
import 'package:indian_farmer/View/Auth/Login_Screen.dart';
import 'package:indian_farmer/View/Bottom_NavigationBar.dart';
import 'package:indian_farmer/View/Language_Selection_Screen.dart';
import 'package:indian_farmer/View/Onboarding_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _bg1 = Color(0xFF0E2A10);
const _bg2 = Color(0xFF1B5E20);
const _gold = Color(0xFFF9A825);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );
    _controller.forward();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    bool hasLanguage = false;
    bool isLoggedIn = false;
    bool onboardingDone = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      hasLanguage = prefs.getString('selected_language') != null;
      isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      onboardingDone = prefs.getBool('onboarding_done') ?? false;
      if (hasLanguage) {
        ref.read(localeProvider.notifier).loadLocale();
      }
    } catch (_) {}

    if (!mounted) return;

    Widget destination;
    if (!hasLanguage) {
      destination = const LanguageSelectionScreen();
    } else if (!onboardingDone) {
      destination = const OnboardingScreen();
    } else if (!isLoggedIn) {
      destination = const LoginScreen();
    } else {
      destination = MyHomePage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bg1, _bg2, _bg1],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular logo with gold ring (same as language screen badge style)
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer gold glow ring
                    Container(
                      width: w * 0.62,
                      height: w * 0.62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _gold.withValues(alpha: 0.22), width: 1.5),
                      ),
                    ),
                    // Mid ring
                    Container(
                      width: w * 0.54,
                      height: w * 0.54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _gold.withValues(alpha: 0.38), width: 1.5),
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                    // Circular logo
                    Container(
                      width: w * 0.44,
                      height: w * 0.44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _gold.withValues(alpha: 0.55), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _gold.withValues(alpha: 0.25),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/app logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: h * 0.04),

            // Gold divider
            FadeTransition(
              opacity: _fadeAnim,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: w * 0.08,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, _gold.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 6,
                    height: 6,
                    decoration:
                        const BoxDecoration(color: _gold, shape: BoxShape.circle),
                  ),
                  Container(
                    width: w * 0.08,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_gold.withValues(alpha: 0.8), Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.025),

            // App name
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'किसान साथी',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.09,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),

            SizedBox(height: h * 0.01),

            // Tagline
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'आपकी खेती, हमारी जिम्मेदारी',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),

            SizedBox(height: h * 0.1),

            // Gold loading indicator
            FadeTransition(
              opacity: _fadeAnim,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: _gold,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
