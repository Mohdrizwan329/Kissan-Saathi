import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:indian_farmer/Data/Fertilizer_Data.dart';
import 'package:indian_farmer/Data/Irrigation_Data.dart';
import 'package:indian_farmer/Data/Pesticide_Data.dart';
import 'package:indian_farmer/Data/Seed_Data.dart';
import 'package:indian_farmer/Data/Tool_Data.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_Detail_Screen.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_List_Screen.dart';
import 'package:indian_farmer/View/Product/Product_Page.dart';
import 'package:indian_farmer/View/Tools/Tool_Detail_Screen.dart';
import 'package:indian_farmer/View/Tools/Tool_List_Screen.dart';
import 'package:indian_farmer/View/Seeds/Seed_Detail_Screen.dart';
import 'package:indian_farmer/View/Seeds/Seed_List_Screen.dart';
import 'package:indian_farmer/View/All_Items_Screen.dart';
import 'package:indian_farmer/View/Fertilizer/Fertilizer_Detail_Screen.dart';
import 'package:indian_farmer/View/Pesticide/Pesticide_Detail_Screen.dart';
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

  static const _banners = [
    {
      'title': 'खरीफ फसल का मौसम',
      'subtitle': 'धान, मक्का, सोयाबीन की बुवाई करें',
      'icon': '🌾',
      'c1': 0xFF1B5E20,
      'c2': 0xFF43A047,
    },
    {
      'title': 'उत्तम खाद — उत्तम फसल',
      'subtitle': 'जैविक खाद से पाएं बेहतर उत्पादन',
      'icon': '🌱',
      'c1': 0xFF4E342E,
      'c2': 0xFF8D6E63,
    },
    {
      'title': 'सही सिंचाई — सही समय',
      'subtitle': 'ड्रिप सिंचाई से 50% पानी बचाएं',
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
      final next = (_currentBanner + 1) % _banners.length;
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
  static const _cream = Color(0xFFF6F4EE);

  static const _catColors = [
    [Color(0xFF2E7D32), Color(0xFF66BB6A)],   // Seeds – deep green
    [Color(0xFF4E342E), Color(0xFF8D6E63)],   // Fertilizer – earth brown
    [Color(0xFF6A1B9A), Color(0xFFAB47BC)],   // Pesticide – purple
    [Color(0xFFE65100), Color(0xFFFFA726)],   // Tools – orange
    [Color(0xFF01579B), Color(0xFF29B6F6)],   // Irrigation – blue
  ];

  static const _seedCardColors = [
    [Color(0xFF43A047), Color(0xFF81C784)],
    [Color(0xFFFF8F00), Color(0xFFFFD54F)],
    [Color(0xFFE53935), Color(0xFFEF9A9A)],
    [Color(0xFF1E88E5), Color(0xFF90CAF9)],
    [Color(0xFF8E24AA), Color(0xFFCE93D8)],
    [Color(0xFF00897B), Color(0xFF80CBC4)],
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
              _buildBanner(w),
              _buildQuickCategories(context, w, isHindi),
              _buildDivider(),
              _buildSeedSection(context, w, isHindi),
              _buildDivider(),
              _buildSimpleSection(
                context: context, w: w,
                title: S.of(context)?.homeFertilizers ?? 'खाद',
                subtitle: S.of(context)?.homeFertilizersSub ?? 'Fertilizers',
                navKey: 'Fertilizer',
                colorPair: _catColors[1],
                items: allFertilizers.map((f) => {
                  'name': isHindi ? f.nameHindi : f.name,
                  'image': f.image,
                }).toList(),
                onCardTap: (i) => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FertilizerDetailScreen(fertilizer: allFertilizers[i]),
                )),
              ),
              _buildDivider(),
              _buildSimpleSection(
                context: context, w: w,
                title: S.of(context)?.homePesticides ?? 'दवा',
                subtitle: S.of(context)?.homePesticidesSub ?? 'Pesticides',
                navKey: 'Pesticides',
                colorPair: _catColors[2],
                items: allPesticides.map((p) => {
                  'name': isHindi ? p.nameHindi : p.name,
                  'image': p.image,
                }).toList(),
                onCardTap: (i) => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => PesticideDetailScreen(pesticide: allPesticides[i]),
                )),
              ),
              _buildDivider(),
              _buildToolSection(context, w, isHindi),
              _buildDivider(),
              _buildIrrigationSection(context, w, isHindi),
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
                    context, MaterialPageRoute(builder: (_) => ProductScreen()),
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
                _stripChip('☀️', isHindi ? 'खरीफ मौसम' : 'Kharif Season'),
                _stripDot(),
                _stripChip('🌡️', isHindi ? 'अप्रैल २०२६' : 'April 2026'),
                _stripDot(),
                _stripChip('💰', isHindi ? 'MSP अपडेट' : 'MSP Update'),
              ],
            ),
          ),
        ],
      ),
    );
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
  Widget _buildBanner(double w) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: PageView.builder(
              controller: _bannerController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemBuilder: (ctx, i) => _bannerCard(_banners[i], w),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
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

  Widget _bannerCard(Map<String, Object> b, double w) {
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
                          '🌿 किसान टिप्स',
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
            child: Text(
              isHindi ? 'श्रेणियाँ' : 'Categories',
              style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: cats.map((cat) {
              final colors = cat['colors'] as List<Color>;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _nav(context, cat['key'] as String),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat['icon'] as String, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          cat['label'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════ SECTION HEADER ═══════════
  Widget _sectionHeader(
    BuildContext context,
    double w,
    String title,
    String subtitle,
    List<Color> colors,
    VoidCallback onViewAll,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, 14, w * 0.05, 10),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _sectionIcon(title),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87,
                  ),
                ),
                if (subtitle.trim().toLowerCase() != title.trim().toLowerCase())
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                S.of(context)?.viewAll ?? 'सभी देखें',
                style: GoogleFonts.poppins(
                  fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sectionIcon(String title) {
    if (title.contains('बीज') || title.contains('Seed')) return '🌾';
    if (title.contains('खाद') || title.contains('Fert')) return '🌿';
    if (title.contains('दवा') || title.contains('Pest')) return '🧪';
    if (title.contains('औजार') || title.contains('Tool')) return '🔧';
    if (title.contains('सिंचाई') || title.contains('Irr')) return '💧';
    return '🌱';
  }

  // ═══════════ ITEM CARD ═══════════
  Widget _itemCard(double w, String name, String image, List<Color> colors, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: w * 0.14, height: w * 0.14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors[0].withValues(alpha: 0.15), colors[1].withValues(alpha: 0.25)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: colors[0].withValues(alpha: 0.3), width: 1.5),
              ),
              child: image.startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) => SizedBox(
                          width: w * 0.05, height: w * 0.05,
                          child: CircularProgressIndicator(strokeWidth: 2, color: colors[0]),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.grass, color: colors[0], size: w * 0.06),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(child: Text(image, style: TextStyle(fontSize: w * 0.065))),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════ DIVIDER ═══════════
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(height: 1, color: Colors.grey.shade200),
    );
  }

  // ═══════════ SEEDS SECTION ═══════════
  Widget _buildSeedSection(BuildContext context, double w, bool isHindi) {
    final show = allSeeds.length > 6 ? allSeeds.sublist(0, 6) : allSeeds;
    return Column(
      children: [
        _sectionHeader(
          context, w,
          S.of(context)?.homeSeeds ?? 'बीज',
          S.of(context)?.homeSeedsSub ?? 'Seeds',
          _catColors[0],
          () => _nav(context, 'Seeds'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.85,
            ),
            itemCount: show.length,
            itemBuilder: (ctx, i) {
              final seed = show[i];
              return _itemCard(w, isHindi ? seed.nameHindi : seed.name, seed.image, _seedCardColors[i % _seedCardColors.length], () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SeedDetailScreen(seed: seed)));
              });
            },
          ),
        ),
      ],
    );
  }

  // ═══════════ TOOLS SECTION ═══════════
  Widget _buildToolSection(BuildContext context, double w, bool isHindi) {
    final show = allTools.length > 6 ? allTools.sublist(0, 6) : allTools;
    return Column(
      children: [
        _sectionHeader(
          context, w,
          S.of(context)?.homeTools ?? 'औजार',
          S.of(context)?.homeToolsSub ?? 'Tools',
          _catColors[3],
          () => _nav(context, 'Tools'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.85,
            ),
            itemCount: show.length,
            itemBuilder: (ctx, i) {
              final tool = show[i];
              return _itemCard(w, isHindi ? tool.nameHindi : tool.name, tool.image, _catColors[3], () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool)));
              });
            },
          ),
        ),
      ],
    );
  }

  // ═══════════ IRRIGATION SECTION ═══════════
  Widget _buildIrrigationSection(BuildContext context, double w, bool isHindi) {
    final show = allIrrigation.length > 6 ? allIrrigation.sublist(0, 6) : allIrrigation;
    return Column(
      children: [
        _sectionHeader(
          context, w,
          S.of(context)?.homeIrrigation ?? 'सिंचाई',
          S.of(context)?.homeIrrigationSub ?? 'Irrigation',
          _catColors[4],
          () => _nav(context, 'Irrigation'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.85,
            ),
            itemCount: show.length,
            itemBuilder: (ctx, i) {
              final method = show[i];
              return _itemCard(w, isHindi ? method.nameHindi : method.name, method.image, _catColors[4], () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => IrrigationDetailScreen(method: method)));
              });
            },
          ),
        ),
      ],
    );
  }

  // ═══════════ SIMPLE SECTION (Fertilizer / Pesticide) ═══════════
  Widget _buildSimpleSection({
    required BuildContext context,
    required double w,
    required String title,
    required String subtitle,
    required String navKey,
    required List<Color> colorPair,
    required List<Map<String, String>> items,
    required void Function(int index) onCardTap,
  }) {
    final show = items.length > 6 ? items.sublist(0, 6) : items;
    return Column(
      children: [
        _sectionHeader(context, w, title, subtitle, colorPair, () => _nav(context, navKey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.85,
            ),
            itemCount: show.length,
            itemBuilder: (ctx, i) {
              final item = show[i];
              return _itemCard(w, item['name'] ?? '', item['image'] ?? '', colorPair, () => onCardTap(i));
            },
          ),
        ),
      ],
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
