import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Provider/locale_provider.dart';
import 'package:indian_farmer/View/Onboarding_Screen.dart';

const _bg1 = Color(0xFF0E2A10);
const _bg2 = Color(0xFF1B5E20);
const _gold = Color(0xFFF9A825);

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  void _selectLanguage(BuildContext context, WidgetRef ref, String langCode) {
    ref.read(localeProvider.notifier).setLocale(langCode);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.06),

                  // Icon badge
                  Container(
                    width: w * 0.22,
                    height: w * 0.22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(color: _gold.withValues(alpha: 0.55), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _gold.withValues(alpha: 0.2),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.translate_rounded,
                      size: w * 0.1,
                      color: _gold,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  // Gold divider
                  Row(
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
                        decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
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

                  SizedBox(height: h * 0.02),

                  // Title
                  Text(
                    'भाषा चुनें',
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.072,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),

                  SizedBox(height: h * 0.008),

                  Text(
                    'Select Language',
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),

                  SizedBox(height: h * 0.055),

                  // Hindi Card
                  _LanguageCard(
                    title: 'हिन्दी',
                    subtitle: 'Hindi',
                    icon: '🇮🇳',
                    description: 'ऐप को हिन्दी में उपयोग करें',
                    onTap: () => _selectLanguage(context, ref, 'hi'),
                  ),

                  SizedBox(height: h * 0.025),

                  // English Card
                  _LanguageCard(
                    title: 'English',
                    subtitle: 'अंग्रेज़ी',
                    icon: '🌐',
                    description: 'Use the app in English',
                    onTap: () => _selectLanguage(context, ref, 'en'),
                  ),

                  SizedBox(height: h * 0.06),

                  // Bottom hint
                  Text(
                    'आप बाद में भी भाषा बदल सकते हैं\nYou can change the language later',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.032,
                      color: Colors.white.withValues(alpha: 0.4),
                      height: 1.7,
                    ),
                  ),

                  SizedBox(height: h * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final String description;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.06,
          vertical: w * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
        ),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: w * 0.1)),

            SizedBox(width: w * 0.05),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.03,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _gold.withValues(alpha: 0.4), width: 1),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: _gold,
                size: w * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
