import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  List<Map<String, String>> _getFaqs(bool isHindi) {
    return [
      {
        'q': isHindi ? 'प्रोफ़ाइल कैसे अपडेट करें?' : 'How to update profile?',
        'a': isHindi
            ? 'प्रोफ़ाइल स्क्रीन से "प्रोफ़ाइल संपादित करें" पर जाएं और अपनी जानकारी अपडेट करें।'
            : 'Go to "Edit Profile" from the Profile screen and update your information.',
        'icon': '👤',
      },
      {
        'q': isHindi ? 'पासवर्ड कैसे रीसेट करें?' : 'How to reset password?',
        'a': isHindi
            ? 'लॉगिन स्क्रीन पर "पासवर्ड भूल गए" पर क्लिक करें और निर्देशों का पालन करें।'
            : 'Click "Forgot Password" on the login screen and follow the instructions.',
        'icon': '🔑',
      },
      {
        'q': isHindi ? 'क्या मेरा डेटा सुरक्षित है?' : 'Is my data secure?',
        'a': isHindi
            ? 'हां, आपका डेटा सुरक्षित रूप से संग्रहीत है और आपकी अनुमति के बिना किसी के साथ साझा नहीं किया जाता।'
            : 'Yes, your data is stored securely and is never shared with anyone without your permission.',
        'icon': '🔒',
      },
      {
        'q': isHindi ? 'सहायता से कैसे संपर्क करें?' : 'How to contact support?',
        'a': isHindi
            ? 'किसी भी समस्या के लिए support@kisanseva.com पर ईमेल करें या +91-9876543210 पर कॉल करें।'
            : 'For any issue, email us at support@kisanseva.com or call +91-9876543210.',
        'icon': '📞',
      },
      {
        'q': isHindi ? 'ऐप से लॉगआउट कैसे करें?' : 'How to logout from the app?',
        'a': isHindi
            ? 'प्रोफ़ाइल स्क्रीन नीचे स्क्रॉल करें और "लॉगआउट" बटन पर क्लिक करें।'
            : 'Scroll down on the Profile screen and click the "Logout" button.',
        'icon': '🚪',
      },
      {
        'q': isHindi ? 'भाषा कैसे बदलें?' : 'How to change language?',
        'a': isHindi
            ? 'प्रोफ़ाइल में जाकर भाषा सेटिंग बदल सकते हैं या ऐप दोबारा खोलने पर भाषा चुन सकते हैं।'
            : 'Go to Profile to change language settings, or choose the language when reopening the app.',
        'icon': '🌐',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final faqs = _getFaqs(isHindi);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'सहायता केंद्र' : 'Help Center',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🙋', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHindi ? 'आपकी कैसे मदद करें?' : 'How can we help you?',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isHindi ? 'नीचे अक्सर पूछे जाने वाले सवाल देखें' : 'See frequently asked questions below',
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            isHindi ? 'अक्सर पूछे जाने वाले सवाल' : 'Frequently Asked Questions',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),

          ...faqs.map((faq) => _faqCard(faq)),
          const SizedBox(height: 8),

          // Contact card
          Container(
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
                Text(
                  isHindi ? '📧 अभी भी समस्या है?' : '📧 Still having an issue?',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi ? 'हमें ईमेल करें: support@kisanseva.com' : 'Email us: support@kisanseva.com',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  isHindi ? 'या कॉल करें: +91-9876543210' : 'Or call us: +91-9876543210',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqCard(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.white24),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(faq['icon']!, style: const TextStyle(fontSize: 18))),
          ),
          title: Text(faq['q']!,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(faq['a']!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white, height: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
