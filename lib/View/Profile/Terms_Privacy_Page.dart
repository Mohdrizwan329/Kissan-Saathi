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
  static const _cream = Color(0xFFE8F5E9);

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
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'नियम व गोपनीयता' : 'Terms & Privacy',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
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
          tabs: [
            Tab(text: isHindi ? '📜 नियम' : '📜 Terms'),
            Tab(text: isHindi ? '🔒 गोपनीयता' : '🔒 Privacy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _termsTab(isHindi),
          _privacyTab(isHindi),
        ],
      ),
    );
  }

  Widget _termsTab(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(
            '📜',
            isHindi ? 'नियम और शर्तें' : 'Terms & Conditions',
            isHindi ? 'किसान साथी ऐप में आपका स्वागत है।' : 'Welcome to the Kisaan Saathi app.',
          ),
          const SizedBox(height: 12),
          _termCard(
            '1',
            isHindi ? 'उपयोग का उद्देश्य' : 'Purpose of Use',
            isHindi
                ? 'ऐप किसानों और कृषि कर्मियों के लिए जानकारी और सेवाओं तक पहुंचने के लिए है।'
                : 'The app is intended for farmers and agricultural workers to access information and services.',
          ),
          _termCard(
            '2',
            isHindi ? 'दुरुपयोग पर प्रतिबंध' : 'Prohibition of Misuse',
            isHindi
                ? 'ऐप का दुरुपयोग न करें और हैकिंग या नुकसान पहुंचाने की कोशिश न करें।'
                : 'Do not misuse the app or attempt to hack or cause damage.',
          ),
          _termCard(
            '3',
            isHindi ? 'डेटा की सटीकता' : 'Data Accuracy',
            isHindi
                ? 'हम किसी भी गलत डेटा या तृतीय-पक्ष जानकारी के कारण होने वाले नुकसान के लिए जिम्मेदार नहीं हैं।'
                : 'We are not responsible for any loss caused by incorrect data or third-party information.',
          ),
          _termCard(
            '4',
            isHindi ? 'बाजार भाव' : 'Market Prices',
            isHindi
                ? 'बाजार मूल्य और मौसम जानकारी विश्वसनीय स्रोतों से है, लेकिन सटीकता भिन्न हो सकती है।'
                : 'Market prices and weather information are sourced from reliable providers, but accuracy may vary.',
          ),
          _contactFooter(isHindi),
        ],
      ),
    );
  }

  Widget _privacyTab(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(
            '🔒',
            isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
            isHindi ? 'आपकी गोपनीयता हमारे लिए महत्वपूर्ण है।' : 'Your privacy is important to us.',
          ),
          const SizedBox(height: 12),
          _termCard(
            '1',
            isHindi ? 'डेटा संग्रह' : 'Data Collection',
            isHindi
                ? 'हम केवल मूल जानकारी जैसे नाम, फोन नंबर और स्थान एकत्र करते हैं।'
                : 'We collect only basic information such as name, phone number, and location.',
          ),
          _termCard(
            '2',
            isHindi ? 'डेटा सुरक्षा' : 'Data Protection',
            isHindi
                ? 'हम आपका डेटा बेचते, साझा या दुरुपयोग नहीं करते।'
                : 'We do not sell, share, or misuse your data.',
          ),
          _termCard(
            '3',
            isHindi ? 'डेटा सुरक्षित रखना' : 'Keeping Data Safe',
            isHindi
                ? 'आपका डेटा सुरक्षित रूप से संग्रहीत है और केवल ऐप अनुभव में सुधार के लिए उपयोग किया जाता है।'
                : 'Your data is stored securely and used only to improve the app experience.',
          ),
          _termCard(
            '4',
            isHindi ? 'डेटा हटाने का अधिकार' : 'Right to Delete Data',
            isHindi
                ? 'आप किसी भी समय अपना खाता और डेटा हटाने का अनुरोध कर सकते हैं।'
                : 'You can request deletion of your account and data at any time.',
          ),
          _contactFooter(isHindi),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(num, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text(body, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactFooter(bool isHindi) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi ? '📧 संपर्क' : '📧 Contact',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text('support@kisanseva.com', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
            Text('+91-9876543210', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
