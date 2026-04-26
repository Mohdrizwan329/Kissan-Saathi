import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FasalCalendarPage extends StatefulWidget {
  const FasalCalendarPage({super.key});
  @override
  State<FasalCalendarPage> createState() => _FasalCalendarPageState();
}

class _FasalCalendarPageState extends State<FasalCalendarPage> {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  int _selectedMonth = DateTime.now().month - 1;

  static const _months = [
    'जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
    'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर',
  ];
  static const _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _calendarData = [
    // January
    {
      'season': 'रबी', 'seasonEn': 'Rabi',
      'sow': ['मक्का (देर)', 'सब्जियाँ'], 'sowEn': ['Maize (late)', 'Vegetables'],
      'harvest': ['चना', 'मटर', 'सरसों (शुरू)'], 'harvestEn': ['Chickpea', 'Peas', 'Mustard (start)'],
      'work': ['गेहूं में सिंचाई', 'कीट नियंत्रण', 'पाले से बचाव'], 'workEn': ['Wheat irrigation', 'Pest control', 'Frost protection'],
      'color': 0xFF01579B,
    },
    // February
    {
      'season': 'रबी', 'seasonEn': 'Rabi',
      'sow': ['ग्रीष्मकालीन सब्जियाँ', 'तरबूज'], 'sowEn': ['Summer vegetables', 'Watermelon'],
      'harvest': ['सरसों', 'मटर', 'आलू'], 'harvestEn': ['Mustard', 'Peas', 'Potato'],
      'work': ['गेहूं में दाना भरना', 'खाद का प्रयोग', 'सिंचाई'], 'workEn': ['Wheat grain filling', 'Fertilizer application', 'Irrigation'],
      'color': 0xFF0277BD,
    },
    // March
    {
      'season': 'जायद', 'seasonEn': 'Zaid',
      'sow': ['मूंग', 'उड़द', 'तिल', 'ककड़ी'], 'sowEn': ['Moong', 'Urad', 'Sesame', 'Cucumber'],
      'harvest': ['गेहूं', 'चना', 'जौ', 'सरसों'], 'harvestEn': ['Wheat', 'Chickpea', 'Barley', 'Mustard'],
      'work': ['थ्रेशिंग', 'भंडारण', 'खेत की तैयारी'], 'workEn': ['Threshing', 'Storage', 'Field preparation'],
      'color': 0xFF2E7D32,
    },
    // April
    {
      'season': 'जायद', 'seasonEn': 'Zaid',
      'sow': ['मूंगफली', 'सूरजमुखी', 'सब्जियाँ'], 'sowEn': ['Groundnut', 'Sunflower', 'Vegetables'],
      'harvest': ['गेहूं (पूरा)', 'जौ', 'मसूर'], 'harvestEn': ['Wheat (full)', 'Barley', 'Lentil'],
      'work': ['खेत खाली करना', 'गहरी जुताई', 'मिट्टी परीक्षण'], 'workEn': ['Clear fields', 'Deep ploughing', 'Soil testing'],
      'color': 0xFF558B2F,
    },
    // May
    {
      'season': 'जायद', 'seasonEn': 'Zaid',
      'sow': ['तिल', 'मूंग', 'लौकी', 'भिंडी'], 'sowEn': ['Sesame', 'Moong', 'Bottle gourd', 'Okra'],
      'harvest': ['मूंगफली (शुरू)', 'सब्जियाँ'], 'harvestEn': ['Groundnut (start)', 'Vegetables'],
      'work': ['सिंचाई व्यवस्था', 'खाद डालना', 'खेत तैयारी'], 'workEn': ['Irrigation setup', 'Manure application', 'Field prep'],
      'color': 0xFF33691E,
    },
    // June
    {
      'season': 'खरीफ', 'seasonEn': 'Kharif',
      'sow': ['धान', 'मक्का', 'सोयाबीन', 'मूंगफली', 'ज्वार'], 'sowEn': ['Rice', 'Maize', 'Soybean', 'Groundnut', 'Sorghum'],
      'harvest': ['तिल', 'मूंग', 'सब्जियाँ'], 'harvestEn': ['Sesame', 'Moong', 'Vegetables'],
      'work': ['नर्सरी तैयार करें', 'बीज उपचार', 'खाद डालना'], 'workEn': ['Prepare nursery', 'Seed treatment', 'Manure application'],
      'color': 0xFFE65100,
    },
    // July
    {
      'season': 'खरीफ', 'seasonEn': 'Kharif',
      'sow': ['धान रोपाई', 'अरहर', 'मूंग', 'उड़द', 'कपास'], 'sowEn': ['Rice transplanting', 'Pigeon pea', 'Moong', 'Urad', 'Cotton'],
      'harvest': ['मूंगफली (शुरू)', 'भिंडी', 'सब्जियाँ'], 'harvestEn': ['Groundnut (start)', 'Okra', 'Vegetables'],
      'work': ['जल निकासी', 'निराई-गुड़ाई', 'कीट नियंत्रण'], 'workEn': ['Drainage', 'Weeding', 'Pest control'],
      'color': 0xFFBF360C,
    },
    // August
    {
      'season': 'खरीफ', 'seasonEn': 'Kharif',
      'sow': ['हरी खाद (ढेंचा)', 'सब्जियाँ'], 'sowEn': ['Green manure (Dhaincha)', 'Vegetables'],
      'harvest': ['मूंग', 'उड़द', 'मक्का (शुरू)'], 'harvestEn': ['Moong', 'Urad', 'Maize (start)'],
      'work': ['धान में खाद', 'कपास की देखभाल', 'रोग नियंत्रण'], 'workEn': ['Rice fertilization', 'Cotton care', 'Disease control'],
      'color': 0xFF00695C,
    },
    // September
    {
      'season': 'खरीफ', 'seasonEn': 'Kharif',
      'sow': ['रबी की तैयारी', 'आलू (शुरू)'], 'sowEn': ['Rabi preparation', 'Potato (start)'],
      'harvest': ['मक्का', 'सोयाबीन (शुरू)', 'मूंगफली'], 'harvestEn': ['Maize', 'Soybean (start)', 'Groundnut'],
      'work': ['धान की देखभाल', 'अरहर की सिंचाई', 'मिट्टी परीक्षण'], 'workEn': ['Rice care', 'Pigeon pea irrigation', 'Soil testing'],
      'color': 0xFF1A237E,
    },
    // October
    {
      'season': 'रबी (शुरू)', 'seasonEn': 'Rabi (Start)',
      'sow': ['आलू', 'प्याज', 'लहसुन', 'सरसों'], 'sowEn': ['Potato', 'Onion', 'Garlic', 'Mustard'],
      'harvest': ['धान', 'सोयाबीन', 'मक्का', 'कपास'], 'harvestEn': ['Rice', 'Soybean', 'Maize', 'Cotton'],
      'work': ['खेत की जुताई', 'गोबर खाद डालना', 'बीज खरीद'], 'workEn': ['Field tillage', 'Cow dung manure', 'Buy seeds'],
      'color': 0xFF4A148C,
    },
    // November
    {
      'season': 'रबी', 'seasonEn': 'Rabi',
      'sow': ['गेहूं', 'चना', 'मटर', 'अलसी', 'जौ'], 'sowEn': ['Wheat', 'Chickpea', 'Peas', 'Linseed', 'Barley'],
      'harvest': ['धान (देर)', 'अरहर (शुरू)', 'सब्जियाँ'], 'harvestEn': ['Rice (late)', 'Pigeon pea (start)', 'Vegetables'],
      'work': ['बुवाई का सही समय', 'DAP/यूरिया', 'सिंचाई'], 'workEn': ['Right sowing time', 'DAP/Urea', 'Irrigation'],
      'color': 0xFF37474F,
    },
    // December
    {
      'season': 'रबी', 'seasonEn': 'Rabi',
      'sow': ['देर से गेहूं', 'सब्जियाँ'], 'sowEn': ['Late wheat', 'Vegetables'],
      'harvest': ['अरहर', 'आलू (शुरू)', 'प्याज (शुरू)'], 'harvestEn': ['Pigeon pea', 'Potato (start)', 'Onion (start)'],
      'work': ['पाले से बचाव', 'गेहूं सिंचाई', 'कीट निगरानी'], 'workEn': ['Frost protection', 'Wheat irrigation', 'Pest monitoring'],
      'color': 0xFF263238,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final data = _calendarData[_selectedMonth];
    final color = Color(data['color'] as int);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _green1,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isHindi ? 'फसल कैलेंडर' : 'Crop Calendar',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildMonthSelector(isHindi),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSeasonBadge(data, color, isHindi),
                  const SizedBox(height: 14),
                  _buildSection('🌱', isHindi ? 'बुवाई करें' : 'Sow Now', data['sow'] as List, data['sowEn'] as List, const Color(0xFF2E7D32), isHindi),
                  const SizedBox(height: 12),
                  _buildSection('🌾', isHindi ? 'कटाई करें' : 'Harvest Now', data['harvest'] as List, data['harvestEn'] as List, const Color(0xFFE65100), isHindi),
                  const SizedBox(height: 12),
                  _buildSection('🔧', isHindi ? 'खेत का काम' : 'Farm Work', data['work'] as List, data['workEn'] as List, const Color(0xFF0277BD), isHindi),
                  const SizedBox(height: 16),
                  _buildSeasonGuide(isHindi),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(bool isHindi) {
    return Container(
      height: 56,
      color: _cream,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: 12,
        itemBuilder: (ctx, i) {
          final selected = i == _selectedMonth;
          return GestureDetector(
            onTap: () => setState(() => _selectedMonth = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                border: selected ? Border.all(color: Colors.white, width: 2) : null,
                boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Center(
                child: Text(
                  isHindi ? _months[i] : _monthsEn[i],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeasonBadge(Map data, Color color, bool isHindi) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Text('📅', style: TextStyle(fontSize: 42)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isHindi ? _months[_selectedMonth] : _monthsEn[_selectedMonth],
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  isHindi ? (data['season'] as String) : (data['seasonEn'] as String),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String icon, String title, List items, List itemsEn, Color color, bool isHindi) {
    final list = isHindi ? items : itemsEn;
    return Container(
      padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: list.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(item.toString(), style: GoogleFonts.poppins(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonGuide(bool isHindi) {
    final seasons = [
      {'icon': '🌾', 'name': isHindi ? 'रबी (अक्टूबर–मार्च)' : 'Rabi (Oct–Mar)', 'crops': isHindi ? 'गेहूं, चना, सरसों, जौ, मटर' : 'Wheat, Chickpea, Mustard, Barley, Peas', 'color': 0xFF01579B},
      {'icon': '🌽', 'name': isHindi ? 'खरीफ (जून–सितंबर)' : 'Kharif (Jun–Sep)', 'crops': isHindi ? 'धान, मक्का, सोयाबीन, कपास, अरहर' : 'Rice, Maize, Soybean, Cotton, Pigeon pea', 'color': 0xFFE65100},
      {'icon': '🥒', 'name': isHindi ? 'जायद (मार्च–जून)' : 'Zaid (Mar–Jun)', 'crops': isHindi ? 'तरबूज, खरबूज, खीरा, मूंग' : 'Watermelon, Muskmelon, Cucumber, Moong', 'color': 0xFF2E7D32},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? 'मौसम गाइड' : 'Season Guide', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: _green1)),
          const SizedBox(height: 10),
          ...seasons.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['icon'] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['name'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Color(s['color'] as int))),
                      Text(s['crops'] as String, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
