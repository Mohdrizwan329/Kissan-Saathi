import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Provider/locale_provider.dart';
import 'package:indian_farmer/View/Bottom_NavigationBar.dart';
import 'package:indian_farmer/View/Language_Selection_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
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
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );
    _controller.forward();

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    bool hasLanguage = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      hasLanguage = prefs.getString('selected_language') != null;
      if (hasLanguage) {
        ref.read(localeProvider.notifier).loadLocale();
      }
    } catch (_) {
      // Platform channels not ready after hot restart — default to language selection
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            hasLanguage ? MyHomePage() : const LanguageSelectionScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
              Color(0xFF388E3C),
              Color(0xFF43A047),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: w * 0.3,
                  height: w * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.agriculture,
                    size: w * 0.15,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),

            SizedBox(height: w * 0.08),

            // App name
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'किसान साथी',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.09,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: w * 0.02),

            // Tagline
            FadeTransition(
              opacity: _fadeAnim,
              child: Text(
                'आपकी खेती, हमारी जिम्मेदारी',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ),

            SizedBox(height: w * 0.15),

            // Loading indicator
            FadeTransition(
              opacity: _fadeAnim,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Colors.white70,
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
