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

  static const _green = Color(0xFF2E7D32);
  static const _cream = Color(0xFFF6F4EE);

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
                  filled: true,
                  fillColor: Colors.white,
                  hintText: s?.searchFertilizersHint ?? 'खोजें...',
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
                        Text('🔍', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(s?.noItemsFound ?? 'कोई आइटम नहीं',
                            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final item = _filtered[i];
                      final originalIndex = int.tryParse(item['_idx'] ?? '') ?? i;
                      return _itemCard(w, item, originalIndex);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard(double w, Map<String, String> item, int originalIndex) {
    final card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w * 0.22,
            height: w * 0.22,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF2E7D32).withValues(alpha: 0.12), const Color(0xFF66BB6A).withValues(alpha: 0.2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.25), width: 1.5),
            ),
            child: Center(child: Text(item['image'] ?? '', style: TextStyle(fontSize: w * 0.1))),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item['name'] ?? '',
              style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w600, color: Colors.black87),
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
