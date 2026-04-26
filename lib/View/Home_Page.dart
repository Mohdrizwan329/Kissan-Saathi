import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/Data/Fertilizer_Data.dart';
import 'package:indian_farmer/Data/Irrigation_Data.dart';
import 'package:indian_farmer/Data/Pesticide_Data.dart';
import 'package:indian_farmer/Data/Seed_Data.dart';
import 'package:indian_farmer/Data/Tool_Data.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_List_Screen.dart';
import 'package:indian_farmer/View/Tools/Tool_List_Screen.dart';
import 'package:indian_farmer/View/Seeds/Seed_List_Screen.dart';
import 'package:indian_farmer/View/All_Items_Screen.dart';
import 'package:indian_farmer/View/Fertilizer/Fertilizer_Detail_Screen.dart';
import 'package:indian_farmer/View/Pesticide/Pesticide_Detail_Screen.dart';
import 'package:indian_farmer/View/Mausam_Page.dart';
import 'package:indian_farmer/View/Fasal_Calendar_Page.dart';
import 'package:indian_farmer/View/Kisan_Calculator_Page.dart';
import 'package:indian_farmer/View/Fasal_Bima_Page.dart';
import 'package:indian_farmer/View/Kisan_Helpline_Page.dart';
import 'package:indian_farmer/View/Mitti_Health_Page.dart';
import 'package:indian_farmer/View/Pashu_Palan_Page.dart';
import 'package:indian_farmer/View/Jaivik_Kheti_Page.dart';
import 'package:indian_farmer/View/Fasal_Doctor_Page.dart';
import 'package:indian_farmer/View/Kisan_Diary_Page.dart';
import 'package:indian_farmer/View/Bhandaran_Page.dart';
import 'package:indian_farmer/View/Notification_Page.dart';
import 'package:indian_farmer/Model/Seed_Model.dart';
import 'package:indian_farmer/Model/Tool_Model.dart';
import 'package:indian_farmer/Model/Irrigation_Model.dart';
import 'package:indian_farmer/l10n/s.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final allSeeds = SeedData.getAllSeeds();
  final allFertilizers = FertilizerData.getAllFertilizers();
  final allPesticides = PesticideData.getAllPesticides();
  final allTools = ToolData.getAllTools();
  final allIrrigation = IrrigationData.getAllMethods();

  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  static const int _bannerCount = 3;

  List<Map<String, Object>> _buildBanners(bool isHindi) => [
    {
      'title': isHindi ? 'खरीफ फसल का मौसम' : 'Kharif Crop Season',
      'subtitle': isHindi ? 'धान, मक्का, सोयाबीन की बुवाई करें' : 'Sow paddy, maize and soybean now',
      'icon': '🌾',
      'c1': 0xFF1B5E20,
      'c2': 0xFF43A047,
    },
    {
      'title': isHindi ? 'उत्तम खाद — उत्तम फसल' : 'Best Fertilizer — Best Crop',
      'subtitle': isHindi ? 'जैविक खाद से पाएं बेहतर उत्पादन' : 'Get better yield with organic manure',
      'icon': '🌱',
      'c1': 0xFF4E342E,
      'c2': 0xFF8D6E63,
    },
    {
      'title': isHindi ? 'सही सिंचाई — सही समय' : 'Right Irrigation — Right Time',
      'subtitle': isHindi ? 'ड्रिप सिंचाई से 50% पानी बचाएं' : 'Save 50% water with drip irrigation',
      'icon': '💧',
      'c1': 0xFF01579B,
      'c2': 0xFF039BE5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _bannerCount;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // ─── color palette ────────────────────────────────────────────────
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  static const _catColors = [
    [Color(0xFF2E7D32), Color(0xFF66BB6A)],   // Seeds – deep green
    [Color(0xFF4E342E), Color(0xFF8D6E63)],   // Fertilizer – earth brown
    [Color(0xFF6A1B9A), Color(0xFFAB47BC)],   // Pesticide – purple
    [Color(0xFFE65100), Color(0xFFFFA726)],   // Tools – orange
    [Color(0xFF01579B), Color(0xFF29B6F6)],   // Irrigation – blue
  ];


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, w, isHindi),
              _buildBanner(w, isHindi),
              _buildQuickCategories(context, w, isHindi),
              _buildDivider(),
              _buildKisanServices(context, w, isHindi),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════ HEADER ═══════════
  Widget _buildHeader(BuildContext context, double w, bool isHindi) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_green1, _green2],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(w * 0.05, 14, w * 0.05, 10),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 1.5),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHindi ? 'नमस्ते, किसान भाई 🙏' : 'Welcome, Farmer!',
                        style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        S.of(context)?.appName ?? 'किसान साथी',
                        style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const NotificationPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
          // ─── season strip ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stripChip('☀️', _getCurrentSeason(isHindi)),
                _stripDot(),
                _stripChip('🌡️', _getCurrentMonthYear(isHindi)),
                _stripDot(),
                _stripChip('💰', isHindi ? 'MSP अपडेट' : 'MSP Update'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentSeason(bool isHindi) {
    final m = DateTime.now().month;
    if (m >= 6 && m <= 9) return isHindi ? 'खरीफ मौसम' : 'Kharif Season';
    if (m >= 10 || m <= 3) return isHindi ? 'रबी मौसम' : 'Rabi Season';
    return isHindi ? 'जायद मौसम' : 'Zaid Season';
  }

  String _getCurrentMonthYear(bool isHindi) {
    final now = DateTime.now();
    if (isHindi) {
      const months = ['जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'];
      final hindiDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
      final year = now.year.toString().split('').map((c) => hindiDigits[int.parse(c)]).join();
      return '${months[now.month - 1]} $year';
    }
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[now.month - 1]} ${now.year}';
  }

  Widget _stripChip(String icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _stripDot() =>
      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white38, shape: BoxShape.circle));

  // ═══════════ BANNER ═══════════
  Widget _buildBanner(double w, bool isHindi) {
    final banners = _buildBanners(isHindi);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: banners.length,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemBuilder: (ctx, i) => _bannerCard(banners[i], w, isHindi),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) {
              final active = i == _currentBanner;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? _green2 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _bannerCard(Map<String, Object> b, double w, bool isHindi) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(b['c1'] as int), Color(b['c2'] as int)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(b['c1'] as int).withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // decorative circle
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20, bottom: -30,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isHindi ? '🌿 किसान टिप्स' : '🌿 Farmer Tips',
                          style: GoogleFonts.poppins(
                            fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        b['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b['subtitle'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(b['icon'] as String, style: const TextStyle(fontSize: 52)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════ QUICK CATEGORIES ═══════════
  Widget _buildQuickCategories(BuildContext context, double w, bool isHindi) {
    final s = S.of(context);
    final cats = [
      {'label': s?.homeSeeds ?? 'बीज', 'icon': '🌾', 'key': 'Seeds', 'colors': _catColors[0]},
      {'label': s?.homeFertilizers ?? 'खाद', 'icon': '🌿', 'key': 'Fertilizer', 'colors': _catColors[1]},
      {'label': s?.homePesticides ?? 'दवा', 'icon': '🧪', 'key': 'Pesticides', 'colors': _catColors[2]},
      {'label': s?.homeTools ?? 'औजार', 'icon': '🔧', 'key': 'Tools', 'colors': _catColors[3]},
      {'label': s?.homeIrrigation ?? 'सिंचाई', 'icon': '💧', 'key': 'Irrigation', 'colors': _catColors[4]},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 4, height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_green1, _green2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isHindi ? 'श्रेणियाँ' : 'Categories',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: _green1),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.1,
            ),
            itemCount: cats.length,
            itemBuilder: (ctx, i) {
              final cat = cats[i];
              final colors = cat['colors'] as List<Color>;
              return GestureDetector(
                onTap: () => _nav(context, cat['key'] as String),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: colors[0].withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat['icon'] as String, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        cat['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  // ═══════════ DIVIDER ═══════════
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(height: 1, color: _green2.withValues(alpha: 0.25)),
    );
  }





  // ═══════════ KISAN SERVICES ═══════════
  Widget _buildKisanServices(BuildContext context, double w, bool isHindi) {
    final services = [
      {
        'label': isHindi ? 'मौसम' : 'Weather',
        'icon': '🌤️',
        'colors': [const Color(0xFF0277BD), const Color(0xFF29B6F6)],
        'screen': const MausamPage(),
      },
      {
        'label': isHindi ? 'फसल कैलेंडर' : 'Crop Calendar',
        'icon': '📅',
        'colors': [const Color(0xFF1B5E20), const Color(0xFF66BB6A)],
        'screen': const FasalCalendarPage(),
      },
      {
        'label': isHindi ? 'कैलकुलेटर' : 'Calculator',
        'icon': '🧮',
        'colors': [const Color(0xFFE65100), const Color(0xFFFFA726)],
        'screen': const KisanCalculatorPage(),
      },
      {
        'label': isHindi ? 'फसल बीमा' : 'Crop Insurance',
        'icon': '🛡️',
        'colors': [const Color(0xFF4A148C), const Color(0xFFAB47BC)],
        'screen': const FasalBimaPage(),
      },
      {
        'label': isHindi ? 'हेल्पलाइन' : 'Helpline',
        'icon': '📞',
        'colors': [const Color(0xFF880E4F), const Color(0xFFF48FB1)],
        'screen': const KisanHelplinePage(),
      },
      {
        'label': isHindi ? 'मिट्टी जांच' : 'Soil Health',
        'icon': '🌍',
        'colors': [const Color(0xFF4E342E), const Color(0xFF8D6E63)],
        'screen': const MittiHealthPage(),
      },
      {
        'label': isHindi ? 'पशु पालन' : 'Animal Care',
        'icon': '🐄',
        'colors': [const Color(0xFF4E342E), const Color(0xFF8D6E63)],
        'screen': const PashuPalanPage(),
      },
      {
        'label': isHindi ? 'जैविक खेती' : 'Organic Farm',
        'icon': '♻️',
        'colors': [const Color(0xFF1B5E20), const Color(0xFF66BB6A)],
        'screen': const JaivikKhetiPage(),
      },
      {
        'label': isHindi ? 'फसल डॉक्टर' : 'Crop Doctor',
        'icon': '🩺',
        'colors': [const Color(0xFFB71C1C), const Color(0xFFE53935)],
        'screen': const FasalDoctorPage(),
      },
      {
        'label': isHindi ? 'किसान डायरी' : 'Farm Diary',
        'icon': '📒',
        'colors': [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
        'screen': const KisanDiaryPage(),
      },
      {
        'label': isHindi ? 'भंडारण' : 'Storage',
        'icon': '🏚️',
        'colors': [const Color(0xFFE65100), const Color(0xFFFFA726)],
        'screen': const BhandaranPage(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 4, height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_green1, _green2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('⚙️', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  isHindi ? 'किसान सेवाएं' : 'Kisan Services',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: _green1),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.1,
            ),
            itemCount: services.length,
            itemBuilder: (ctx, i) {
              final svc = services[i];
              final colors = svc['colors'] as List<Color>;
              return GestureDetector(
                onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => svc['screen'] as Widget)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(svc['icon'] as String, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        svc['label'] as String,
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════ NAVIGATION ═══════════
  void _nav(BuildContext ctx, String key) {
    final isHindi = Localizations.localeOf(ctx).languageCode == 'hi';
    final s = S.of(ctx);
    Widget? screen;
    switch (key) {
      case 'Seeds':
        screen = SeedListScreen(
          category: SeedCategory(
            name: 'All Seeds', nameHindi: 'सभी बीज', icon: '', seeds: SeedData.getAllSeeds(),
          ),
        );
        break;
      case 'Tools':
        screen = ToolListScreen(
          category: ToolCategory(
            name: 'All Tools', nameHindi: 'सभी औजार', icon: '', tools: ToolData.getAllTools(),
          ),
        );
        break;
      case 'Irrigation':
        screen = IrrigationListScreen(
          category: IrrigationCategory(
            name: 'All Irrigation', nameHindi: 'सभी सिंचाई', icon: '', methods: IrrigationData.getAllMethods(),
          ),
        );
        break;
      case 'Fertilizer':
        screen = AllItemsScreen(
          title: isHindi ? 'सभी खाद' : (s?.homeFertilizers ?? 'Fertilizers'),
          items: allFertilizers.map((f) => {'name': isHindi ? f.nameHindi : f.name, 'image': f.image}).toList(),
          fallbackIcon: Icons.eco,
          onItemTap: (i) => Navigator.push(ctx, MaterialPageRoute(
            builder: (_) => FertilizerDetailScreen(fertilizer: allFertilizers[i]),
          )),
        );
        break;
      case 'Pesticides':
        screen = AllItemsScreen(
          title: isHindi ? 'सभी दवा' : (s?.homePesticides ?? 'Pesticides'),
          items: allPesticides.map((p) => {'name': isHindi ? p.nameHindi : p.name, 'image': p.image}).toList(),
          fallbackIcon: Icons.bug_report,
          onItemTap: (i) => Navigator.push(ctx, MaterialPageRoute(
            builder: (_) => PesticideDetailScreen(pesticide: allPesticides[i]),
          )),
        );
        break;
    }
    if (screen != null) Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen!));
  }
}
