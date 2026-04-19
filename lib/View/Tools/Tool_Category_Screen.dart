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
  static const _orange = Color(0xFFE65100);
  static const _cream = Color(0xFFF6F4EE);

  static const _cardColors = [
    [Color(0xFFE65100), Color(0xFFFFA726)],
    [Color(0xFF6D4C41), Color(0xFFBCAAA4)],
    [Color(0xFF43A047), Color(0xFF81C784)],
    [Color(0xFF1E88E5), Color(0xFF90CAF9)],
    [Color(0xFF8E24AA), Color(0xFFCE93D8)],
    [Color(0xFF00897B), Color(0xFF80CBC4)],
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
                cursorColor: _orange,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: s?.searchToolsHint ?? 'औजार खोजें...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: w * 0.038),
                  prefixIcon: Icon(Icons.search_rounded, color: _orange, size: w * 0.06),
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
                            color: _isListening ? Colors.red : _orange, size: w * 0.06),
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
            child: _isSearching
                ? _buildSearchResults(w, h, isHindi, s)
                : _buildCategoryGrid(w, h, isHindi),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(double w, double h, bool isHindi) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.88,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) => _categoryCard(context, _categories[index], index, w, h, isHindi),
    );
  }

  Widget _categoryCard(BuildContext context, ToolCategory category, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToolListScreen(category: category))),
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
                  colors: [colors[0].withValues(alpha: 0.18), colors[1].withValues(alpha: 0.30)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: colors[0].withValues(alpha: 0.40), width: 1.5),
              ),
              child: category.icon.startsWith('http')
                  ? Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: CachedNetworkImage(
                        imageUrl: category.icon,
                        placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: colors[0])),
                        errorWidget: (_, __, ___) => Icon(Icons.build_rounded, color: colors[0], size: w * 0.08),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(child: Text(category.icon, style: TextStyle(fontSize: w * 0.09))),
            ),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? category.nameHindi : category.name,
                style: GoogleFonts.poppins(fontSize: w * 0.04, fontWeight: FontWeight.w700, color: Colors.black87),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: h * 0.005),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colors[0].withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${category.tools.length} ${isHindi ? "औजार" : "tools"}',
                style: GoogleFonts.poppins(fontSize: w * 0.026, fontWeight: FontWeight.w600, color: colors[0]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(double w, double h, bool isHindi, S? s) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔧', style: TextStyle(fontSize: w * 0.15)),
            const SizedBox(height: 12),
            Text(s?.noToolsFound ?? 'कोई औजार नहीं मिला',
                style: GoogleFonts.poppins(fontSize: w * 0.045, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) => _searchCard(context, _searchResults[index], index, w, h, isHindi),
    );
  }

  Widget _searchCard(BuildContext context, ToolInfo tool, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: EdgeInsets.all(w * 0.035),
          child: Row(
            children: [
              Container(
                width: w * 0.14, height: w * 0.14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [colors[0].withValues(alpha: 0.18), colors[1].withValues(alpha: 0.30)]),
                  shape: BoxShape.circle,
                ),
                child: tool.image.startsWith('http')
                    ? Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: CachedNetworkImage(
                          imageUrl: tool.image,
                          placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: colors[0])),
                          errorWidget: (_, __, ___) => Icon(Icons.build_rounded, color: colors[0]),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Center(child: Text(tool.image, style: TextStyle(fontSize: w * 0.07))),
              ),
              SizedBox(width: w * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? tool.nameHindi : tool.name,
                        style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.black87)),
                    if (isHindi)
                      Text(tool.name,
                          style: GoogleFonts.poppins(fontSize: w * 0.033, color: Colors.grey.shade500)),
                    SizedBox(height: h * 0.004),
                    Text(isHindi ? tool.priceRangeHindi : tool.priceRange,
                        style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600, color: colors[0])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: w * 0.04, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
