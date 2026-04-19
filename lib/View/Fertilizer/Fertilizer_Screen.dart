import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:indian_farmer/View/Fertilizer/Fertilizer_DetailOne_Page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  static const _brown1 = Color(0xFF4E342E);
  static const _brown2 = Color(0xFF8D6E63);
  static const _cream = Color(0xFFF6F4EE);

  final List<Map<String, dynamic>> data = [
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/4264/4264579.png',
      'title': 'Urea', 'titleHindi': 'यूरिया',
      'subtitle': 'Nitrogen Fertilizer', 'subtitleHindi': 'नाइट्रोजन खाद',
      'color': [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2276/2276931.png',
      'title': 'DAP', 'titleHindi': 'डीएपी',
      'subtitle': 'Phosphorus Fertilizer', 'subtitleHindi': 'फास्फोरस खाद',
      'color': [const Color(0xFF6A1B9A), const Color(0xFFBA68C8)],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1822/1822857.png',
      'title': 'Compost', 'titleHindi': 'कम्पोस्ट',
      'subtitle': 'Organic Fertilizer', 'subtitleHindi': 'जैविक खाद',
      'color': [const Color(0xFF4E342E), const Color(0xFF8D6E63)],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/4264/4264579.png',
      'title': 'MOP', 'titleHindi': 'एमओपी',
      'subtitle': 'Potash Fertilizer', 'subtitleHindi': 'पोटाश खाद',
      'color': [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2276/2276931.png',
      'title': 'SSP', 'titleHindi': 'एसएसपी',
      'subtitle': 'Sulfur Fertilizer', 'subtitleHindi': 'सल्फर खाद',
      'color': [const Color(0xFFFF8F00), const Color(0xFFFFD54F)],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1822/1822857.png',
      'title': 'Vermicompost', 'titleHindi': 'वर्मीकम्पोस्ट',
      'subtitle': 'Bio Fertilizer', 'subtitleHindi': 'जैव खाद',
      'color': [const Color(0xFF00695C), const Color(0xFF4DB6AC)],
    },
  ];

  List<Map<String, dynamic>> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _filtered = List.from(data);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = data.where((item) {
        return (item['title'] as String).toLowerCase().contains(q) ||
            (item['subtitle'] as String).toLowerCase().contains(q) ||
            (item['titleHindi'] as String).contains(q);
      }).toList();
    });
  }

  void _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          _searchController.text = result.recognizedWords;
          _filterData(result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? 'खाद' : 'Fertilizers',
            style: GoogleFonts.poppins(fontSize: w * 0.05, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true, elevation: 0,
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
                onChanged: _filterData,
                style: GoogleFonts.poppins(fontSize: w * 0.042, color: Colors.black87),
                cursorColor: _brown1,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: isHindi ? 'खाद खोजें...' : 'Search fertilizers...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: w * 0.038),
                  prefixIcon: Icon(Icons.search_rounded, color: _brown2, size: w * 0.06),
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                        color: _isListening ? Colors.red : _brown2, size: w * 0.06),
                    onPressed: _listen,
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
                        Text('🌿', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(isHindi ? 'कोई खाद नहीं मिली' : 'No fertilizers found',
                            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.82,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _fertCard(ctx, _filtered[i], w, h, isHindi),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _fertCard(BuildContext context, Map<String, dynamic> item, double w, double h, bool isHindi) {
    final colors = item['color'] as List<Color>;
    return GestureDetector(
      onTap: () {
        if (item['title'] == 'Urea') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const FertilizerDetailPage()));
        }
      },
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
              width: w * 0.2, height: w * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors[0].withValues(alpha: 0.15), colors[1].withValues(alpha: 0.25)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: colors[0].withValues(alpha: 0.3), width: 1.5),
              ),
              child: (item['image'] as String).startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: CachedNetworkImage(
                        imageUrl: item['image'],
                        placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (_, __, ___) => Icon(Icons.eco_rounded, color: colors[0], size: w * 0.08),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(child: Text(item['image'], style: TextStyle(fontSize: w * 0.09))),
            ),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? item['titleHindi'] : item['title'],
                style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.w700, color: Colors.black87),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: h * 0.004),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colors[0].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isHindi ? item['subtitleHindi'] : item['subtitle'],
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
