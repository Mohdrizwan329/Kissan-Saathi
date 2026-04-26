import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MittiHealthPage extends StatefulWidget {
  const MittiHealthPage({super.key});
  @override
  State<MittiHealthPage> createState() => _MittiHealthPageState();
}

class _MittiHealthPageState extends State<MittiHealthPage> with SingleTickerProviderStateMixin {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  late TabController _tab;
  final _phCtrl = TextEditingController();
  String? _phResult;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _phCtrl.dispose();
    super.dispose();
  }

  static const _soilTypes = [
    {
      'name': 'काली मिट्टी', 'nameEn': 'Black Soil',
      'icon': '⬛', 'color': 0xFF212121,
      'found': 'महाराष्ट्र, मध्य प्रदेश, गुजरात', 'foundEn': 'Maharashtra, MP, Gujarat',
      'crops': 'कपास, गन्ना, सोयाबीन, ज्वार', 'cropsEn': 'Cotton, Sugarcane, Soybean, Sorghum',
      'ph': '7.5–8.5', 'features': 'नमी धारण क्षमता अधिक, कैल्शियम युक्त',
      'featuresEn': 'High moisture retention, calcium-rich',
    },
    {
      'name': 'लाल मिट्टी', 'nameEn': 'Red Soil',
      'icon': '🟥', 'color': 0xFFB71C1C,
      'found': 'तमिलनाडु, कर्नाटक, आंध्र, ओडिशा', 'foundEn': 'Tamil Nadu, Karnataka, AP, Odisha',
      'crops': 'मूंगफली, दालें, बाजरा, तंबाकू', 'cropsEn': 'Groundnut, Pulses, Millet, Tobacco',
      'ph': '6.0–7.5', 'features': 'लोहा और एल्युमिना से भरपूर, उर्वरक की जरूरत',
      'featuresEn': 'Rich in iron & alumina, needs fertilizers',
    },
    {
      'name': 'जलोढ़ मिट्टी', 'nameEn': 'Alluvial Soil',
      'icon': '🟨', 'color': 0xFFF57F17,
      'found': 'उत्तर प्रदेश, पंजाब, हरियाणा, बिहार', 'foundEn': 'UP, Punjab, Haryana, Bihar',
      'crops': 'गेहूं, धान, गन्ना, सब्जियाँ', 'cropsEn': 'Wheat, Rice, Sugarcane, Vegetables',
      'ph': '6.5–8.0', 'features': 'सबसे उपजाऊ, नदियों द्वारा जमा, खनिज युक्त',
      'featuresEn': 'Most fertile, river-deposited, mineral-rich',
    },
    {
      'name': 'बलुई मिट्टी', 'nameEn': 'Sandy Soil',
      'icon': '🟤', 'color': 0xFFE65100,
      'found': 'राजस्थान, पंजाब (रेत क्षेत्र)', 'foundEn': 'Rajasthan, Punjab (sandy areas)',
      'crops': 'बाजरा, मूंगफली, तरबूज', 'cropsEn': 'Pearl millet, Groundnut, Watermelon',
      'ph': '6.0–7.5', 'features': 'जल्दी सूखती है, कम उर्वर, ड्रिप सिंचाई उपयुक्त',
      'featuresEn': 'Drains fast, less fertile, drip irrigation suitable',
    },
    {
      'name': 'दोमट मिट्टी', 'nameEn': 'Loamy Soil',
      'icon': '🟫', 'color': 0xFF5D4037,
      'found': 'सभी राज्यों में', 'foundEn': 'All states',
      'crops': 'लगभग सभी फसलें', 'cropsEn': 'Almost all crops',
      'ph': '6.0–7.0', 'features': 'आदर्श मिट्टी — बालू, गाद और मिट्टी का उचित मिश्रण',
      'featuresEn': 'Ideal soil — proper mix of sand, silt and clay',
    },
  ];

  static const _nutrients = [
    {'name': 'नाइट्रोजन (N)', 'nameEn': 'Nitrogen (N)', 'icon': '🌿', 'color': 0xFF2E7D32,
      'deficiency': 'पत्तियाँ पीली, पौधा कमजोर', 'deficiencyEn': 'Yellow leaves, weak plants',
      'source': 'यूरिया, अमोनियम सल्फेट', 'sourceEn': 'Urea, Ammonium Sulphate'},
    {'name': 'फास्फोरस (P)', 'nameEn': 'Phosphorus (P)', 'icon': '🌱', 'color': 0xFF01579B,
      'deficiency': 'जड़ें कमजोर, बैंगनी रंग', 'deficiencyEn': 'Weak roots, purple discoloration',
      'source': 'DAP, SSP, रॉक फॉस्फेट', 'sourceEn': 'DAP, SSP, Rock Phosphate'},
    {'name': 'पोटेशियम (K)', 'nameEn': 'Potassium (K)', 'icon': '💪', 'color': 0xFFE65100,
      'deficiency': 'पत्तियों के किनारे जलते हैं', 'deficiencyEn': 'Leaf edges burn',
      'source': 'MOP, SOP, राख', 'sourceEn': 'MOP, SOP, Wood ash'},
    {'name': 'जिंक (Zn)', 'nameEn': 'Zinc (Zn)', 'icon': '⚡', 'color': 0xFF6A1B9A,
      'deficiency': 'नई पत्तियाँ सफेद/पीली', 'deficiencyEn': 'New leaves white/yellow',
      'source': 'ZnSO₄ (जिंक सल्फेट)', 'sourceEn': 'ZnSO₄ (Zinc Sulphate)'},
    {'name': 'सल्फर (S)', 'nameEn': 'Sulphur (S)', 'icon': '🟡', 'color': 0xFFFF8F00,
      'deficiency': 'नई पत्तियाँ पीली', 'deficiencyEn': 'New leaves turn yellow',
      'source': 'जिप्सम, अमोनियम सल्फेट', 'sourceEn': 'Gypsum, Ammonium Sulphate'},
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
        title: Text(isHindi ? 'मिट्टी स्वास्थ्य' : 'Soil Health',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF388E3C)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: isHindi ? 'मिट्टी प्रकार' : 'Soil Types'),
            Tab(text: isHindi ? 'पोषक तत्व' : 'Nutrients'),
            Tab(text: isHindi ? 'pH जांच' : 'pH Check'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildSoilTypes(isHindi),
          _buildNutrients(isHindi),
          _buildPhChecker(isHindi),
        ],
      ),
    );
  }

  Widget _buildSoilTypes(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🌍', isHindi ? 'अपनी मिट्टी पहचानें और सही फसल उगाएं' : 'Identify your soil and grow the right crops', const Color(0xFF4E342E)),
          const SizedBox(height: 14),
          ..._soilTypes.map((s) => _buildSoilCard(s, isHindi)),
        ],
      ),
    );
  }

  Widget _buildSoilCard(Map s, bool isHindi) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 44, height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(s['icon'] as String, style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? s['name'] as String : s['nameEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                    Text('pH: ${s['ph']}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _soilRow('📍', isHindi ? 'कहाँ पाई जाती है' : 'Found in', isHindi ? s['found'] as String : s['foundEn'] as String),
          _soilRow('🌾', isHindi ? 'उपयुक्त फसलें' : 'Suitable Crops', isHindi ? s['crops'] as String : s['cropsEn'] as String),
          _soilRow('✨', isHindi ? 'विशेषताएं' : 'Features', isHindi ? s['features'] as String : s['featuresEn'] as String),
        ],
      ),
    );
  }

  Widget _soilRow(String icon, String label, String value) {
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

  Widget _buildNutrients(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🌿', isHindi ? 'मिट्टी में पोषक तत्वों की कमी पहचानें और सुधारें' : 'Identify and fix nutrient deficiencies in soil', _green2),
          const SizedBox(height: 14),
          ..._nutrients.map((n) => _buildNutrientCard(n, isHindi)),
          const SizedBox(height: 8),
          _buildTestingGuide(isHindi),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(Map n, bool isHindi) {
    final color = Color(n['color'] as int);
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
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Center(child: Text(n['icon'] as String, style: const TextStyle(fontSize: 22)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? n['name'] as String : n['nameEn'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 6),
                _nutrientRow('⚠️', isHindi ? 'कमी के लक्षण' : 'Deficiency Signs', isHindi ? n['deficiency'] as String : n['deficiencyEn'] as String),
                _nutrientRow('💊', isHindi ? 'स्रोत/उपचार' : 'Source/Treatment', isHindi ? n['source'] as String : n['sourceEn'] as String),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutrientRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text('$label: ', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildTestingGuide(bool isHindi) {
    final steps = isHindi
        ? ['खेत के 8–10 जगहों से मिट्टी लें', 'छाया में सुखाएं और मिलाएं', 'पास के KVK या मिट्टी परीक्षण केंद्र पर भेजें', 'रिपोर्ट के अनुसार खाद प्रयोग करें']
        : ['Collect soil from 8–10 spots in field', 'Dry in shade and mix together', 'Send to nearest KVK or soil testing center', 'Apply fertilizers as per report'];
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
          Text(isHindi ? '🧪 मिट्टी परीक्षण कैसे करें?' : '🧪 How to do Soil Testing?',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
          const SizedBox(height: 8),
          ...steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 22, height: 22, decoration: BoxDecoration(color: _green2, shape: BoxShape.circle),
                  child: Center(child: Text('${e.key + 1}', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)))),
                const SizedBox(width: 8),
                Expanded(child: Text(e.value, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87))),
              ],
            ),
          )),
          const SizedBox(height: 10),
          Text(isHindi ? '📞 मिट्टी परीक्षण हेल्पलाइन: 1800-180-1551' : '📞 Soil Testing Helpline: 1800-180-1551',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _green1)),
        ],
      ),
    );
  }

  Widget _buildPhChecker(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🧪', isHindi ? 'pH मान से मिट्टी की अम्लता/क्षारीयता पता करें' : 'Find soil acidity/alkalinity from pH value', const Color(0xFF01579B)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [const Color(0xFF01579B).withValues(alpha: 0.08), const Color(0xFF01579B).withValues(alpha: 0.02)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF01579B).withValues(alpha: 0.20)),
              boxShadow: [BoxShadow(color: const Color(0xFF01579B).withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'pH मान दर्ज करें (0–14)' : 'Enter pH value (0–14)',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                TextField(
                  controller: _phCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: isHindi ? 'जैसे: 6.5' : 'e.g.: 6.5',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    filled: true, fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _green2, width: 2)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final ph = double.tryParse(_phCtrl.text);
                      if (ph != null && ph >= 0 && ph <= 14) setState(() => _phResult = _analyzePh(ph, isHindi));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: _green2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Text(isHindi ? 'जांचें' : 'Check', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                if (_phResult != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _green2.withValues(alpha: 0.3))),
                    child: Text(_phResult!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, height: 1.6)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildPhScale(isHindi),
        ],
      ),
    );
  }

  String _analyzePh(double ph, bool isHindi) {
    if (ph < 4.5) return isHindi ? '❌ अत्यधिक अम्लीय\nचूना (Lime) डालें। अधिकांश फसलें नहीं उग सकतीं।' : '❌ Extremely Acidic\nAdd Lime. Most crops cannot grow.';
    if (ph < 5.5) return isHindi ? '⚠️ अम्लीय मिट्टी\nचूना डालें। आलू, चाय उग सकते हैं। pH सुधारें।' : '⚠️ Acidic Soil\nAdd Lime. Potato, tea can grow. Improve pH.';
    if (ph < 6.0) return isHindi ? '🔶 हल्की अम्लीय\nज्यादातर सब्जियाँ और कुछ फसलें उग सकती हैं।' : '🔶 Slightly Acidic\nMost vegetables and some crops can grow.';
    if (ph <= 7.0) return isHindi ? '✅ आदर्श pH (6.0–7.0)\nसभी फसलों के लिए उत्तम। कोई सुधार जरूरी नहीं।' : '✅ Ideal pH (6.0–7.0)\nBest for all crops. No correction needed.';
    if (ph <= 7.5) return isHindi ? '✅ तटस्थ से हल्की क्षारीय\nगेहूं, कपास, ज्वार के लिए उपयुक्त।' : '✅ Neutral to Slightly Alkaline\nSuitable for wheat, cotton, sorghum.';
    if (ph <= 8.5) return isHindi ? '⚠️ क्षारीय मिट्टी\nजिप्सम डालें। चावल और कपास उग सकते हैं।' : '⚠️ Alkaline Soil\nAdd Gypsum. Rice and cotton can grow.';
    return isHindi ? '❌ अत्यधिक क्षारीय\nजिप्सम और सल्फर डालें। खेती कठिन है।' : '❌ Highly Alkaline\nAdd Gypsum and Sulphur. Farming is difficult.';
  }

  Widget _buildPhScale(bool isHindi) {
    final ranges = [
      {'range': '0–4', 'label': isHindi ? 'अत्यधिक अम्ल' : 'Very Acid', 'color': 0xFFB71C1C},
      {'range': '4–6', 'label': isHindi ? 'अम्लीय' : 'Acidic', 'color': 0xFFFF8F00},
      {'range': '6–7', 'label': isHindi ? 'आदर्श' : 'Ideal', 'color': 0xFF2E7D32},
      {'range': '7–8', 'label': isHindi ? 'तटस्थ' : 'Neutral', 'color': 0xFF1565C0},
      {'range': '8–14', 'label': isHindi ? 'क्षारीय' : 'Alkaline', 'color': 0xFF6A1B9A},
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [_green1.withValues(alpha: 0.07), _green1.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.20)),
        boxShadow: [BoxShadow(color: _green1.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? 'pH स्केल गाइड' : 'pH Scale Guide',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(children: ranges.map((r) => Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(color: Color(r['color'] as int), borderRadius: BorderRadius.circular(6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(r['range'] as String, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text(r['label'] as String, style: GoogleFonts.poppins(fontSize: 8, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          )).toList()),
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
}
