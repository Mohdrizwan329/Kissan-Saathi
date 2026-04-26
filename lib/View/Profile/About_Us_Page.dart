import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'हमारे बारे में' : 'About Us',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
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
                  Text(
                    isHindi ? 'किसान साथी' : 'Kisaan Saathi',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHindi ? 'आपकी खेती, हमारी जिम्मेदारी' : 'Your Farming, Our Responsibility',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _section(
              '🎯',
              isHindi ? 'हमारा लक्ष्य' : 'Our Mission',
              isHindi
                  ? 'भारत के किसानों को सही जानकारी, उचित उपकरण और आधुनिक कृषि ज्ञान देकर उनकी उत्पादकता और आय में सुधार करना।'
                  : 'To improve the productivity and income of Indian farmers by providing accurate information, the right tools, and modern agricultural knowledge.',
            ),
            _section(
              '🚜',
              isHindi ? 'मुख्य विशेषताएं' : 'Key Features',
              isHindi
                  ? '• मौसम की जानकारी और फसल सलाह\n• बाजार भाव की अपडेट\n• सरकारी योजनाओं की सूचना\n• कृषि विशेषज्ञों से सीधा संपर्क\n• किसान समुदाय मंच'
                  : '• Weather information and crop advice\n• Market price updates\n• Government scheme notifications\n• Direct contact with agricultural experts\n• Farmer community forum',
            ),
            _section(
              '🤝',
              isHindi ? 'हमारी प्रतिबद्धता' : 'Our Commitment',
              isHindi
                  ? 'हम भारत की जड़ों तक तकनीक पहुंचाने के लिए प्रतिबद्ध हैं — यह सुनिश्चित करते हुए कि प्रत्येक किसान को वह ज्ञान और सहायता मिले जिसका वह हकदार है।'
                  : 'We are committed to bringing technology to the roots of India — ensuring that every farmer gets the knowledge and support they deserve.',
            ),
            _section(
              '📍',
              isHindi ? 'सेवा क्षेत्र' : 'Service Area',
              isHindi
                  ? 'पंजाब में गेहूं से लेकर तमिलनाडु में सब्जियों तक — किसान साथी आपका दैनिक कृषि सहायक है।'
                  : 'From wheat in Punjab to vegetables in Tamil Nadu — Kisaan Saathi is your daily agricultural companion.',
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? '📞 संपर्क करें' : '📞 Contact Us',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
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
                isHindi
                    ? 'किसान साथी समुदाय का हिस्सा बनने के लिए धन्यवाद\nमिलकर हम मज़बूत होते हैं 🇮🇳🌾'
                    : 'Thank you for being part of the Kisaan Saathi community\nTogether we grow stronger 🇮🇳🌾',
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white, height: 1.6)),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Text(text, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      ],
    );
  }
}
