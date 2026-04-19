import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class TermsPrivacyPage extends StatefulWidget {
  const TermsPrivacyPage({super.key});

  @override
  State<TermsPrivacyPage> createState() => _TermsPrivacyPageState();
}

class _TermsPrivacyPageState extends State<TermsPrivacyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFF6F4EE);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text('नियम व गोपनीयता', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
          tabs: const [Tab(text: '📜 नियम'), Tab(text: '🔒 गोपनीयता')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _termsTab(),
          _privacyTab(),
        ],
      ),
    );
  }

  Widget _termsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header('📜', 'नियम और शर्तें', 'किसान साथी ऐप में आपका स्वागत है।'),
          const SizedBox(height: 12),
          _termCard('1', 'उपयोग का उद्देश्य', 'ऐप किसानों और कृषि कर्मियों के लिए जानकारी और सेवाओं तक पहुंचने के लिए है।'),
          _termCard('2', 'दुरुपयोग पर प्रतिबंध', 'ऐप का दुरुपयोग न करें और हैकिंग या नुकसान पहुंचाने की कोशिश न करें।'),
          _termCard('3', 'डेटा की सटीकता', 'हम किसी भी गलत डेटा या तृतीय-पक्ष जानकारी के कारण होने वाले नुकसान के लिए जिम्मेदार नहीं हैं।'),
          _termCard('4', 'बाजार भाव', 'बाजार मूल्य और मौसम जानकारी विश्वसनीय स्रोतों से है, लेकिन सटीकता भिन्न हो सकती है।'),
          _contactFooter(),
        ],
      ),
    );
  }

  Widget _privacyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header('🔒', 'गोपनीयता नीति', 'आपकी गोपनीयता हमारे लिए महत्वपूर्ण है।'),
          const SizedBox(height: 12),
          _termCard('1', 'डेटा संग्रह', 'हम केवल मूल जानकारी जैसे नाम, फोन नंबर और स्थान एकत्र करते हैं।'),
          _termCard('2', 'डेटा सुरक्षा', 'हम आपका डेटा बेचते, साझा या दुरुपयोग नहीं करते।'),
          _termCard('3', 'डेटा सुरक्षित रखना', 'आपका डेटा सुरक्षित रूप से संग्रहीत है और केवल ऐप अनुभव में सुधार के लिए उपयोग किया जाता है।'),
          _termCard('4', 'डेटा हटाने का अधिकार', 'आप किसी भी समय अपना खाता और डेटा हटाने का अनुरोध कर सकते हैं।'),
          _contactFooter(),
        ],
      ),
    );
  }

  Widget _header(String emoji, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _termCard(String num, String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
            child: Center(child: Text(num, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: _green1))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(body, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 संपर्क', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
            const SizedBox(height: 6),
            Text('support@kisanseva.com', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
            Text('+91-9876543210', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
