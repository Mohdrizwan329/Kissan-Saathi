import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:indian_farmer/Model/Seed_Model.dart';
import 'package:indian_farmer/View/Seeds/Seed_Detail_Screen.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class SeedListScreen extends StatefulWidget {
  final SeedCategory category;
  const SeedListScreen({super.key, required this.category});

  @override
  State<SeedListScreen> createState() => _SeedListScreenState();
}

class _SeedListScreenState extends State<SeedListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<SeedInfo> _filtered;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  static const _green = Color(0xFF2E7D32);
  static const _cream = Color(0xFFF6F4EE);

  static const _cardColors = [
    [Color(0xFF43A047), Color(0xFF81C784)],   // green
    [Color(0xFFFF8F00), Color(0xFFFFD54F)],   // amber
    [Color(0xFFE53935), Color(0xFFEF9A9A)],   // red
    [Color(0xFF1E88E5), Color(0xFF90CAF9)],   // blue
    [Color(0xFF8E24AA), Color(0xFFCE93D8)],   // purple
    [Color(0xFF00897B), Color(0xFF80CBC4)],   // teal
    [Color(0xFFF4511E), Color(0xFFFFAB91)],   // deep orange
    [Color(0xFF039BE5), Color(0xFF81D4FA)],   // light blue
    [Color(0xFF7CB342), Color(0xFFDCEDC8)],   // light green
    [Color(0xFFD81B60), Color(0xFFF48FB1)],   // pink
    [Color(0xFF6D4C41), Color(0xFFBCAAA4)],   // brown
    [Color(0xFF5E35B1), Color(0xFFB39DDB)],   // deep purple
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.category.seeds);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
      );
      if (available && mounted) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          _searchController.text = result.recognizedWords;
          _onSearch(result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.from(widget.category.seeds)
          : widget.category.seeds.where((seed) =>
              seed.name.toLowerCase().contains(q) || seed.nameHindi.contains(query.trim())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final s = S.of(context);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? widget.category.nameHindi : widget.category.name,
            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w500, color: Colors.black87),
                cursorColor: _green,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: s?.searchSeedsHint ?? 'बीज खोजें...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: w * 0.038),
                  prefixIcon: Icon(Icons.search_rounded, color: _green, size: w * 0.06),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear_rounded, color: Colors.grey.shade400, size: w * 0.05),
                          onPressed: () { _searchController.clear(); _onSearch(''); },
                        ),
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                            color: _isListening ? Colors.red : _green, size: w * 0.06),
                        onPressed: _listen,
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.04),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🌾', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(s?.noSeedsFound ?? 'कोई बीज नहीं मिला',
                            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _seedCard(ctx, _filtered[i], i, w, h, isHindi),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _seedCard(BuildContext context, SeedInfo seed, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeedDetailScreen(seed: seed))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: w * 0.2,
              height: w * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors[0].withValues(alpha: 0.18), colors[1].withValues(alpha: 0.30)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: colors[0].withValues(alpha: 0.40), width: 1.5),
              ),
              child: seed.image.startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: CachedNetworkImage(
                        imageUrl: seed.image,
                        placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: colors[0])),
                        errorWidget: (_, __, ___) => Icon(Icons.grass_rounded, color: colors[0]),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(child: Text(seed.image, style: TextStyle(fontSize: w * 0.09))),
            ),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? seed.nameHindi : seed.name,
                style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.w700, color: Colors.black87),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isHindi)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Text(seed.name,
                    style: GoogleFonts.poppins(fontSize: w * 0.03, color: Colors.grey.shade500),
                    textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            SizedBox(height: h * 0.006),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colors[0].withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isHindi ? seed.seasonHindi : seed.season,
                style: GoogleFonts.poppins(fontSize: w * 0.026, fontWeight: FontWeight.w600, color: colors[0]),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
