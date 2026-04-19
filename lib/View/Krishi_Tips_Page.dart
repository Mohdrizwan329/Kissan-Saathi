import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

// To update tips without app update:
// 1. Create a GitHub Gist: gist.github.com
// 2. Paste JSON with {"tips": [...]} structure (see _localTips below as template)
// 3. Click "Raw" and copy the URL
// 4. Replace _remoteUrl below with your Gist raw URL
const String _tipsRemoteUrl = '';

class KrishiTipsPage extends StatefulWidget {
  const KrishiTipsPage({super.key});

  @override
  State<KrishiTipsPage> createState() => _KrishiTipsPageState();
}

class _KrishiTipsPageState extends State<KrishiTipsPage> {
  int _selectedCat = 0;

  static const _cats = ['सभी', 'रबी', 'खरीफ', 'जैविक', 'सिंचाई', 'मिट्टी'];
  static const _catColors = [
    Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFFE65100),
    Color(0xFF00695C), Color(0xFF0288D1), Color(0xFF5D4037),
  ];

  static const _localTips = [
    {
      'icon': '🌾', 'cat': 1, 'color': 0xFF1565C0,
      'title': 'गेहूं की बुवाई का सही समय',
      'titleEn': 'Right Time for Wheat Sowing',
      'desc': 'गेहूं की बुवाई नवंबर के पहले सप्ताह से दिसंबर के मध्य तक करें। तापमान 20-22°C सबसे उपयुक्त है।',
      'descEn': 'Sow wheat from early November to mid-December. Temperature of 20-22°C is ideal.',
      'tag': 'रबी', 'tagEn': 'Rabi',
    },
    {
      'icon': '🌽', 'cat': 2, 'color': 0xFFE65100,
      'title': 'मक्का की खेती में सिंचाई',
      'titleEn': 'Irrigation in Maize Farming',
      'desc': 'मक्का को फूल आने और दाना भरने के समय पर्याप्त पानी दें। 7-10 दिन के अंतराल पर सिंचाई करें।',
      'descEn': 'Give sufficient water to maize during flowering and grain filling. Irrigate every 7-10 days.',
      'tag': 'खरीफ', 'tagEn': 'Kharif',
    },
    {
      'icon': '🌿', 'cat': 3, 'color': 0xFF2E7D32,
      'title': 'वर्मीकम्पोस्ट बनाने की विधि',
      'titleEn': 'How to Make Vermicompost',
      'desc': 'केंचुओं की मदद से जैविक कचरे को खाद में बदलें। 45-60 दिनों में उच्च गुणवत्ता की खाद तैयार होती है।',
      'descEn': 'Convert organic waste into compost using earthworms. High quality compost is ready in 45-60 days.',
      'tag': 'जैविक', 'tagEn': 'Organic',
    },
    {
      'icon': '💧', 'cat': 4, 'color': 0xFF0288D1,
      'title': 'ड्रिप सिंचाई से पानी बचाएं',
      'titleEn': 'Save Water with Drip Irrigation',
      'desc': 'ड्रिप सिंचाई से 40-60% पानी की बचत होती है। पौधे की जड़ में सीधे पानी पहुंचता है जिससे उत्पादन बढ़ता है।',
      'descEn': 'Drip irrigation saves 40-60% water. Water directly reaches plant roots, increasing yield.',
      'tag': 'सिंचाई', 'tagEn': 'Irrigation',
    },
    {
      'icon': '🧪', 'cat': 5, 'color': 0xFF5D4037,
      'title': 'मिट्टी जांच कब और कैसे करें',
      'titleEn': 'When and How to Test Soil',
      'desc': 'हर 3 साल में एक बार मिट्टी की जांच कराएं। बुवाई से 2-3 महीने पहले नमूना लें और कृषि विभाग को भेजें।',
      'descEn': 'Get soil tested every 3 years. Take samples 2-3 months before sowing and send to agriculture dept.',
      'tag': 'मिट्टी', 'tagEn': 'Soil',
    },
    {
      'icon': '🌱', 'cat': 1, 'color': 0xFF1565C0,
      'title': 'सरसों में खाद का सही उपयोग',
      'titleEn': 'Proper Fertilizer Use in Mustard',
      'desc': 'सरसों में 80 किग्रा नाइट्रोजन, 40 किग्रा फास्फोरस और 40 किग्रा पोटाश प्रति हेक्टेयर डालें।',
      'descEn': 'Apply 80 kg Nitrogen, 40 kg Phosphorus and 40 kg Potash per hectare in mustard.',
      'tag': 'रबी', 'tagEn': 'Rabi',
    },
    {
      'icon': '🍅', 'cat': 2, 'color': 0xFFE65100,
      'title': 'धान की रोपाई का सही तरीका',
      'titleEn': 'Correct Method of Paddy Transplanting',
      'desc': '25-30 दिन की पौध को 20×15 सेमी की दूरी पर लगाएं। एक जगह 2-3 पौधे लगाना उत्तम है।',
      'descEn': 'Transplant 25-30 day old seedlings at 20×15 cm spacing. Plant 2-3 seedlings per hill.',
      'tag': 'खरीफ', 'tagEn': 'Kharif',
    },
    {
      'icon': '🐛', 'cat': 3, 'color': 0xFF00695C,
      'title': 'नीम से कीट नियंत्रण',
      'titleEn': 'Pest Control Using Neem',
      'desc': 'नीम का तेल (5 मिली/लीटर पानी) छिड़काव से अधिकांश कीटों को नियंत्रित किया जा सकता है।',
      'descEn': 'Spray neem oil (5ml/liter water) to control most pests. It is safe for the environment.',
      'tag': 'जैविक', 'tagEn': 'Organic',
    },
  ];

  List<Map<String, dynamic>> _tips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    if (_tipsRemoteUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(_tipsRemoteUrl)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final list = List<Map<String, dynamic>>.from(data['tips'] ?? []);
          if (list.isNotEmpty && mounted) {
            setState(() { _tips = list; _loading = false; });
            return;
          }
        }
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _tips = List<Map<String, dynamic>>.from(_localTips);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final filtered = _selectedCat == 0
        ? _tips
        : _tips.where((t) => t['cat'] == _selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? 'कृषि टिप्स' : 'Krishi Tips',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () { setState(() => _loading = true); _loadTips(); },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : Column(
              children: [
                SizedBox(
                  height: 52,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    itemCount: _cats.length,
                    itemBuilder: (_, i) {
                      final selected = _selectedCat == i;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCat = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected ? _catColors[i] : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? _catColors[i] : Colors.grey.shade300),
                            boxShadow: selected
                                ? [BoxShadow(color: _catColors[i].withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                                : [],
                          ),
                          child: Text(_cats[i],
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : Colors.grey.shade600)),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text('कोई टिप्स नहीं', style: GoogleFonts.poppins(color: Colors.grey)))
                      : RefreshIndicator(
                          onRefresh: () async { setState(() => _loading = true); await _loadTips(); },
                          color: const Color(0xFF2E7D32),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) => _tipCard(filtered[i], w, isHindi),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _tipCard(Map<String, dynamic> tip, double w, bool isHindi) {
    final color = Color(tip['color'] is int ? tip['color'] as int : int.parse('${tip['color']}'));
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.28)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(child: Text(tip['icon'] as String, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isHindi ? (tip['tag'] as String) : (tip['tagEn'] as String),
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isHindi ? (tip['title'] as String) : (tip['titleEn'] as String),
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isHindi ? (tip['desc'] as String) : (tip['descEn'] as String),
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                    maxLines: 3, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
