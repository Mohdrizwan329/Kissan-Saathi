import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BhandaranPage extends StatefulWidget {
  const BhandaranPage({super.key});
  @override
  State<BhandaranPage> createState() => _BhandaranPageState();
}

class _BhandaranPageState extends State<BhandaranPage>
    with SingleTickerProviderStateMixin {
  static const _orange1 = Color(0xFFE65100);
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

  static const _cropStorage = [
    {
      'crop': 'गेहूं', 'cropEn': 'Wheat',
      'icon': '🌾', 'color': 0xFFFF8F00,
      'moisture': '12% से कम', 'moistureEn': 'Below 12%',
      'temp': '15–25°C', 'duration': '6–12 महीने', 'durationEn': '6–12 months',
      'method': 'कोठी, बखार, HDPE बैग, साइलो', 'methodEn': 'Kothi, Bakhar, HDPE bags, Silos',
      'tips': 'नीम की पत्तियाँ या अल्युमिनियम फॉस्फाइड टैबलेट से कीट नियंत्रण',
      'tipsEn': 'Pest control with neem leaves or aluminium phosphide tablets',
    },
    {
      'crop': 'धान', 'cropEn': 'Rice/Paddy',
      'icon': '🌾', 'color': 0xFF2E7D32,
      'moisture': '14% से कम', 'moistureEn': 'Below 14%',
      'temp': '10–25°C', 'duration': '6–12 महीने', 'durationEn': '6–12 months',
      'method': 'बोरी, HDPE बैग, वेयरहाउस', 'methodEn': 'Sacks, HDPE bags, Warehouse',
      'tips': 'धूप में 2–3 दिन सुखाएं, नमी मीटर से जांचें',
      'tipsEn': 'Sun dry for 2–3 days, check with moisture meter',
    },
    {
      'crop': 'मक्का', 'cropEn': 'Maize',
      'icon': '🌽', 'color': 0xFFFFD600,
      'moisture': '12–13%', 'moistureEn': '12–13%',
      'temp': '10–20°C', 'duration': '4–6 महीने', 'durationEn': '4–6 months',
      'method': 'बोरी, धातु की कोठी, साइलो', 'methodEn': 'Sacks, metal bins, silos',
      'tips': 'छिलका हटाकर सुखाएं, गोदाम में नमी से बचाएं',
      'tipsEn': 'Remove husk and dry well, protect from moisture in warehouse',
    },
    {
      'crop': 'आलू', 'cropEn': 'Potato',
      'icon': '🥔', 'color': 0xFF795548,
      'moisture': 'प्राकृतिक', 'moistureEn': 'Natural',
      'temp': '2–4°C (कोल्ड स्टोरेज)', 'duration': '6–8 महीने', 'durationEn': '6–8 months',
      'method': 'कोल्ड स्टोरेज अनिवार्य', 'methodEn': 'Cold storage mandatory',
      'tips': 'हरित (अंकुरित) आलू न रखें, छायादार कमरे में अल्पकाल',
      'tipsEn': 'Don\'t store green/sprouted potato, short-term in cool room',
    },
    {
      'crop': 'प्याज', 'cropEn': 'Onion',
      'icon': '🧅', 'color': 0xFF880E4F,
      'moisture': '10–12%', 'moistureEn': '10–12%',
      'temp': '25–30°C / 0–2°C', 'duration': '3–6 महीने', 'durationEn': '3–6 months',
      'method': 'खुली जाली वाली छाँव संरचना (Onion Storage Structure)',
      'methodEn': 'Open mesh shade structure (Onion Storage Structure)',
      'tips': 'अच्छे से सुखाएं, ऊपर की मिट्टी हटाएं, हवा लगती रहे',
      'tipsEn': 'Dry well, remove soil, ensure proper ventilation',
    },
    {
      'crop': 'दलहन / तिलहन', 'cropEn': 'Pulses / Oilseeds',
      'icon': '🫘', 'color': 0xFF4E342E,
      'moisture': '10% से कम', 'moistureEn': 'Below 10%',
      'temp': '15–25°C', 'duration': '6–12 महीने', 'durationEn': '6–12 months',
      'method': 'HDPE बैग, धातु की कोठी, वेयरहाउस',
      'methodEn': 'HDPE bags, metal bins, warehouse',
      'tips': 'नीम तेल या नीम की खल मिलाकर रखें',
      'tipsEn': 'Store with neem oil or neem cake mixed in',
    },
  ];

  static const _techniques = [
    {
      'name': 'HDPE बैग भंडारण', 'nameEn': 'HDPE Bag Storage',
      'icon': '🛍️', 'color': 0xFF1565C0,
      'cost': '₹60–100 प्रति बैग (50 किलो)', 'costEn': '₹60–100 per bag (50 kg)',
      'duration': '6–12 महीने', 'durationEn': '6–12 months',
      'suitable': 'अनाज, दलहन, बीज', 'suitableEn': 'Grains, pulses, seeds',
      'advantage': 'वायुरोधी, कीट और नमी से सुरक्षा, टिकाऊ',
      'advantageEn': 'Airtight, protection from pests and moisture, durable',
    },
    {
      'name': 'पक्की कोठी', 'nameEn': 'Brick Grain Bin (Kothi)',
      'icon': '🏠', 'color': 0xFF795548,
      'cost': '₹5,000–15,000 (एक बार)', 'costEn': '₹5,000–15,000 (one time)',
      'duration': '10–15 वर्ष', 'durationEn': '10–15 years',
      'suitable': 'गेहूं, धान, मक्का', 'suitableEn': 'Wheat, rice, maize',
      'advantage': 'टिकाऊ, परिवार के लिए उत्तम, सरकारी सहायता उपलब्ध',
      'advantageEn': 'Durable, great for family use, government assistance available',
    },
    {
      'name': 'कोल्ड स्टोरेज', 'nameEn': 'Cold Storage',
      'icon': '❄️', 'color': 0xFF0277BD,
      'cost': '₹0.50–2.00 प्रति किलो/माह', 'costEn': '₹0.50–2.00 per kg/month',
      'duration': '6–12 महीने', 'durationEn': '6–12 months',
      'suitable': 'आलू, सेब, प्याज, सब्जियाँ', 'suitableEn': 'Potato, apple, onion, vegetables',
      'advantage': 'लंबे समय तक ताजगी, अच्छा भाव मिलने तक इंतजार',
      'advantageEn': 'Long freshness, wait for good market price',
    },
    {
      'name': 'वेयरहाउस रसीद प्रणाली', 'nameEn': 'Warehouse Receipt System',
      'icon': '🏭', 'color': 0xFF2E7D32,
      'cost': 'सरकारी वेयरहाउस में रखें', 'costEn': 'Store in government warehouse',
      'duration': '3–12 महीने', 'durationEn': '3–12 months',
      'suitable': 'सभी अनाज', 'suitableEn': 'All grains',
      'advantage': 'रसीद पर बैंक से ऋण मिलता है (70–80% मूल्य)',
      'advantageEn': 'Bank loan on receipt (70–80% value)',
    },
  ];

  static const _valueAddition = [
    {
      'crop': 'टमाटर', 'cropEn': 'Tomato',
      'icon': '🍅', 'color': 0xFFE53935,
      'products': 'टोमैटो प्यूरी, सॉस, सूखे टमाटर, केचप',
      'productsEn': 'Tomato puree, sauce, dried tomatoes, ketchup',
      'profit': '3–5x अधिक मूल्य', 'profitEn': '3–5x more value',
    },
    {
      'crop': 'आम', 'cropEn': 'Mango',
      'icon': '🥭', 'color': 0xFFFF8F00,
      'products': 'अमचूर, आम पापड़, जूस, पल्प, अचार',
      'productsEn': 'Dry mango powder, papad, juice, pulp, pickle',
      'profit': '4–8x अधिक मूल्य', 'profitEn': '4–8x more value',
    },
    {
      'crop': 'मूंगफली', 'cropEn': 'Groundnut',
      'icon': '🥜', 'color': 0xFF795548,
      'products': 'तेल, मूंगफली बटर, चिक्की, नमकीन',
      'productsEn': 'Oil, peanut butter, chikki, namkeen',
      'profit': '2–4x अधिक मूल्य', 'profitEn': '2–4x more value',
    },
    {
      'crop': 'हल्दी', 'cropEn': 'Turmeric',
      'icon': '🟡', 'color': 0xFFFFD600,
      'products': 'हल्दी पाउडर, हल्दी दूध मिक्स, कैप्सूल',
      'productsEn': 'Turmeric powder, golden milk mix, capsules',
      'profit': '5–10x अधिक मूल्य', 'profitEn': '5–10x more value',
    },
  ];

  static const _schemes = [
    {
      'name': 'PM-FME (सूक्ष्म खाद्य उद्योग)', 'nameEn': 'PM-FME Scheme',
      'benefit': 'Processing unit पर 35% credit-linked subsidy', 'benefitEn': '35% credit-linked subsidy on processing unit',
      'url': 'https://pmfme.mofpi.gov.in',
    },
    {
      'name': 'NABARD ग्रामीण भंडारण', 'nameEn': 'NABARD Rural Godown Scheme',
      'benefit': 'गोदाम निर्माण पर 25–33% सब्सिडी', 'benefitEn': '25–33% subsidy on godown construction',
      'url': 'https://www.nabard.org',
    },
    {
      'name': 'राज्य वेयरहाउस कॉर्पोरेशन', 'nameEn': 'State Warehousing Corporation',
      'benefit': 'सरकारी गोदाम में रखें + ऋण सुविधा', 'benefitEn': 'Store in govt godown + loan facility',
      'url': 'https://cewacor.nic.in',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isHindi ? 'भंडारण गाइड' : 'Post-Harvest Storage',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF388E3C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
            Tab(text: isHindi ? 'फसल भंडारण' : 'Crop Storage'),
            Tab(text: isHindi ? 'भंडारण विधियाँ' : 'Techniques'),
            Tab(text: isHindi ? 'मूल्य वर्धन' : 'Value Addition'),
            Tab(text: isHindi ? 'योजनाएं' : 'Schemes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCropStorage(isHindi),
          _buildTechniques(isHindi),
          _buildValueAddition(isHindi),
          _buildSchemes(isHindi),
        ],
      ),
    );
  }

  Widget _buildCropStorage(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🏚️', isHindi ? 'सही भंडारण से 20–30% उपज बर्बादी रोकें' : 'Proper storage prevents 20–30% post-harvest loss', _orange1),
          const SizedBox(height: 14),
          ..._cropStorage.map((c) => _cropStorageCard(c, isHindi)),
        ],
      ),
    );
  }

  Widget _cropStorageCard(Map c, bool isHindi) {
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
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(c['icon'] as String, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(isHindi ? c['crop'] as String : c['cropEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(isHindi ? c['duration'] as String : c['durationEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _row('💧', isHindi ? 'नमी' : 'Moisture', isHindi ? c['moisture'] as String : c['moistureEn'] as String),
          _row('🌡️', isHindi ? 'तापमान' : 'Temperature', c['temp'] as String),
          _row('📦', isHindi ? 'विधि' : 'Method', isHindi ? c['method'] as String : c['methodEn'] as String),
          _row('💡', isHindi ? 'सुझाव' : 'Tips', isHindi ? c['tips'] as String : c['tipsEn'] as String),
        ],
      ),
    );
  }

  Widget _buildTechniques(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('📦', isHindi ? 'सही तकनीक से अनाज को लंबे समय तक सुरक्षित रखें' : 'Use right technique to store grain for long time safely', const Color(0xFF1565C0)),
          const SizedBox(height: 14),
          ..._techniques.map((t) => _techniqueCard(t, isHindi)),
        ],
      ),
    );
  }

  Widget _techniqueCard(Map t, bool isHindi) {
    final color = Color(t['color'] as int);
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
              Text(t['icon'] as String, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(isHindi ? t['name'] as String : t['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _row('💰', isHindi ? 'लागत' : 'Cost', isHindi ? t['cost'] as String : t['costEn'] as String),
          _row('📅', isHindi ? 'अवधि' : 'Duration', isHindi ? t['duration'] as String : t['durationEn'] as String),
          _row('🌾', isHindi ? 'उपयुक्त' : 'Suitable for', isHindi ? t['suitable'] as String : t['suitableEn'] as String),
          _row('✅', isHindi ? 'फायदा' : 'Advantage', isHindi ? t['advantage'] as String : t['advantageEn'] as String),
        ],
      ),
    );
  }

  Widget _buildValueAddition(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('💰', isHindi ? 'प्रसंस्करण से कच्ची फसल का मूल्य 3–10 गुना बढ़ाएं' : 'Processing increases raw crop value by 3–10 times', const Color(0xFF2E7D32)),
          const SizedBox(height: 14),
          ..._valueAddition.map((v) => _valueCard(v, isHindi)),
          const SizedBox(height: 8),
          _fpoCard(isHindi),
        ],
      ),
    );
  }

  Widget _valueCard(Map v, bool isHindi) {
    final color = Color(v['color'] as int);
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(v['icon'] as String, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isHindi ? v['crop'] as String : v['cropEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(isHindi ? v['profit'] as String : v['profitEn'] as String,
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(isHindi ? v['products'] as String : v['productsEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fpoCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF43A047)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '🤝 FPO से जुड़ें — मिलकर प्रसंस्करण करें' : '🤝 Join FPO — Process together',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 6),
          Text(
            isHindi
                ? 'Farmer Producer Organization से जुड़कर सामूहिक प्रसंस्करण और बेहतर बाजार भाव पाएं।'
                : 'Join a Farmer Producer Organization for collective processing and better market rates.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70, height: 1.5),
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
          _infoCard('🏛️', isHindi ? 'सरकारी योजनाओं से गोदाम और प्रसंस्करण इकाई लगाएं' : 'Use govt schemes for godown and processing unit', _orange1),
          const SizedBox(height: 14),
          ..._schemes.map((s) => _schemeCard(s, isHindi)),
          const SizedBox(height: 8),
          _lossFactCard(isHindi),
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
          colors: [_orange1.withValues(alpha: 0.09), _orange1.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _orange1.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: _orange1.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? s['name'] as String : s['nameEn'] as String,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _orange1)),
          const SizedBox(height: 4),
          Text(isHindi ? s['benefit'] as String : s['benefitEn'] as String,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _launch(s['url'] as String),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: Text(isHindi ? 'जानकारी लें' : 'Learn More',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: _orange1, side: const BorderSide(color: _orange1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lossFactCard(bool isHindi) {
    final facts = isHindi
        ? ['भारत में हर साल ₹90,000 करोड़ की फसल बर्बाद होती है', 'सही भंडारण से 30–40% नुकसान रोका जा सकता है', 'सब्जियाँ और फल: 25–30% नुकसान कटाई के बाद', 'अनाज: 5–10% नुकसान गलत भंडारण से']
        : ['India wastes crops worth ₹90,000 crore annually', 'Proper storage can prevent 30–40% loss', 'Vegetables & fruits: 25–30% loss after harvest', 'Grains: 5–10% loss from improper storage'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _orange1.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '📊 भंडारण से जुड़े तथ्य' : '📊 Storage Facts',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _orange1)),
          const SizedBox(height: 8),
          ...facts.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📌 ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(f, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87))),
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
