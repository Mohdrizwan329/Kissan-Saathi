import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:indian_farmer/Data/Tool_Data.dart';
import 'package:indian_farmer/Model/Tool_Model.dart';
import 'package:indian_farmer/View/Tools/Tool_List_Screen.dart';
import 'package:indian_farmer/View/Tools/Tool_Detail_Screen.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class ToolCategoryScreen extends StatefulWidget {
  const ToolCategoryScreen({super.key});

  @override
  State<ToolCategoryScreen> createState() => _ToolCategoryScreenState();
}

class _ToolCategoryScreenState extends State<ToolCategoryScreen> {
  static const _cream = Color(0xFFE8F5E9);

  static const _cardColors = [
    [Color(0xFFE65100), Color(0xFFFFA726)],
    [Color(0xFF558B2F), Color(0xFF9CCC65)],
    [Color(0xFF4E342E), Color(0xFF8D6E63)],
    [Color(0xFF00695C), Color(0xFF26A69A)],
    [Color(0xFFF57F17), Color(0xFFFFCA28)],
    [Color(0xFF1B5E20), Color(0xFF43A047)],
  ];

  final List<ToolCategory> _categories = ToolData.getAllCategories();
  List<ToolInfo> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() { _isSearching = false; _searchResults = []; });
      return;
    }
    final lowerQuery = query.toLowerCase();
    final allTools = ToolData.getAllTools();
    setState(() {
      _isSearching = true;
      _searchResults = allTools.where((tool) =>
          tool.name.toLowerCase().contains(lowerQuery) ||
          tool.nameHindi.contains(lowerQuery) ||
          tool.description.toLowerCase().contains(lowerQuery) ||
          tool.descriptionHindi.contains(lowerQuery)).toList();
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
          _onSearch(result.recognizedWords);
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
    final s = S.of(context);
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(s?.toolGuideTitle ?? 'Tool Guide',
            style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true, elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 12),
              child: _searchField(w, h, s),
            ),
          ),
          if (_isSearching) ..._buildSearchSlivers(w, h, isHindi, s)
          else _buildCategorySliver(w, h, isHindi),
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

  Widget _buildCategorySliver(double w, double h, bool isHindi) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _categoryCard(context, _categories[index], index, w, h, isHindi),
          childCount: _categories.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1,
        ),
      ),
    );
  }

  List<Widget> _buildSearchSlivers(double w, double h, bool isHindi, S? s) {
    if (_searchResults.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
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
      ];
    }
    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _searchCard(context, _searchResults[index], index, w, h, isHindi),
            childCount: _searchResults.length,
          ),
        ),
      ),
    ];
  }

  Widget _categoryCard(BuildContext context, ToolCategory category, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToolListScreen(category: category))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors[0], colors[1]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            category.icon.startsWith('http')
                ? Padding(
                    padding: EdgeInsets.all(w * 0.025),
                    child: CachedNetworkImage(
                      imageUrl: category.icon,
                      placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      errorWidget: (_, __, ___) => Icon(Icons.build_rounded, color: Colors.white, size: w * 0.1),
                      fit: BoxFit.contain,
                    ),
                  )
                : Text(category.icon, style: TextStyle(fontSize: w * 0.1)),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? category.nameHindi : category.name,
                style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.w700, color: Colors.white),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: h * 0.005),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${category.tools.length} ${isHindi ? "औजार" : "tools"}',
                style: GoogleFonts.poppins(fontSize: w * 0.026, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchCard(BuildContext context, ToolInfo tool, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors[0], colors[1]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.035),
          child: Row(
            children: [
              tool.image.startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: CachedNetworkImage(
                        imageUrl: tool.image,
                        width: w * 0.14, height: w * 0.14,
                        placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        errorWidget: (_, __, ___) => Icon(Icons.build_rounded, color: Colors.white),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Text(tool.image, style: TextStyle(fontSize: w * 0.07)),
              SizedBox(width: w * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? tool.nameHindi : tool.name,
                        style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white)),
                    if (isHindi)
                      Text(tool.name,
                          style: GoogleFonts.poppins(fontSize: w * 0.033, color: Colors.white70)),
                    SizedBox(height: h * 0.004),
                    Text(isHindi ? tool.priceRangeHindi : tool.priceRange,
                        style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: w * 0.04, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
