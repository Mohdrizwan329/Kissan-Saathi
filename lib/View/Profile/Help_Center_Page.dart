import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFF6F4EE);

  static const _faqs = [
    {
      'q': 'प्रोफ़ाइल कैसे अपडेट करें?',
      'a': 'प्रोफ़ाइल स्क्रीन से "प्रोफ़ाइल संपादित करें" पर जाएं और अपनी जानकारी अपडेट करें।',
      'icon': '👤',
    },
    {
      'q': 'पासवर्ड कैसे रीसेट करें?',
      'a': 'लॉगिन स्क्रीन पर "पासवर्ड भूल गए" पर क्लिक करें और निर्देशों का पालन करें।',
      'icon': '🔑',
    },
    {
      'q': 'क्या मेरा डेटा सुरक्षित है?',
      'a': 'हां, आपका डेटा सुरक्षित रूप से संग्रहीत है और आपकी अनुमति के बिना किसी के साथ साझा नहीं किया जाता।',
      'icon': '🔒',
    },
    {
      'q': 'सहायता से कैसे संपर्क करें?',
      'a': 'किसी भी समस्या के लिए support@kisanseva.com पर ईमेल करें या +91-9876543210 पर कॉल करें।',
      'icon': '📞',
    },
    {
      'q': 'ऐप से लॉगआउट कैसे करें?',
      'a': 'प्रोफ़ाइल स्क्रीन नीचे स्क्रॉल करें और "लॉगआउट" बटन पर क्लिक करें।',
      'icon': '🚪',
    },
    {
      'q': 'भाषा कैसे बदलें?',
      'a': 'प्रोफ़ाइल में जाकर भाषा सेटिंग बदल सकते हैं या ऐप दोबारा खोलने पर भाषा चुन सकते हैं।',
      'icon': '🌐',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text('सहायता केंद्र', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
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
                      Text('आपकी कैसे मदद करें?', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text('नीचे अक्सर पूछे जाने वाले सवाल देखें', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text('अक्सर पूछे जाने वाले सवाल', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
          const SizedBox(height: 8),

          ..._faqs.map((faq) => _faqCard(faq)),
          const SizedBox(height: 8),

          // Contact card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📧 अभी भी समस्या है?', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: _green1)),
                const SizedBox(height: 8),
                Text('हमें ईमेल करें: support@kisanseva.com', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 4),
                Text('या कॉल करें: +91-9876543210', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(faq['icon']!, style: const TextStyle(fontSize: 18))),
          ),
          title: Text(faq['q']!,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF6F4EE), borderRadius: BorderRadius.circular(10)),
                child: Text(faq['a']!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, height: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
