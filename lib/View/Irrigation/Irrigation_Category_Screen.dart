import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:indian_farmer/Data/Irrigation_Data.dart';
import 'package:indian_farmer/Model/Irrigation_Model.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_List_Screen.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_Detail_Screen.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class IrrigationCategoryScreen extends StatefulWidget {
  const IrrigationCategoryScreen({super.key});

  @override
  State<IrrigationCategoryScreen> createState() => _IrrigationCategoryScreenState();
}

class _IrrigationCategoryScreenState extends State<IrrigationCategoryScreen> {
  static const _blue = Color(0xFF01579B);
  static const _cream = Color(0xFFF6F4EE);

  static const _cardColors = [
    [Color(0xFF01579B), Color(0xFF29B6F6)],
    [Color(0xFF00695C), Color(0xFF4DB6AC)],
    [Color(0xFF006064), Color(0xFF4DD0E1)],
    [Color(0xFF1A237E), Color(0xFF7986CB)],
    [Color(0xFF0288D1), Color(0xFF81D4FA)],
    [Color(0xFF00838F), Color(0xFF80DEEA)],
  ];

  final List<IrrigationCategory> _categories = IrrigationData.getAllCategories();
  List<IrrigationInfo> _searchResults = [];
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
    final allMethods = IrrigationData.getAllMethods();
    setState(() {
      _isSearching = true;
      _searchResults = allMethods.where((method) =>
          method.name.toLowerCase().contains(lowerQuery) ||
          method.nameHindi.contains(lowerQuery) ||
          method.description.toLowerCase().contains(lowerQuery) ||
          method.descriptionHindi.contains(lowerQuery)).toList();
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
        title: Text(s?.irrigationGuideTitle ?? 'Irrigation Guide',
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
                cursorColor: _blue,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  hintText: s?.searchIrrigationHint ?? 'सिंचाई खोजें...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: w * 0.038),
                  prefixIcon: Icon(Icons.search_rounded, color: _blue, size: w * 0.06),
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
                            color: _isListening ? Colors.red : _blue, size: w * 0.06),
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

  Widget _categoryCard(BuildContext context, IrrigationCategory category, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IrrigationListScreen(category: category))),
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
                        errorWidget: (_, __, ___) => Icon(Icons.water_drop_rounded, color: colors[0], size: w * 0.08),
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
                '${category.methods.length} ${isHindi ? "विधियाँ" : "methods"}',
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
            Text('💧', style: TextStyle(fontSize: w * 0.15)),
            const SizedBox(height: 12),
            Text(s?.noIrrigationFound ?? 'कोई सिंचाई विधि नहीं मिली',
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

  Widget _searchCard(BuildContext context, IrrigationInfo method, int index, double w, double h, bool isHindi) {
    final colors = _cardColors[index % _cardColors.length];
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IrrigationDetailScreen(method: method))),
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
                child: method.image.startsWith('http')
                    ? Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: CachedNetworkImage(
                          imageUrl: method.image,
                          placeholder: (_, __) => Center(child: CircularProgressIndicator(strokeWidth: 2, color: colors[0])),
                          errorWidget: (_, __, ___) => Icon(Icons.water_drop_rounded, color: colors[0]),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Center(child: Text(method.image, style: TextStyle(fontSize: w * 0.07))),
              ),
              SizedBox(width: w * 0.035),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? method.nameHindi : method.name,
                        style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.black87)),
                    if (isHindi)
                      Text(method.name,
                          style: GoogleFonts.poppins(fontSize: w * 0.033, color: Colors.grey.shade500)),
                    SizedBox(height: h * 0.004),
                    Text(isHindi ? method.waterEfficiencyHindi : method.waterEfficiency,
                        style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600, color: colors[0]),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
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
