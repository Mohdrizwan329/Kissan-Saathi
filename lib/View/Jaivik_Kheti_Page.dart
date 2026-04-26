import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class JaivikKhetiPage extends StatefulWidget {
  const JaivikKhetiPage({super.key});
  @override
  State<JaivikKhetiPage> createState() => _JaivikKhetiPageState();
}

class _JaivikKhetiPageState extends State<JaivikKhetiPage>
    with SingleTickerProviderStateMixin {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  static const _composts = [
    {
      'name': 'वर्मीकम्पोस्ट', 'nameEn': 'Vermicompost',
      'icon': '🪱', 'color': 0xFF4E342E,
      'time': '45–60 दिन', 'timeEn': '45–60 days',
      'materials': 'गोबर + कृषि अवशेष + केंचुआ', 'materialsEn': 'Dung + farm residue + earthworms',
      'benefit': 'NPK + सूक्ष्म पोषक तत्व, मिट्टी की बनावट सुधारे', 'benefitEn': 'NPK + micronutrients, improves soil structure',
      'dose': '2–3 टन/एकड़', 'doseEn': '2–3 tonnes/acre',
    },
    {
      'name': 'गोबर खाद (FYM)', 'nameEn': 'Farmyard Manure (FYM)',
      'icon': '💩', 'color': 0xFF795548,
      'time': '3–6 महीने', 'timeEn': '3–6 months',
      'materials': 'पशु गोबर + मूत्र + भूसा', 'materialsEn': 'Animal dung + urine + straw',
      'benefit': 'मिट्टी में जीवाणु बढ़ाए, जल धारण क्षमता बेहतर', 'benefitEn': 'Increases soil bacteria, better water retention',
      'dose': '5–10 टन/एकड़', 'doseEn': '5–10 tonnes/acre',
    },
    {
      'name': 'हरी खाद', 'nameEn': 'Green Manure',
      'icon': '🌿', 'color': 0xFF2E7D32,
      'time': '45–55 दिन', 'timeEn': '45–55 days',
      'materials': 'ढैंचा, सनई, मूंग बुवाई + मिट्टी में पलटाव', 'materialsEn': 'Dhaincha, sunn hemp, moong sowing + soil turning',
      'benefit': 'नाइट्रोजन स्थिरीकरण, जैव तत्व बढ़ाए', 'benefitEn': 'Nitrogen fixation, increases organic matter',
      'dose': 'एक फसल (25–30 किलो बीज/एकड़)', 'doseEn': 'One crop (25–30 kg seed/acre)',
    },
    {
      'name': 'जीवामृत', 'nameEn': 'Jeevamrit',
      'icon': '🫙', 'color': 0xFF1565C0,
      'time': '7–10 दिन (तैयारी)', 'timeEn': '7–10 days (preparation)',
      'materials': '200L पानी + 10 किलो गोबर + 10L गोमूत्र + बेसन + गुड़', 'materialsEn': '200L water + 10 kg dung + 10L cow urine + gram flour + jaggery',
      'benefit': 'मिट्टी में सूक्ष्मजीव बढ़ाए, फसल की रोगप्रतिरोधता बढ़े', 'benefitEn': 'Increases soil microbes, boosts crop immunity',
      'dose': '200 लीटर प्रति एकड़ (सिंचाई के साथ)', 'doseEn': '200 liters per acre (with irrigation)',
    },
    {
      'name': 'बायो-कम्पोस्ट', 'nameEn': 'Bio-Compost',
      'icon': '🌱', 'color': 0xFF00695C,
      'time': '60–90 दिन', 'timeEn': '60–90 days',
      'materials': 'कृषि अवशेष + ट्राइकोडर्मा + PSB बैक्टीरिया', 'materialsEn': 'Farm residue + Trichoderma + PSB bacteria',
      'benefit': 'जैव उर्वरक + रोग नियंत्रण + मिट्टी सुधार', 'benefitEn': 'Bio-fertilizer + disease control + soil improvement',
      'dose': '2 टन/एकड़', 'doseEn': '2 tonnes/acre',
    },
  ];

  static const _pestControl = [
    {
      'name': 'नीम काढ़ा', 'nameEn': 'Neem Decoction',
      'icon': '🌿', 'color': 0xFF2E7D32,
      'pests': 'माहू, तेला, सफेद मक्खी', 'pestsEn': 'Aphids, thrips, whitefly',
      'how': '5 किलो नीम पत्ती को 10L पानी में उबालें, छानकर 200L में मिलाकर छिड़कें',
      'howEn': 'Boil 5 kg neem leaves in 10L water, filter and mix in 200L, spray',
    },
    {
      'name': 'नीम तेल', 'nameEn': 'Neem Oil',
      'icon': '🫙', 'color': 0xFF827717,
      'pests': 'कीट-पतंगे, फंगस, माइट', 'pestsEn': 'Insects, fungus, mites',
      'how': '3–5 मिली नीम तेल प्रति लीटर पानी + साबुन + छिड़काव',
      'howEn': '3–5 ml neem oil per liter water + soap + spray',
    },
    {
      'name': 'दशपर्णी अर्क', 'nameEn': 'Dashparni Extract',
      'icon': '🍃', 'color': 0xFF1B5E20,
      'pests': 'अधिकांश कीट और रोग', 'pestsEn': 'Most insects and diseases',
      'how': '10 पत्तियों का रस + गोमूत्र + 10 दिन सड़ाएं, 3% घोल छिड़कें',
      'howEn': 'Juice of 10 plant leaves + cow urine + ferment 10 days, spray 3% solution',
    },
    {
      'name': 'ट्राइकोडर्मा', 'nameEn': 'Trichoderma',
      'icon': '🧫', 'color': 0xFF0277BD,
      'pests': 'जड़ सड़न, उकठा, आर्द्र गलन', 'pestsEn': 'Root rot, wilt, damping off',
      'how': 'बीज उपचार: 5 ग्राम/किलो बीज | मिट्टी उपचार: 2 किलो/एकड़',
      'howEn': 'Seed treatment: 5 g/kg seed | Soil treatment: 2 kg/acre',
    },
    {
      'name': 'फेरोमोन ट्रैप', 'nameEn': 'Pheromone Trap',
      'icon': '🪤', 'color': 0xFFE65100,
      'pests': 'तनाछेदक, फल छेदक', 'pestsEn': 'Stem borer, fruit borer',
      'how': '4–5 ट्रैप प्रति एकड़, साप्ताहिक जांच',
      'howEn': '4–5 traps per acre, weekly inspection',
    },
  ];

  static const _certification = [
    {
      'step': '1', 'title': 'पंजीकरण', 'titleEn': 'Registration',
      'desc': 'APEDA या राज्य जैविक प्रमाणीकरण एजेंसी में आवेदन करें',
      'descEn': 'Apply at APEDA or State Organic Certification Agency',
    },
    {
      'step': '2', 'title': 'रूपांतरण अवधि', 'titleEn': 'Conversion Period',
      'desc': '3 वर्ष तक रासायनिक खाद/दवा का प्रयोग बंद करें',
      'descEn': 'Stop chemical fertilizer/pesticide use for 3 years',
    },
    {
      'step': '3', 'title': 'निरीक्षण', 'titleEn': 'Inspection',
      'desc': 'प्रमाणीकरण एजेंसी खेत का निरीक्षण करेगी',
      'descEn': 'Certification agency will inspect your farm',
    },
    {
      'step': '4', 'title': 'प्रमाणपत्र', 'titleEn': 'Certificate',
      'desc': 'जैविक प्रमाणपत्र मिलने पर "India Organic" लेबल लगा सकते हैं',
      'descEn': 'After getting certificate, can use "India Organic" label',
    },
  ];

  static const _schemes = [
    {
      'name': 'PM परंपरागत कृषि विकास योजना', 'nameEn': 'PM PKVY',
      'benefit': '₹50,000/हेक्टेयर 3 वर्ष तक', 'benefitEn': '₹50,000/hectare for 3 years',
      'url': 'https://pgsindia-ncof.gov.in',
    },
    {
      'name': 'राष्ट्रीय जैविक खेती परियोजना', 'nameEn': 'National Organic Farming Project',
      'benefit': 'जैविक निवेश पर 50% सब्सिडी', 'benefitEn': '50% subsidy on organic inputs',
      'url': 'https://ncof.dacnet.nic.in',
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
        title: Text(
          isHindi ? 'जैविक खेती' : 'Organic Farming',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: false,
          labelPadding: EdgeInsets.zero,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          tabs: [
            Tab(text: isHindi ? 'खाद बनाएं' : 'Compost'),
            Tab(text: isHindi ? 'जैव कीटनाशक' : 'Bio Pesticides'),
            Tab(text: isHindi ? 'प्रमाणीकरण' : 'Certification'),
            Tab(text: isHindi ? 'योजनाएं' : 'Schemes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCompost(isHindi),
          _buildPestControl(isHindi),
          _buildCertification(isHindi),
          _buildSchemes(isHindi),
        ],
      ),
    );
  }

  Widget _buildCompost(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('♻️', isHindi ? 'जैविक खाद से मिट्टी जीवित रहती है, लागत घटती है' : 'Organic manure keeps soil alive and reduces costs', _green1),
          const SizedBox(height: 14),
          ..._composts.map((c) => _compostCard(c, isHindi)),
        ],
      ),
    );
  }

  Widget _compostCard(Map c, bool isHindi) {
    final color = Color(c['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(c['icon'] as String, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(isHindi ? c['name'] as String : c['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(isHindi ? c['time'] as String : c['timeEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _row('🧱', isHindi ? 'सामग्री' : 'Materials', isHindi ? c['materials'] as String : c['materialsEn'] as String),
          _row('✅', isHindi ? 'फायदा' : 'Benefit', isHindi ? c['benefit'] as String : c['benefitEn'] as String),
          _row('📏', isHindi ? 'मात्रा' : 'Dose', isHindi ? c['dose'] as String : c['doseEn'] as String),
        ],
      ),
    );
  }

  Widget _buildPestControl(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🌿', isHindi ? 'रासायनिक दवाओं की जगह जैव कीटनाशक अपनाएं' : 'Use bio-pesticides instead of chemical pesticides', const Color(0xFF2E7D32)),
          const SizedBox(height: 14),
          ..._pestControl.map((p) => _pestCard(p, isHindi)),
        ],
      ),
    );
  }

  Widget _pestCard(Map p, bool isHindi) {
    final color = Color(p['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(p['icon'] as String, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(isHindi ? p['name'] as String : p['nameEn'] as String,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          _row('🐛', isHindi ? 'प्रभावी कीट' : 'Effective against', isHindi ? p['pests'] as String : p['pestsEn'] as String),
          _row('📋', isHindi ? 'विधि' : 'How to use', isHindi ? p['how'] as String : p['howEn'] as String),
        ],
      ),
    );
  }

  Widget _buildCertification(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🏆', isHindi ? 'जैविक प्रमाणपत्र से 20–30% अधिक भाव मिलता है' : 'Organic certificate gives 20–30% higher price', const Color(0xFF4A148C)),
          const SizedBox(height: 14),
          ..._certification.map((s) => _certStep(s, isHindi)),
          const SizedBox(height: 8),
          _pgsCard(isHindi),
        ],
      ),
    );
  }

  Widget _certStep(Map s, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [_green1.withValues(alpha: 0.08), _green1.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: _green2, shape: BoxShape.circle),
            child: Center(child: Text(s['step'] as String, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? s['title'] as String : s['titleEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
                const SizedBox(height: 4),
                Text(isHindi ? s['desc'] as String : s['descEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pgsCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '📋 PGS-India (छोटे किसानों के लिए)' : '📋 PGS-India (For Small Farmers)',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
          const SizedBox(height: 6),
          Text(
            isHindi
                ? 'Participatory Guarantee System — समूह में प्रमाणीकरण, कम खर्च में। 5+ किसान मिलकर आवेदन कर सकते हैं।'
                : 'Participatory Guarantee System — group certification at low cost. 5+ farmers can apply together.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _launch('https://pgsindia-ncof.gov.in'),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: Text(isHindi ? 'PGS पोर्टल खोलें' : 'Open PGS Portal',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(foregroundColor: _green1, side: BorderSide(color: _green1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemes(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🏛️', isHindi ? 'जैविक खेती पर सरकार दे रही है भारी सहायता' : 'Government is providing huge support for organic farming', const Color(0xFF1565C0)),
          const SizedBox(height: 14),
          ..._schemes.map((s) => _schemeCard(s, isHindi)),
          const SizedBox(height: 8),
          _benefitCard(isHindi),
        ],
      ),
    );
  }

  Widget _schemeCard(Map s, bool isHindi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [_green1.withValues(alpha: 0.08), _green1.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? s['name'] as String : s['nameEn'] as String,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
          const SizedBox(height: 6),
          Text(isHindi ? s['benefit'] as String : s['benefitEn'] as String,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _launch(s['url'] as String),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: Text(isHindi ? 'जानकारी लें' : 'Learn More',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(foregroundColor: _green1, side: BorderSide(color: _green1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }

  Widget _benefitCard(bool isHindi) {
    final benefits = isHindi
        ? ['उत्पाद का 20–50% अधिक बाजार भाव', 'रासायनिक खाद पर खर्च कम', 'मिट्टी की उर्वरता दीर्घकालिक', 'निर्यात के अवसर बढ़ते हैं', 'स्वास्थ्य के लिए सुरक्षित']
        : ['20–50% higher market price', 'Less spending on chemical fertilizers', 'Long-term soil fertility', 'More export opportunities', 'Safer for health'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF43A047)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '🌱 जैविक खेती के फायदे' : '🌱 Benefits of Organic Farming',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 10),
          ...benefits.map((b) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(b, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _row(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text('$label: ', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _infoCard(String icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4))),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
