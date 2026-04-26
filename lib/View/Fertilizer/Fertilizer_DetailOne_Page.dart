import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FertilizerDetailPage extends StatelessWidget {
  const FertilizerDetailPage({super.key});

  static const _videoUrl = 'https://www.youtube.com/watch?v=R_1d0hI-NBw';

  static const _brown1 = Color(0xFF4E342E);
  static const _brown2 = Color(0xFF8D6E63);
  static const _cream = Color(0xFFE8F5E9);

  List<Map<String, Object>> _buildSections(bool isHindi) => [
    {
      'icon': Icons.info_outline_rounded,
      'title': isHindi ? 'खाद के बारे में' : 'About Fertilizer',
      'color': 0xFF1565C0,
      'content': isHindi
          ? 'यूरिया एक नाइट्रोजन युक्त खाद है जिसका उपयोग पत्तेदार फसलों में तेज़ वृद्धि के लिए किया जाता है। यह प्रकाश संश्लेषण को बढ़ाती है और मज़बूत तने के विकास में मदद करती है।'
          : 'Urea is a nitrogen-rich fertilizer used for rapid growth in leafy crops. It enhances photosynthesis and helps in developing strong stems.',
    },
    {
      'icon': Icons.landscape_rounded,
      'title': isHindi ? 'खेत की तैयारी' : 'Field Preparation',
      'color': 0xFF5D4037,
      'content': isHindi
          ? 'खाद डालने से पहले खेत को 2-3 बार जोतें। सुनिश्चित करें कि मिट्टी नम और अच्छी तरह से सूखी हो। उर्वरता बढ़ाने के लिए जैविक खाद या कम्पोस्ट मिलाएं।'
          : 'Plough the field 2-3 times before applying fertilizer. Ensure the soil is moist and well-drained. Mix organic manure or compost to improve fertility.',
    },
    {
      'icon': Icons.handyman_rounded,
      'title': isHindi ? 'कैसे इस्तेमाल करें' : 'How to Apply',
      'color': 0xFF2E7D32,
      'content': isHindi
          ? 'खाद को पानी में घोलकर (अगर पानी में घुलनशील हो) या पौधे की जड़ के चारों ओर समान रूप से डालें। पत्तियों के सीधे संपर्क से बचें।'
          : 'Dissolve the fertilizer in water (if water-soluble) or spread it evenly around the plant roots. Avoid direct contact with leaves.',
    },
    {
      'icon': Icons.access_time_rounded,
      'title': isHindi ? 'कब डालें' : 'When to Apply',
      'color': 0xFFFF8F00,
      'content': isHindi
          ? 'प्रारंभिक विकास चरणों में, विशेष रूप से फूल आने से पहले और सिंचाई के बाद अधिकतम पोषक तत्व अवशोषण के लिए डालें।'
          : 'Apply during early growth stages, especially before flowering and after irrigation, for maximum nutrient absorption.',
    },
    {
      'icon': Icons.warning_amber_rounded,
      'title': isHindi ? 'कब न डालें' : 'When Not to Apply',
      'color': 0xFFE53935,
      'content': isHindi
          ? 'अत्यधिक गर्मी या भारी बारिश के दौरान खाद का उपयोग न करें। सूखी मिट्टी पर या कटाई के समय न डालें।'
          : 'Do not use fertilizer during extreme heat or heavy rain. Avoid applying on dry soil or at the time of harvesting.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final w = MediaQuery.of(context).size.width;
    final sections = _buildSections(isHindi);

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _brown1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? 'खाद विवरण' : 'Fertilizer Details',
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_brown1, _brown2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
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
                          child: const Center(child: Text('🌿', style: TextStyle(fontSize: 48))),
                        ),
                        const SizedBox(height: 8),
                        Text('Urea · यूरिया',
                            style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick chips
                  Row(
                    children: [
                      _chip(Icons.science_rounded, isHindi ? 'नाइट्रोजन' : 'Nitrogen', const Color(0xFF1565C0)),
                      const SizedBox(width: 10),
                      _chip(Icons.water_drop_rounded, isHindi ? 'पानी में घुलनशील' : 'Water Soluble', const Color(0xFF0288D1)),
                      const SizedBox(width: 10),
                      _chip(Icons.eco_rounded, isHindi ? 'फसल वृद्धि' : 'Crop Growth', const Color(0xFF2E7D32)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Video card
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
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(color: const Color(0xFF1A1A2E),
                                  child: const Center(child: Text('🎬', style: TextStyle(fontSize: 52)))),
                            ),
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
                                isHindi ? '▶ खाद के बारे में विडियो देखें' : '▶ Watch Video About Fertilizer',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info sections
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
