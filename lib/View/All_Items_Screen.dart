import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class AllItemsScreen extends StatefulWidget {
  final String title;
  final List<Map<String, String>> items;
  final IconData fallbackIcon;
  final void Function(int index)? onItemTap;

  const AllItemsScreen({
    super.key,
    required this.title,
    required this.items,
    this.fallbackIcon = Icons.image,
    this.onItemTap,
  });

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, String>> _filtered;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  static const _cream = Color(0xFFE8F5E9);

  static const _cardColors = [
    [Color(0xFF1B5E20), Color(0xFF43A047)],
    [Color(0xFFF57F17), Color(0xFFFFCA28)],
    [Color(0xFF4E342E), Color(0xFF8D6E63)],
    [Color(0xFF01579B), Color(0xFF29B6F6)],
    [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    [Color(0xFF00695C), Color(0xFF26A69A)],
    [Color(0xFF558B2F), Color(0xFF9CCC65)],
    [Color(0xFF4E342E), Color(0xFFA1887F)],
    [Color(0xFF1B5E20), Color(0xFF66BB6A)],
    [Color(0xFFF9A825), Color(0xFFFFD54F)],
    [Color(0xFF00695C), Color(0xFF4DB6AC)],
    [Color(0xFF33691E), Color(0xFF8BC34A)],
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.generate(widget.items.length, (i) => {...widget.items[i], '_idx': i.toString()});
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
          ? List.generate(widget.items.length, (i) => {...widget.items[i], '_idx': i.toString()})
          : widget.items.asMap().entries
              .where((e) => (e.value['name'] ?? '').toLowerCase().contains(q))
              .map((e) => {...e.value, '_idx': e.key.toString()})
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final s = S.of(context);

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(widget.title, style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _filtered.isEmpty
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 0),
                  child: _searchField(w, h, s),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🔍', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(s?.noItemsFound ?? 'कोई आइटम नहीं',
                            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 12),
                    child: _searchField(w, h, s),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _itemCard(w, _filtered[i], int.tryParse(_filtered[i]['_idx'] ?? '') ?? i),
                      childCount: _filtered.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _searchField(double w, double h, S? s) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFF2E7D32).withValues(alpha: 0.30), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w500, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: s?.searchFertilizersHint ?? 'खोजें...',
          hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: w * 0.038),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white, size: w * 0.06),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear_rounded, color: Colors.white70, size: w * 0.05),
                  onPressed: () { _searchController.clear(); _onSearch(''); },
                ),
              IconButton(
                icon: Icon(_isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: _isListening ? Colors.red.shade200 : Colors.white, size: w * 0.06),
                onPressed: _listen,
              ),
            ],
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.04),
        ),
      ),
    );
  }

  Widget _itemCard(double w, Map<String, String> item, int originalIndex) {
    final colors = _cardColors[originalIndex % _cardColors.length];
    final card = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors[0], colors[1]],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.30), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item['image'] ?? '', style: TextStyle(fontSize: w * 0.1)),
          const SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.025),
            child: Text(
              item['name'] ?? '',
              style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w700, color: Colors.white),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
    if (widget.onItemTap != null) {
      return GestureDetector(
        onTap: () => widget.onItemTap!(originalIndex),
        child: card,
      );
    }
    return card;
  }
}
