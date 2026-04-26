import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PashuPalanPage extends StatefulWidget {
  const PashuPalanPage({super.key});
  @override
  State<PashuPalanPage> createState() => _PashuPalanPageState();
}

class _PashuPalanPageState extends State<PashuPalanPage>
    with SingleTickerProviderStateMixin {
  static const _brown = Color(0xFF4E342E);
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

  static const _cattle = [
    {
      'name': 'गिर गाय', 'nameEn': 'Gir Cow', 'icon': '🐄',
      'color': 0xFFE65100,
      'milk': '10–12 लीटर/दिन', 'milkEn': '10–12 L/day',
      'price': '₹40,000–80,000', 'found': 'गुजरात, राजस्थान',
      'foundEn': 'Gujarat, Rajasthan',
      'feed': 'हरा चारा + भूसा + संतुलित पशु आहार',
      'feedEn': 'Green fodder + straw + balanced cattle feed',
      'special': 'रोग प्रतिरोधक क्षमता अधिक, गर्म जलवायु में उपयुक्त',
      'specialEn': 'High disease resistance, suitable for hot climate',
    },
    {
      'name': 'HF गाय', 'nameEn': 'Holstein Friesian', 'icon': '🐄',
      'color': 0xFF1565C0,
      'milk': '20–25 लीटर/दिन', 'milkEn': '20–25 L/day',
      'price': '₹60,000–1,20,000', 'found': 'पंजाब, हरियाणा, UP',
      'foundEn': 'Punjab, Haryana, UP',
      'feed': 'उच्च पोषण आहार + हरा चारा + खनिज मिश्रण',
      'feedEn': 'High nutrition feed + green fodder + mineral mix',
      'special': 'सर्वाधिक दूध उत्पादन, ठंडे मौसम में अच्छी',
      'specialEn': 'Highest milk production, good in cold weather',
    },
    {
      'name': 'मुर्रा भैंस', 'nameEn': 'Murrah Buffalo', 'icon': '🐃',
      'color': 0xFF4A148C,
      'milk': '15–18 लीटर/दिन', 'milkEn': '15–18 L/day',
      'price': '₹50,000–1,00,000', 'found': 'हरियाणा, पंजाब, UP',
      'foundEn': 'Haryana, Punjab, UP',
      'feed': 'हरा चारा + संघनित आहार + खनिज लवण',
      'feedEn': 'Green fodder + concentrate feed + mineral salts',
      'special': 'दूध में वसा अधिक (7–8%), घी के लिए उत्तम',
      'specialEn': 'High fat milk (7–8%), excellent for ghee',
    },
    {
      'name': 'बकरी (जमुनापारी)', 'nameEn': 'Goat (Jamunapari)', 'icon': '🐐',
      'color': 0xFF2E7D32,
      'milk': '2–3 लीटर/दिन', 'milkEn': '2–3 L/day',
      'price': '₹5,000–15,000', 'found': 'UP, राजस्थान, बिहार',
      'foundEn': 'UP, Rajasthan, Bihar',
      'feed': 'पत्तियाँ, झाड़ियाँ, अनाज + हरा चारा',
      'feedEn': 'Leaves, shrubs, grains + green fodder',
      'special': 'कम लागत, जल्दी लाभ, मांस + दूध दोनों',
      'specialEn': 'Low cost, quick profit, both meat + milk',
    },
    {
      'name': 'देसी मुर्गी', 'nameEn': 'Country Chicken', 'icon': '🐓',
      'color': 0xFFFF6F00,
      'milk': '150–200 अंडे/वर्ष', 'milkEn': '150–200 eggs/year',
      'price': '₹200–500 प्रति मुर्गी', 'found': 'सभी राज्य',
      'foundEn': 'All states',
      'feed': 'अनाज + हरी पत्तियाँ + कीड़े + खनिज',
      'feedEn': 'Grains + green leaves + insects + minerals',
      'special': 'रोग प्रतिरोधक, बाजार में अच्छा भाव, कम लागत',
      'specialEn': 'Disease resistant, good market price, low cost',
    },
  ];

  static const _vaccines = [
    {
      'disease': 'खुरपका-मुँहपका', 'diseaseEn': 'Foot & Mouth Disease',
      'animal': 'गाय, भैंस, बकरी', 'animalEn': 'Cow, Buffalo, Goat',
      'schedule': 'हर 6 महीने', 'scheduleEn': 'Every 6 months',
      'icon': '💉', 'color': 0xFFB71C1C,
    },
    {
      'disease': 'ब्रुसेलोसिस', 'diseaseEn': 'Brucellosis',
      'animal': 'गाय, भैंस', 'animalEn': 'Cow, Buffalo',
      'schedule': 'एक बार (4–8 माह आयु)', 'scheduleEn': 'Once (4–8 months age)',
      'icon': '💉', 'color': 0xFF1565C0,
    },
    {
      'disease': 'थाइलेरिया', 'diseaseEn': 'Theileria',
      'animal': 'गाय, बछड़ा', 'animalEn': 'Cow, Calf',
      'schedule': 'वार्षिक', 'scheduleEn': 'Annual',
      'icon': '💉', 'color': 0xFF2E7D32,
    },
    {
      'disease': 'रानीखेत', 'diseaseEn': 'Ranikhet (Newcastle)',
      'animal': 'मुर्गी, बत्तख', 'animalEn': 'Poultry, Duck',
      'schedule': 'हर 3 महीने', 'scheduleEn': 'Every 3 months',
      'icon': '💉', 'color': 0xFF6A1B9A,
    },
    {
      'disease': 'एन्थ्रेक्स', 'diseaseEn': 'Anthrax',
      'animal': 'सभी पशु', 'animalEn': 'All animals',
      'schedule': 'वार्षिक (जोखिम क्षेत्र)', 'scheduleEn': 'Annual (risk areas)',
      'icon': '💉', 'color': 0xFFE65100,
    },
    {
      'disease': 'PPR (मेमनों का रोग)', 'diseaseEn': 'PPR (Goat plague)',
      'animal': 'बकरी, भेड़', 'animalEn': 'Goat, Sheep',
      'schedule': 'हर 3 वर्ष', 'scheduleEn': 'Every 3 years',
      'icon': '💉', 'color': 0xFF00695C,
    },
  ];

  static const _feedGuide = [
    {
      'animal': 'दुधारू गाय', 'animalEn': 'Dairy Cow',
      'icon': '🐄', 'color': 0xFF1B5E20,
      'dry': '5–7 किलो भूसा / चारा', 'dryEn': '5–7 kg straw / fodder',
      'green': '20–25 किलो हरा चारा', 'greenEn': '20–25 kg green fodder',
      'concentrate': '2–3 किलो पशु आहार', 'concentrateEn': '2–3 kg cattle feed',
      'water': '40–60 लीटर पानी', 'waterEn': '40–60 liters water',
    },
    {
      'animal': 'भैंस', 'animalEn': 'Buffalo',
      'icon': '🐃', 'color': 0xFF4A148C,
      'dry': '6–8 किलो भूसा', 'dryEn': '6–8 kg straw',
      'green': '25–30 किलो हरा चारा', 'greenEn': '25–30 kg green fodder',
      'concentrate': '3–4 किलो पशु आहार', 'concentrateEn': '3–4 kg cattle feed',
      'water': '50–80 लीटर पानी', 'waterEn': '50–80 liters water',
    },
    {
      'animal': 'बकरी', 'animalEn': 'Goat',
      'icon': '🐐', 'color': 0xFF2E7D32,
      'dry': '0.5–1 किलो सूखा चारा', 'dryEn': '0.5–1 kg dry fodder',
      'green': '2–3 किलो हरी पत्तियाँ', 'greenEn': '2–3 kg green leaves',
      'concentrate': '200–300 ग्राम अनाज', 'concentrateEn': '200–300 g grains',
      'water': '3–5 लीटर पानी', 'waterEn': '3–5 liters water',
    },
  ];

  static const _schemes = [
    {
      'name': 'राष्ट्रीय पशुधन मिशन', 'nameEn': 'National Livestock Mission',
      'benefit': 'पशुपालन के लिए सब्सिडी और ऋण', 'benefitEn': 'Subsidy and loan for livestock',
      'icon': '🏛️', 'color': 0xFF1565C0,
    },
    {
      'name': 'PM मत्स्य संपदा योजना', 'nameEn': 'PM Matsya Sampada Yojana',
      'benefit': 'मत्स्य पालन विकास हेतु ₹20,050 करोड़', 'benefitEn': '₹20,050 cr for fishery development',
      'icon': '🐟', 'color': 0xFF0277BD,
    },
    {
      'name': 'किसान क्रेडिट कार्ड (पशु)', 'nameEn': 'Kisan Credit Card (Livestock)',
      'benefit': 'पशुपालन के लिए आसान ऋण', 'benefitEn': 'Easy credit for animal husbandry',
      'icon': '💳', 'color': 0xFF2E7D32,
    },
    {
      'name': 'नंद बाबा दुग्ध मिशन (UP)', 'nameEn': 'Nand Baba Milk Mission (UP)',
      'benefit': 'देसी नस्ल गाय पर ₹10,000–40,000 अनुदान', 'benefitEn': 'Grant ₹10,000–40,000 for desi cows',
      'icon': '🐄', 'color': 0xFFE65100,
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
          isHindi ? 'पशु पालन' : 'Animal Husbandry',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
            Tab(text: isHindi ? 'पशु नस्लें' : 'Breeds'),
            Tab(text: isHindi ? 'टीकाकरण' : 'Vaccination'),
            Tab(text: isHindi ? 'आहार गाइड' : 'Feed Guide'),
            Tab(text: isHindi ? 'योजनाएं' : 'Schemes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildBreeds(isHindi),
          _buildVaccination(isHindi),
          _buildFeedGuide(isHindi),
          _buildSchemes(isHindi),
        ],
      ),
    );
  }

  Widget _buildBreeds(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🐄', isHindi ? 'सही नस्ल चुनकर अधिक आय प्राप्त करें' : 'Choose the right breed for more income', _brown),
          const SizedBox(height: 14),
          ..._cattle.map((c) => _breedCard(c, isHindi)),
        ],
      ),
    );
  }

  Widget _breedCard(Map c, bool isHindi) {
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
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(c['icon'] as String, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? c['name'] as String : c['nameEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                    Text(isHindi ? c['found'] as String : c['foundEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(c['price'] as String, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _row('🥛', isHindi ? 'उत्पादन' : 'Production', isHindi ? c['milk'] as String : c['milkEn'] as String),
          _row('🌿', isHindi ? 'आहार' : 'Feed', isHindi ? c['feed'] as String : c['feedEn'] as String),
          _row('⭐', isHindi ? 'विशेषता' : 'Special', isHindi ? c['special'] as String : c['specialEn'] as String),
        ],
      ),
    );
  }

  Widget _buildVaccination(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('💉', isHindi ? 'समय पर टीका लगाएं, पशु स्वस्थ रखें' : 'Vaccinate on time, keep animals healthy', const Color(0xFFB71C1C)),
          const SizedBox(height: 14),
          ..._vaccines.map((v) => _vaccineCard(v, isHindi)),
          const SizedBox(height: 8),
          _helplineCard(isHindi),
        ],
      ),
    );
  }

  Widget _vaccineCard(Map v, bool isHindi) {
    final color = Color(v['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Text(v['icon'] as String, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? v['disease'] as String : v['diseaseEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 4),
                _row('🐄', isHindi ? 'पशु' : 'Animal', isHindi ? v['animal'] as String : v['animalEn'] as String),
                _row('📅', isHindi ? 'समय' : 'Schedule', isHindi ? v['schedule'] as String : v['scheduleEn'] as String),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _helplineCard(bool isHindi) {
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
                Text(isHindi ? 'पशु चिकित्सा हेल्पलाइन' : 'Veterinary Helpline',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1565C0))),
                Text('1962', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF1565C0))),
                Text(isHindi ? 'पशु आपातकाल में तुरंत कॉल करें' : 'Call immediately in animal emergency',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded, color: Color(0xFF1565C0), size: 28),
            onPressed: () => _launch('tel:1962'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedGuide(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🌿', isHindi ? 'संतुलित आहार से अधिक दूध और स्वस्थ पशु' : 'Balanced diet for more milk and healthy animals', const Color(0xFF2E7D32)),
          const SizedBox(height: 14),
          ..._feedGuide.map((f) => _feedCard(f, isHindi)),
          const SizedBox(height: 8),
          _fodderTipsCard(isHindi),
        ],
      ),
    );
  }

  Widget _feedCard(Map f, bool isHindi) {
    final color = Color(f['color'] as int);
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
              Text(f['icon'] as String, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(isHindi ? f['animal'] as String : f['animalEn'] as String,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 10),
          _row('🌾', isHindi ? 'सूखा चारा' : 'Dry Fodder', isHindi ? f['dry'] as String : f['dryEn'] as String),
          _row('🌿', isHindi ? 'हरा चारा' : 'Green Fodder', isHindi ? f['green'] as String : f['greenEn'] as String),
          _row('🥣', isHindi ? 'संघनित आहार' : 'Concentrate', isHindi ? f['concentrate'] as String : f['concentrateEn'] as String),
          _row('💧', isHindi ? 'पानी' : 'Water', isHindi ? f['water'] as String : f['waterEn'] as String),
        ],
      ),
    );
  }

  Widget _fodderTipsCard(bool isHindi) {
    final tips = isHindi
        ? ['नेपियर घास — 3 महीने में कटाई, साल में 5–6 बार', 'मक्का साइलेज — पूरे साल हरे चारे का विकल्प', 'बरसीम + जई — रबी मौसम का सर्वोत्तम चारा', 'अजोला — प्रोटीन युक्त, दूध बढ़ाता है']
        : ['Napier grass — cuts in 3 months, 5–6 times/year', 'Maize silage — green fodder alternative year-round', 'Berseem + oat — best fodder in rabi season', 'Azolla — protein-rich, increases milk production'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF388E3C).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '🌾 हरे चारे की फसलें' : '🌾 Green Fodder Crops',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1B5E20))),
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✅ ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(t, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSchemes(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🏛️', isHindi ? 'सरकारी योजनाओं का लाभ उठाएं' : 'Avail government schemes', const Color(0xFF1565C0)),
          const SizedBox(height: 14),
          ..._schemes.map((s) => _schemeCard(s, isHindi)),
          const SizedBox(height: 8),
          _nabardCard(isHindi),
        ],
      ),
    );
  }

  Widget _schemeCard(Map s, bool isHindi) {
    final color = Color(s['color'] as int);
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
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(s['icon'] as String, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? s['name'] as String : s['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 4),
                Text(isHindi ? s['benefit'] as String : s['benefitEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nabardCard(bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF43A047)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '📞 NABARD पशुपालन हेल्पलाइन' : '📞 NABARD Animal Husbandry Helpline',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 6),
          Text('1800-200-0104',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(isHindi ? 'ऋण और सब्सिडी की जानकारी के लिए' : 'For loan and subsidy information',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _launch('tel:18002000104'),
            icon: const Icon(Icons.call, size: 16, color: Colors.white),
            label: Text(isHindi ? 'अभी कॉल करें' : 'Call Now',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
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
