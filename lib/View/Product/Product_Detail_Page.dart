import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static const _videoUrl = 'https://www.youtube.com/watch?v=-lmopDUnraE';

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  List<Map<String, Object>> _buildSections(bool isHindi) => [
    {
      'icon': Icons.info_outline_rounded,
      'title': isHindi ? 'फसल के बारे में' : 'About the Crop',
      'color': 0xFF1565C0,
      'content': isHindi
          ? 'चावल (धान) भारत में उगाई जाने वाली सबसे महत्वपूर्ण मुख्य खाद्य फसलों में से एक है। यह उष्णकटिबंधीय जलवायु में पनपती है और मुख्यतः खरीफ मौसम में उगाई जाती है।'
          : 'Rice (Paddy) is one of the most important staple food crops grown in India. It thrives in tropical climates and is primarily cultivated in the Kharif season.',
    },
    {
      'icon': Icons.landscape_rounded,
      'title': isHindi ? 'खेत की तैयारी' : 'Field Preparation',
      'color': 0xFF5D4037,
      'content': isHindi
          ? 'खेत को मिट्टी को बारीक और समतल बनाने के लिए 2-3 बार जोतें। मिट्टी को समृद्ध करने के लिए कम्पोस्ट या खेत की खाद डालें।'
          : 'Plough the field 2–3 times to make the soil fine and level. Add compost or farmyard manure to enrich the soil.',
    },
    {
      'icon': Icons.agriculture_rounded,
      'title': isHindi ? 'बुवाई का समय' : 'Sowing Time',
      'color': 0xFF2E7D32,
      'content': isHindi
          ? 'बुवाई जून के अंतिम सप्ताह से जुलाई के पहले सप्ताह तक होती है। उपचारित और प्रमाणित बीजों का उपयोग करें।'
          : 'Sowing takes place from the last week of June to the first week of July. Use treated and certified seeds.',
    },
    {
      'icon': Icons.content_cut_rounded,
      'title': isHindi ? 'कटाई का समय' : 'Harvesting Time',
      'color': 0xFFF9A825,
      'content': isHindi
          ? 'कटाई सामान्यतः अक्टूबर या नवंबर में होती है जब फसल सुनहरी पीली हो जाती है और दाने पक जाते हैं।'
          : 'Harvesting is generally done in October or November when the crop turns golden yellow and the grains are ripe.',
    },
    {
      'icon': Icons.eco_rounded,
      'title': isHindi ? 'अनुशंसित खाद' : 'Recommended Fertilizers',
      'color': 0xFF00695C,
      'content': isHindi
          ? '• नाइट्रोजन: 100 किग्रा/हेक्टेयर\n• फास्फोरस: 60 किग्रा/हेक्टेयर\n• पोटाश: 40 किग्रा/हेक्टेयर\n• जैविक खाद: वर्मीकम्पोस्ट, गोबर खाद, हरी खाद'
          : '• Nitrogen: 100 kg/hectare\n• Phosphorus: 60 kg/hectare\n• Potash: 40 kg/hectare\n• Organic: Vermicompost, FYM, Green manure',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final sections = _buildSections(isHindi);

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _green1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? 'फसल विवरण' : 'Crop Details',
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_green1, _green2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(right: -30, top: -30,
                      child: Container(width: 150, height: 150,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle))),
                  Positioned(left: -20, bottom: 20,
                      child: Container(width: 100, height: 100,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle))),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.25, height: w * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 2),
                          ),
                          child: const Center(child: Text('🌾', style: TextStyle(fontSize: 48))),
                        ),
                        const SizedBox(height: 8),
                        Text('Rice · चावल (धान)',
                            style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _chip(Icons.wb_sunny_rounded, isHindi ? 'खरीफ' : 'Kharif', const Color(0xFFFF8F00)),
                      const SizedBox(width: 10),
                      _chip(Icons.water_drop_rounded, isHindi ? 'सिंचित' : 'Irrigated', const Color(0xFF0288D1)),
                      const SizedBox(width: 10),
                      _chip(Icons.bar_chart_rounded, isHindi ? 'अधिक उत्पादन' : 'High Yield', const Color(0xFF2E7D32)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(_videoUrl), mode: LaunchMode.externalApplication),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(color: const Color(0xFF1A1A2E),
                                child: const Center(child: Text('🎬', style: TextStyle(fontSize: 52)))),
                          ),
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 16)],
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                          ),
                          Positioned(
                            bottom: 14, left: 16, right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isHindi ? '▶ धान की खेती की जानकारी' : '▶ Rice Farming Guide',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ...sections.map((s) => _infoCard(s, w)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(Map<String, Object> s, double w) {
    final color = Color(s['color'] as int);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: w * 0.1, height: w * 0.1,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(s['icon'] as IconData, color: color, size: w * 0.055),
          ),
          title: Text(s['title'] as String,
              style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w600, color: Colors.black87)),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.03),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withValues(alpha: 0.2)),
                    ),
                    child: Text(s['content'] as String,
                        style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.black87, height: 1.6)),
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
