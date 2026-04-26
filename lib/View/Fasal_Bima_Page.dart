import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FasalBimaPage extends StatelessWidget {
  const FasalBimaPage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  static const _schemes = [
    {
      'name': 'प्रधानमंत्री फसल बीमा योजना',
      'nameEn': 'PM Fasal Bima Yojana',
      'icon': '🛡️',
      'color': 0xFF1B5E20,
      'premium': 'खरीफ: 2% | रबी: 1.5% | बागवानी: 5%',
      'premiumEn': 'Kharif: 2% | Rabi: 1.5% | Horticulture: 5%',
      'coverage': 'प्राकृतिक आपदा, कीट, रोग, सूखा, बाढ़',
      'coverageEn': 'Natural disasters, pests, disease, drought, flood',
      'howTo': 'नजदीकी बैंक, CSC केंद्र या pmfby.gov.in पर आवेदन करें',
      'howToEn': 'Apply at nearest bank, CSC center or pmfby.gov.in',
      'deadline': 'खरीफ: 31 जुलाई | रबी: 31 दिसंबर',
      'deadlineEn': 'Kharif: 31 July | Rabi: 31 December',
      'url': 'https://pmfby.gov.in',
    },
    {
      'name': 'पुनर्गठित मौसम आधारित फसल बीमा',
      'nameEn': 'Restructured Weather Based Crop Insurance',
      'icon': '🌧️',
      'color': 0xFF01579B,
      'premium': 'फसल के अनुसार (1.5%–5%)',
      'premiumEn': 'Varies by crop (1.5%–5%)',
      'coverage': 'तापमान, वर्षा, आर्द्रता आधारित नुकसान',
      'coverageEn': 'Temperature, rainfall, humidity-based losses',
      'howTo': 'बैंक शाखा या बीमा कंपनी से संपर्क करें',
      'howToEn': 'Contact bank branch or insurance company',
      'deadline': 'फसल बुवाई के 30 दिन के भीतर',
      'deadlineEn': 'Within 30 days of crop sowing',
      'url': 'https://pmfby.gov.in',
    },
  ];

  static const _docs = [
    {'icon': '🪪', 'doc': 'आधार कार्ड', 'docEn': 'Aadhaar Card'},
    {'icon': '🏦', 'doc': 'बैंक पासबुक', 'docEn': 'Bank Passbook'},
    {'icon': '📄', 'doc': 'खसरा/खतौनी', 'docEn': 'Khasra/Khatauni'},
    {'icon': '🌱', 'doc': 'बुवाई प्रमाण पत्र', 'docEn': 'Sowing Certificate'},
    {'icon': '📱', 'doc': 'मोबाइल नंबर', 'docEn': 'Mobile Number'},
  ];

  static const _faqs = [
    {
      'q': 'बीमा राशि कैसे मिलती है?',
      'qEn': 'How to claim insurance amount?',
      'a': 'फसल नुकसान के 72 घंटे के भीतर बैंक या बीमा कंपनी को सूचित करें। फोन पर भी सूचना दे सकते हैं।',
      'aEn': 'Inform bank or insurance company within 72 hours of crop loss. You can also report by phone.',
    },
    {
      'q': 'क्या किरायेदार किसान भी ले सकते हैं?',
      'qEn': 'Can tenant farmers also apply?',
      'a': 'हाँ, जो किसान दूसरे की जमीन पर खेती करते हैं वे भी इस योजना का लाभ उठा सकते हैं।',
      'aEn': 'Yes, farmers who cultivate on others\' land can also avail this scheme.',
    },
    {
      'q': 'बीमा कब से लागू होता है?',
      'qEn': 'When does insurance become effective?',
      'a': 'अंतिम तिथि से पहले प्रीमियम भुगतान के बाद बीमा तुरंत लागू हो जाता है।',
      'aEn': 'Insurance becomes effective immediately after premium payment before the deadline.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _green1,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(isHindi ? 'फसल बीमा' : 'Crop Insurance',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(isHindi),
            const SizedBox(height: 16),
            _sectionTitle(isHindi ? 'बीमा योजनाएं' : 'Insurance Schemes', '🛡️'),
            const SizedBox(height: 10),
            ..._schemes.map((s) => _buildSchemeCard(s, isHindi, context)),
            const SizedBox(height: 8),
            _sectionTitle(isHindi ? 'जरूरी दस्तावेज' : 'Required Documents', '📋'),
            const SizedBox(height: 10),
            _buildDocsCard(isHindi),
            const SizedBox(height: 16),
            _sectionTitle(isHindi ? 'सामान्य प्रश्न' : 'FAQs', '❓'),
            const SizedBox(height: 10),
            ..._faqs.map((f) => _buildFaqCard(f, isHindi)),
            const SizedBox(height: 16),
            _buildHelplineCard(isHindi),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF43A047)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Text('🛡️', style: TextStyle(fontSize: 52)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'फसल बीमा' : 'Crop Insurance',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(isHindi ? 'अपनी मेहनत को सुरक्षित करें' : 'Protect your hard work',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(isHindi ? 'न्यूनतम प्रीमियम पर अधिकतम सुरक्षा' : 'Maximum coverage at minimum premium',
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
      ],
    );
  }

  Widget _buildSchemeCard(Map scheme, bool isHindi, BuildContext context) {
    final color = Color(scheme['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(scheme['icon'] as String, style: const TextStyle(fontSize: 22))),
              const SizedBox(width: 10),
              Expanded(
                child: Text(isHindi ? scheme['name'] as String : scheme['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow('💰', isHindi ? 'प्रीमियम' : 'Premium', isHindi ? scheme['premium'] as String : scheme['premiumEn'] as String),
          _infoRow('🌿', isHindi ? 'कवरेज' : 'Coverage', isHindi ? scheme['coverage'] as String : scheme['coverageEn'] as String),
          _infoRow('📅', isHindi ? 'अंतिम तिथि' : 'Deadline', isHindi ? scheme['deadline'] as String : scheme['deadlineEn'] as String),
          _infoRow('📝', isHindi ? 'आवेदन' : 'How to Apply', isHindi ? scheme['howTo'] as String : scheme['howToEn'] as String),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launch(scheme['url'] as String),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(isHindi ? 'अधिक जानें' : 'Learn More', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Text('$label: ', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildDocsCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [_green1.withValues(alpha: 0.07), _green1.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _docs.map((d) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _green2.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(d['icon']!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(isHindi ? d['doc']! : d['docEn']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _green1)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildFaqCard(Map faq, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [_green1.withValues(alpha: 0.07), _green1.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green2.withValues(alpha: 0.18)),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('❓', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(child: Text(isHindi ? faq['q'] as String : faq['qEn'] as String,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87))),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(isHindi ? faq['a'] as String : faq['aEn'] as String,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('📞', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'फसल बीमा हेल्पलाइन' : 'Crop Insurance Helpline',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1565C0))),
                Text('1800-200-7710', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF1565C0))),
                Text(isHindi ? 'सोमवार–शुक्रवार, सुबह 10 – शाम 5' : 'Mon–Fri, 10 AM – 5 PM',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded, color: Color(0xFF1565C0), size: 28),
            onPressed: () => _launch('tel:18002007710'),
          ),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
