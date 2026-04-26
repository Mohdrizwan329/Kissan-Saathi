import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class KisanHelplinePage extends StatelessWidget {
  const KisanHelplinePage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  static const _helplines = [
    {
      'name': 'किसान कॉल सेंटर',
      'nameEn': 'Kisan Call Centre',
      'number': '1800-180-1551',
      'desc': 'कृषि संबंधी किसी भी समस्या के लिए 24×7 निःशुल्क सेवा',
      'descEn': '24×7 free service for any agriculture related problem',
      'icon': '🌾',
      'color': 0xFF1B5E20,
      'available': '24×7',
    },
    {
      'name': 'पीएम फसल बीमा हेल्पलाइन',
      'nameEn': 'PM Fasal Bima Helpline',
      'number': '1800-200-7710',
      'desc': 'फसल बीमा, दावे और प्रीमियम संबंधी जानकारी',
      'descEn': 'Crop insurance, claims and premium information',
      'icon': '🛡️',
      'color': 0xFF01579B,
      'available': 'सोम–शुक्र 10–5',
    },
    {
      'name': 'मृदा स्वास्थ्य हेल्पलाइन',
      'nameEn': 'Soil Health Helpline',
      'number': '1800-180-1551',
      'desc': 'मिट्टी परीक्षण और स्वास्थ्य कार्ड जानकारी',
      'descEn': 'Soil testing and health card information',
      'icon': '🌱',
      'color': 0xFF4E342E,
      'available': 'सुबह 9 – शाम 6',
    },
    {
      'name': 'राष्ट्रीय आपदा हेल्पलाइन',
      'nameEn': 'National Disaster Helpline',
      'number': '1078',
      'desc': 'बाढ़, सूखा, ओलावृष्टि जैसी आपदाओं के लिए',
      'descEn': 'For disasters like flood, drought, hailstorm',
      'icon': '⚠️',
      'color': 0xFFBF360C,
      'available': '24×7',
    },
    {
      'name': 'कृषि मंत्रालय हेल्पलाइन',
      'nameEn': 'Agriculture Ministry Helpline',
      'number': '011-23382012',
      'desc': 'सरकारी योजनाओं और नीतियों की जानकारी',
      'descEn': 'Information about government schemes and policies',
      'icon': '🏛️',
      'color': 0xFF4A148C,
      'available': 'सुबह 9 – शाम 5',
    },
    {
      'name': 'नाबार्ड हेल्पलाइन',
      'nameEn': 'NABARD Helpline',
      'number': '1800-26-26763',
      'desc': 'कृषि ऋण, KCC और वित्तीय सहायता',
      'descEn': 'Agricultural loans, KCC and financial assistance',
      'icon': '🏦',
      'color': 0xFF006064,
      'available': 'सोम–शुक्र 9–6',
    },
  ];

  static const _usefulContacts = [
    {'name': 'ICAR हेल्पलाइन', 'nameEn': 'ICAR Helpline', 'number': '011-25843375', 'icon': '🔬'},
    {'name': 'मौसम विभाग', 'nameEn': 'Weather Dept.', 'number': '1800-180-1717', 'icon': '🌤️'},
    {'name': 'किसान क्रेडिट', 'nameEn': 'Kisan Credit', 'number': '1800-11-0001', 'icon': '💳'},
    {'name': 'SBI किसान', 'nameEn': 'SBI Kisan', 'number': '1800-11-2211', 'icon': '🏦'},
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
        title: Text(isHindi ? 'किसान हेल्पलाइन' : 'Kisan Helpline',
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
            _sectionTitle(isHindi ? 'मुख्य हेल्पलाइन' : 'Main Helplines', '📞'),
            const SizedBox(height: 10),
            ..._helplines.map((h) => _buildHelplineCard(h, isHindi)),
            const SizedBox(height: 8),
            _sectionTitle(isHindi ? 'अन्य उपयोगी नंबर' : 'Other Useful Numbers', '📱'),
            const SizedBox(height: 10),
            _buildOtherContacts(isHindi),
            const SizedBox(height: 16),
            _buildTipCard(isHindi),
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
          const Text('📞', style: TextStyle(fontSize: 52)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'किसान हेल्पलाइन' : 'Kisan Helpline',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(isHindi ? 'जरूरत पर तुरंत मदद पाएं' : 'Get immediate help when needed',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(isHindi ? 'अधिकांश नंबर निःशुल्क हैं' : 'Most numbers are toll-free',
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

  Widget _buildHelplineCard(Map h, bool isHindi) {
    final color = Color(h['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(h['icon'] as String, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? h['name'] as String : h['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                Text(isHindi ? h['desc'] as String : h['descEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54, height: 1.4)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(h['available'] as String, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(h['number'] as String, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _call(h['number'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.call_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(isHindi ? 'कॉल' : 'Call', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherContacts(bool isHindi) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2),
      itemCount: _usefulContacts.length,
      itemBuilder: (ctx, i) {
        final c = _usefulContacts[i];
        return GestureDetector(
          onTap: () => _call(c['number']!),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [_green1.withValues(alpha: 0.08), _green1.withValues(alpha: 0.02)]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _green2.withValues(alpha: 0.20)),
              boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Text(c['icon']!, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isHindi ? c['name']! : c['nameEn']!, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(c['number']!, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _green2)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF8F00).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('💡', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(isHindi ? 'कॉल करने से पहले तैयार रखें' : 'Keep ready before calling',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFFE65100))),
          ]),
          const SizedBox(height: 8),
          ...[ isHindi ? '• आधार / किसान पंजीकरण नंबर' : '• Aadhaar / Farmer registration number',
               isHindi ? '• खसरा/खाता नंबर' : '• Khasra/Account number',
               isHindi ? '• फसल और समस्या का विवरण' : '• Crop name and problem description',
               isHindi ? '• बैंक खाता नंबर (बीमा दावों के लिए)' : '• Bank account number (for insurance claims)',
          ].map((t) => Padding(padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(t, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)))),
        ],
      ),
    );
  }

  void _call(String number) async {
    final clean = number.replaceAll('-', '').replaceAll(' ', '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}
