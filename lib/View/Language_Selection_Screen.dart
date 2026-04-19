import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Provider/locale_provider.dart';
import 'package:indian_farmer/View/Bottom_NavigationBar.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  void _selectLanguage(BuildContext context, WidgetRef ref, String langCode) {
    ref.read(localeProvider.notifier).setLocale(langCode);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MyHomePage(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: h * 0.08),

              // Icon
              Container(
                width: w * 0.2,
                height: w * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.translate,
                  size: w * 0.1,
                  color: const Color(0xFF2E7D32),
                ),
              ),

              SizedBox(height: h * 0.03),

              // Title
              Text(
                'भाषा चुनें',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: w * 0.01),

              Text(
                'Select Language',
                style: GoogleFonts.poppins(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: h * 0.06),

              // Language Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              const Spacer(),

              // Bottom hint
              Padding(
                padding: EdgeInsets.only(bottom: h * 0.04),
                child: Text(
                  'आप बाद में भी भाषा बदल सकते हैं\nYou can change the language later',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: w * 0.032,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Text(
              icon,
              style: TextStyle(fontSize: w * 0.1),
            ),

            SizedBox(width: w * 0.05),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: w * 0.03,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF2E7D32),
              size: w * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
