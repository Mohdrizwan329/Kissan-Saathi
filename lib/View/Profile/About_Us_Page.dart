import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFF6F4EE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text('हमारे बारे में', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_green1, _green2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('🌾', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('किसान साथी', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('आपकी खेती, हमारी जिम्मेदारी', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _section('🎯', 'हमारा लक्ष्य', 'भारत के किसानों को सही जानकारी, उचित उपकरण और आधुनिक कृषि ज्ञान देकर उनकी उत्पादकता और आय में सुधार करना।'),
            _section('🚜', 'मुख्य विशेषताएं',
                '• मौसम की जानकारी और फसल सलाह\n• बाजार भाव की अपडेट\n• सरकारी योजनाओं की सूचना\n• कृषि विशेषज्ञों से सीधा संपर्क\n• किसान समुदाय मंच'),
            _section('🤝', 'हमारी प्रतिबद्धता',
                'हम भारत की जड़ों तक तकनीक पहुंचाने के लिए प्रतिबद्ध हैं — यह सुनिश्चित करते हुए कि प्रत्येक किसान को वह ज्ञान और सहायता मिले जिसका वह हकदार है।'),
            _section('📍', 'सेवा क्षेत्र',
                'पंजाब में गेहूं से लेकर तमिलनाडु में सब्जियों तक — किसान साथी आपका दैनिक कृषि सहायक है।'),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📞 संपर्क करें', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: _green1)),
                  const SizedBox(height: 10),
                  _contactRow(Icons.email_rounded, 'support@kisanseva.com'),
                  const SizedBox(height: 6),
                  _contactRow(Icons.phone_rounded, '+91-9876543210'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'किसान साथी समुदाय का हिस्सा बनने के लिए धन्यवाद\nमिलकर हम मज़बूत होते हैं 🇮🇳🌾',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(String emoji, String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: _green1)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, height: 1.6)),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: _green2, size: 18),
        const SizedBox(width: 10),
        Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
