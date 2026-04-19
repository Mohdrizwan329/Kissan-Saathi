import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'जानकारी' : 'Information',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: '🌱 कृषि टिप्स'),
            Tab(text: '💰 मंडी भाव'),
            Tab(text: '🏛️ योजनाएं'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _KrishiTipsTab(isHindi: isHindi),
          _MandiBhavTab(isHindi: isHindi),
          _YojnaTab(isHindi: isHindi),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB 1 — Krishi Tips
// ─────────────────────────────────────────────────────────────
class _KrishiTipsTab extends StatefulWidget {
  final bool isHindi;
  const _KrishiTipsTab({required this.isHindi});

  @override
  State<_KrishiTipsTab> createState() => _KrishiTipsTabState();
}

class _KrishiTipsTabState extends State<_KrishiTipsTab> {
  int _selectedCat = 0;

  static const _cats = ['सभी', 'रबी', 'खरीफ', 'जैविक', 'सिंचाई', 'मिट्टी'];
  static const _catColors = [
    Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFFE65100),
    Color(0xFF00695C), Color(0xFF0288D1), Color(0xFF5D4037),
  ];

  static const _tips = [
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
      'desc': 'नीम का तेल (5 मिली/लीटर पानी) छिड़काव से अधिकांश कीटों को नियंत्रित किया जा सकता है। यह पर्यावरण के लिए सुरक्षित है।',
      'descEn': 'Spray neem oil (5ml/liter water) to control most pests. It is safe for the environment.',
      'tag': 'जैविक', 'tagEn': 'Organic',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final filtered = _selectedCat == 0
        ? _tips
        : _tips.where((t) => t['cat'] == _selectedCat).toList();

    return Column(
      children: [
        SizedBox(
          height: 48,
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
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _tipCard(filtered[i], w),
                ),
        ),
      ],
    );
  }

  Widget _tipCard(Map<String, Object> tip, double w) {
    final color = Color(tip['color'] as int);
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.isHindi ? (tip['tag'] as String) : (tip['tagEn'] as String),
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isHindi ? (tip['title'] as String) : (tip['titleEn'] as String),
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isHindi ? (tip['desc'] as String) : (tip['descEn'] as String),
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

// ─────────────────────────────────────────────────────────────
// TAB 2 — Mandi Bhav
// ─────────────────────────────────────────────────────────────
class _MandiBhavTab extends StatefulWidget {
  final bool isHindi;
  const _MandiBhavTab({required this.isHindi});

  @override
  State<_MandiBhavTab> createState() => _MandiBhavTabState();
}

class _MandiBhavTabState extends State<_MandiBhavTab> {
  int _selectedMandi = 0;

  static const _mandis = ['दिल्ली', 'लखनऊ', 'जयपुर', 'पटना', 'भोपाल'];

  static const _prices = [
    // Delhi
    [
      {'crop': 'गेहूं', 'cropEn': 'Wheat', 'icon': '🌾', 'price': '2250', 'unit': 'क्विंटल', 'change': '+35', 'up': true, 'color': 0xFF1565C0},
      {'crop': 'धान', 'cropEn': 'Paddy', 'icon': '🌾', 'price': '1940', 'unit': 'क्विंटल', 'change': '-20', 'up': false, 'color': 0xFF2E7D32},
      {'crop': 'मक्का', 'cropEn': 'Maize', 'icon': '🌽', 'price': '1850', 'unit': 'क्विंटल', 'change': '+15', 'up': true, 'color': 0xFFE65100},
      {'crop': 'सरसों', 'cropEn': 'Mustard', 'icon': '🌼', 'price': '5200', 'unit': 'क्विंटल', 'change': '+80', 'up': true, 'color': 0xFFF9A825},
      {'crop': 'चना', 'cropEn': 'Gram', 'icon': '🫘', 'price': '4600', 'unit': 'क्विंटल', 'change': '-30', 'up': false, 'color': 0xFF5D4037},
      {'crop': 'आलू', 'cropEn': 'Potato', 'icon': '🥔', 'price': '1200', 'unit': 'क्विंटल', 'change': '+10', 'up': true, 'color': 0xFF6D4C41},
      {'crop': 'प्याज', 'cropEn': 'Onion', 'icon': '🧅', 'price': '1800', 'unit': 'क्विंटल', 'change': '-50', 'up': false, 'color': 0xFF8E24AA},
      {'crop': 'टमाटर', 'cropEn': 'Tomato', 'icon': '🍅', 'price': '2100', 'unit': 'क्विंटल', 'change': '+120', 'up': true, 'color': 0xFFE53935},
    ],
    // Lucknow
    [
      {'crop': 'गेहूं', 'cropEn': 'Wheat', 'icon': '🌾', 'price': '2230', 'unit': 'क्विंटल', 'change': '+25', 'up': true, 'color': 0xFF1565C0},
      {'crop': 'धान', 'cropEn': 'Paddy', 'icon': '🌾', 'price': '1960', 'unit': 'क्विंटल', 'change': '+10', 'up': true, 'color': 0xFF2E7D32},
      {'crop': 'गन्ना', 'cropEn': 'Sugarcane', 'icon': '🎋', 'price': '350', 'unit': 'क्विंटल', 'change': '0', 'up': true, 'color': 0xFF00695C},
      {'crop': 'मटर', 'cropEn': 'Peas', 'icon': '🫛', 'price': '3200', 'unit': 'क्विंटल', 'change': '-40', 'up': false, 'color': 0xFF388E3C},
      {'crop': 'सरसों', 'cropEn': 'Mustard', 'icon': '🌼', 'price': '5150', 'unit': 'क्विंटल', 'change': '+60', 'up': true, 'color': 0xFFF9A825},
      {'crop': 'आलू', 'cropEn': 'Potato', 'icon': '🥔', 'price': '1150', 'unit': 'क्विंटल', 'change': '+20', 'up': true, 'color': 0xFF6D4C41},
    ],
    // Jaipur
    [
      {'crop': 'बाजरा', 'cropEn': 'Millet', 'icon': '🌾', 'price': '2100', 'unit': 'क्विंटल', 'change': '+40', 'up': true, 'color': 0xFFF57F17},
      {'crop': 'जौ', 'cropEn': 'Barley', 'icon': '🌾', 'price': '1650', 'unit': 'क्विंटल', 'change': '-15', 'up': false, 'color': 0xFF5D4037},
      {'crop': 'मूंगफली', 'cropEn': 'Groundnut', 'icon': '🥜', 'price': '5800', 'unit': 'क्विंटल', 'change': '+100', 'up': true, 'color': 0xFFE65100},
      {'crop': 'जीरा', 'cropEn': 'Cumin', 'icon': '🌿', 'price': '28000', 'unit': 'क्विंटल', 'change': '-500', 'up': false, 'color': 0xFF6A1B9A},
      {'crop': 'धनिया', 'cropEn': 'Coriander', 'icon': '🌿', 'price': '7200', 'unit': 'क्विंटल', 'change': '+200', 'up': true, 'color': 0xFF2E7D32},
    ],
    // Patna
    [
      {'crop': 'धान', 'cropEn': 'Paddy', 'icon': '🌾', 'price': '1980', 'unit': 'क्विंटल', 'change': '+20', 'up': true, 'color': 0xFF2E7D32},
      {'crop': 'मक्का', 'cropEn': 'Maize', 'icon': '🌽', 'price': '1820', 'unit': 'क्विंटल', 'change': '-10', 'up': false, 'color': 0xFFE65100},
      {'crop': 'दलहन', 'cropEn': 'Pulses', 'icon': '🫘', 'price': '6200', 'unit': 'क्विंटल', 'change': '+150', 'up': true, 'color': 0xFF5D4037},
      {'crop': 'लीची', 'cropEn': 'Lychee', 'icon': '🍈', 'price': '4500', 'unit': 'क्विंटल', 'change': '+300', 'up': true, 'color': 0xFFE53935},
    ],
    // Bhopal
    [
      {'crop': 'सोयाबीन', 'cropEn': 'Soybean', 'icon': '🫘', 'price': '4200', 'unit': 'क्विंटल', 'change': '+80', 'up': true, 'color': 0xFF2E7D32},
      {'crop': 'गेहूं', 'cropEn': 'Wheat', 'icon': '🌾', 'price': '2210', 'unit': 'क्विंटल', 'change': '+20', 'up': true, 'color': 0xFF1565C0},
      {'crop': 'चना', 'cropEn': 'Gram', 'icon': '🫘', 'price': '4700', 'unit': 'क्विंटल', 'change': '+50', 'up': true, 'color': 0xFF5D4037},
      {'crop': 'मक्का', 'cropEn': 'Maize', 'icon': '🌽', 'price': '1900', 'unit': 'क्विंटल', 'change': '+30', 'up': true, 'color': 0xFFE65100},
      {'crop': 'अरहर', 'cropEn': 'Arhar Dal', 'icon': '🫘', 'price': '7800', 'unit': 'क्विंटल', 'change': '+200', 'up': true, 'color': 0xFF6D4C41},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final items = List<Map<String, Object>>.from(_prices[_selectedMandi]);
    final now = DateTime.now();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.store_rounded, color: Color(0xFF2E7D32), size: 16),
                  const SizedBox(width: 6),
                  Text(widget.isHindi ? 'मंडी चुनें' : 'Select Mandi',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                  const Spacer(),
                  Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    '${now.day}/${now.month}/${now.year}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _mandis.length,
                  itemBuilder: (_, i) {
                    final sel = _selectedMandi == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMandi = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF2E7D32) : const Color(0xFFF6F4EE),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? const Color(0xFF2E7D32) : Colors.grey.shade300),
                        ),
                        child: Text(_mandis[i],
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : Colors.grey.shade600)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Container(
          color: const Color(0xFF2E7D32),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(widget.isHindi ? 'फसल' : 'Crop',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
              Expanded(flex: 2, child: Text(widget.isHindi ? 'भाव (₹)' : 'Price (₹)',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text(widget.isHindi ? 'बदलाव' : 'Change',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
            itemCount: items.length,
            itemBuilder: (_, i) => _priceRow(items[i], w, i),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(Map<String, Object> item, double w, int i) {
    final isUp = item['up'] as bool;
    final color = Color(item['color'] as int);
    final change = item['change'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.28)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(item['icon'] as String, style: const TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isHindi ? (item['crop'] as String) : (item['cropEn'] as String),
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                      ),
                      Text('प्रति ${item['unit']}',
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${item['price']}',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: isUp ? const Color(0xFF2E7D32) : Colors.red,
                  size: 14,
                ),
                Text(
                  change == '0' ? '—' : change,
                  style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: change == '0' ? Colors.grey : (isUp ? const Color(0xFF2E7D32) : Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB 3 — Sarkari Yojnayein
// ─────────────────────────────────────────────────────────────
class _YojnaTab extends StatelessWidget {
  final bool isHindi;
  const _YojnaTab({required this.isHindi});

  static const _schemes = [
    {
      'icon': '🌾', 'color': 0xFF1B5E20,
      'title': 'PM-KISAN योजना',
      'titleEn': 'PM-KISAN Scheme',
      'benefit': '₹6,000 प्रति वर्ष',
      'benefitEn': '₹6,000 per year',
      'desc': 'छोटे और सीमांत किसानों को प्रति वर्ष ₹6000 की आर्थिक सहायता, 3 किस्तों में।',
      'descEn': 'Financial assistance of ₹6000 per year to small & marginal farmers, in 3 installments.',
      'tag': 'आर्थिक सहायता', 'tagEn': 'Financial Aid',
      'url': 'https://pmkisan.gov.in',
    },
    {
      'icon': '🛡️', 'color': 0xFF1565C0,
      'title': 'प्रधानमंत्री फसल बीमा योजना',
      'titleEn': 'PM Fasal Bima Yojana',
      'benefit': '2% प्रीमियम पर बीमा',
      'benefitEn': 'Insurance at 2% Premium',
      'desc': 'खरीफ फसलों पर 2%, रबी पर 1.5% और वाणिज्यिक फसलों पर 5% प्रीमियम पर फसल बीमा।',
      'descEn': 'Crop insurance at 2% for Kharif, 1.5% for Rabi and 5% for commercial crops.',
      'tag': 'बीमा', 'tagEn': 'Insurance',
      'url': 'https://pmfby.gov.in',
    },
    {
      'icon': '💧', 'color': 0xFF0288D1,
      'title': 'PM कृषि सिंचाई योजना',
      'titleEn': 'PM Krishi Sinchayee Yojana',
      'benefit': 'सब्सिडी पर ड्रिप/स्प्रिंकलर',
      'benefitEn': 'Drip/Sprinkler on Subsidy',
      'desc': 'सूक्ष्म सिंचाई उपकरणों पर 55% तक सब्सिडी। "हर खेत को पानी, अधिक फसल प्रति बूंद"।',
      'descEn': 'Up to 55% subsidy on micro irrigation equipment. "Har Khet Ko Pani, More Crop Per Drop".',
      'tag': 'सिंचाई', 'tagEn': 'Irrigation',
      'url': 'https://pmksy.gov.in',
    },
    {
      'icon': '🧪', 'color': 0xFF5D4037,
      'title': 'मृदा स्वास्थ्य कार्ड योजना',
      'titleEn': 'Soil Health Card Scheme',
      'benefit': 'मुफ्त मिट्टी जांच',
      'benefitEn': 'Free Soil Testing',
      'desc': 'किसानों को मृदा स्वास्थ्य कार्ड देकर मिट्टी की पोषण स्थिति की जानकारी दी जाती है।',
      'descEn': 'Farmers are given Soil Health Cards providing information on soil nutrient status.',
      'tag': 'मिट्टी', 'tagEn': 'Soil',
      'url': 'https://soilhealth.dac.gov.in',
    },
    {
      'icon': '🏦', 'color': 0xFF6A1B9A,
      'title': 'किसान क्रेडिट कार्ड',
      'titleEn': 'Kisan Credit Card',
      'benefit': '4% ब्याज पर ऋण',
      'benefitEn': 'Loan at 4% Interest',
      'desc': 'किसानों को खेती के लिए कम ब्याज दर पर ऋण उपलब्ध। ₹3 लाख तक 4% ब्याज दर।',
      'descEn': 'Loans available to farmers at low interest. Up to ₹3 lakh at 4% interest rate.',
      'tag': 'ऋण', 'tagEn': 'Loan',
      'url': 'https://www.nabard.org',
    },
    {
      'icon': '🌿', 'color': 0xFF00695C,
      'title': 'परंपरागत कृषि विकास योजना',
      'titleEn': 'Paramparagat Krishi Vikas Yojana',
      'benefit': '₹50,000 प्रति हेक्टेयर',
      'benefitEn': '₹50,000 per hectare',
      'desc': 'जैविक खेती को बढ़ावा देने के लिए 3 वर्ष में ₹50,000 प्रति हेक्टेयर की सहायता।',
      'descEn': 'Financial support of ₹50,000 per hectare over 3 years to promote organic farming.',
      'tag': 'जैविक खेती', 'tagEn': 'Organic Farming',
      'url': 'https://pgsindia-ncof.gov.in',
    },
    {
      'icon': '🚜', 'color': 0xFFE65100,
      'title': 'कृषि यंत्रीकरण उप-मिशन',
      'titleEn': 'Sub-Mission on Agri Mechanization',
      'benefit': '50% तक सब्सिडी',
      'benefitEn': 'Up to 50% Subsidy',
      'desc': 'ट्रैक्टर, हार्वेस्टर और अन्य कृषि यंत्रों की खरीद पर 50% तक सब्सिडी।',
      'descEn': 'Up to 50% subsidy on purchase of tractors, harvesters and other farm equipment.',
      'tag': 'यंत्र सहायता', 'tagEn': 'Equipment Aid',
      'url': 'https://farmech.dac.gov.in',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      itemCount: _schemes.length,
      itemBuilder: (_, i) => _schemeCard(_schemes[i], w, context),
    );
  }

  Widget _schemeCard(Map<String, Object> scheme, double w, BuildContext context) {
    final color = Color(scheme['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Center(child: Text(scheme['icon'] as String, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHindi ? (scheme['title'] as String) : (scheme['titleEn'] as String),
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isHindi ? (scheme['tag'] as String) : (scheme['tagEn'] as String),
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.card_giftcard_rounded, color: color, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      isHindi ? (scheme['benefit'] as String) : (scheme['benefitEn'] as String),
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isHindi ? (scheme['desc'] as String) : (scheme['descEn'] as String),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.5),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(scheme['url'] as String);
                    if (await canLaunchUrl(url)) launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.75)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          isHindi ? 'आवेदन करें / अधिक जानें' : 'Apply / Learn More',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
