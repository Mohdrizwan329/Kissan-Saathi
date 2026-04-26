import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:indian_farmer/Model/Tool_Model.dart';
import 'package:indian_farmer/View/Tools/Tool_Detail_Screen.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class ToolListScreen extends StatefulWidget {
  final ToolCategory category;
  const ToolListScreen({super.key, required this.category});

  @override
  State<ToolListScreen> createState() => _ToolListScreenState();
}

class _ToolListScreenState extends State<ToolListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<ToolInfo> _filtered;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  static const _cardColors = [
    [Color(0xFFE65100), Color(0xFFFFA726)],   // orange
    [Color(0xFF558B2F), Color(0xFF9CCC65)],   // lime green
    [Color(0xFF4E342E), Color(0xFF8D6E63)],   // brown
    [Color(0xFF00695C), Color(0xFF26A69A)],   // teal
    [Color(0xFFF57F17), Color(0xFFFFCA28)],   // golden
    [Color(0xFF1B5E20), Color(0xFF43A047)],   // dark green
    [Color(0xFF4E342E), Color(0xFFA1887F)],   // earth brown
    [Color(0xFF33691E), Color(0xFF8BC34A)],   // crop green
    [Color(0xFFE65100), Color(0xFFFFA726)],   // orange
    [Color(0xFF00695C), Color(0xFF4DB6AC)],   // deep teal
    [Color(0xFF558B2F), Color(0xFF9CCC65)],   // lime green
    [Color(0xFF4E342E), Color(0xFF8D6E63)],   // brown
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.category.tools);
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
          ? List.from(widget.category.tools)
          : widget.category.tools.where((t) => t.name.toLowerCase().contains(q) || t.nameHindi.contains(query.trim())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final s = S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? widget.category.nameHindi : widget.category.name,
            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true, elevation: 0,
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
                        Text('🔧', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(s?.noToolsFound ?? 'कोई औजार नहीं मिला',
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
                      (ctx, i) => _toolCard(ctx, _filtered[i], i, w, h, isHindi),
                      childCount: _filtered.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1,
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
        style: GoogleFonts.poppins(fontSize: w * 0.042, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.transparent,
          hintText: s?.searchToolsHint ?? 'औजार खोजें...',
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

  Widget _toolCard(BuildContext context, ToolInfo tool, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool))),
      child: Container(
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
            Text(tool.image, style: TextStyle(fontSize: w * 0.1)),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? tool.nameHindi : tool.name,
                style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w700, color: Colors.white),
                textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isHindi)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Text(tool.name,
                    style: GoogleFonts.poppins(fontSize: w * 0.03, color: Colors.white70),
                    textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ),
    );
  }
}
