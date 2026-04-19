import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:indian_farmer/Model/Irrigation_Model.dart';
import 'package:indian_farmer/View/Irrigation/Irrigation_Detail_Screen.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class IrrigationListScreen extends StatefulWidget {
  final IrrigationCategory category;
  const IrrigationListScreen({super.key, required this.category});

  @override
  State<IrrigationListScreen> createState() => _IrrigationListScreenState();
}

class _IrrigationListScreenState extends State<IrrigationListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<IrrigationInfo> _filtered;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  static const _blue = Color(0xFF01579B);
  static const _blueLight = Color(0xFF29B6F6);
  static const _cream = Color(0xFFF6F4EE);

  @override
  void initState() {
    super.initState();
    _filtered = List.from(widget.category.methods);
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
          ? List.from(widget.category.methods)
          : widget.category.methods.where((m) => m.name.toLowerCase().contains(q) || m.nameHindi.contains(query.trim())).toList();
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
                style: GoogleFonts.poppins(fontSize: w * 0.042, color: Colors.black87),
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
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('💧', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(s?.noIrrigationFound ?? 'कोई सिंचाई विधि नहीं',
                            style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) => _methodCard(ctx, _filtered[i], w, h, isHindi),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _methodCard(BuildContext context, IrrigationInfo method, double w, double h, bool isHindi) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IrrigationDetailScreen(method: method))),
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
                  colors: [_blue.withValues(alpha: 0.12), _blueLight.withValues(alpha: 0.2)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: _blue.withValues(alpha: 0.25), width: 1.5),
              ),
              child: Center(child: Text(method.image, style: TextStyle(fontSize: w * 0.1))),
            ),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? method.nameHindi : method.name,
                style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w700, color: Colors.black87),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isHindi)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Text(method.name,
                    style: GoogleFonts.poppins(fontSize: w * 0.03, color: Colors.grey.shade500),
                    textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            SizedBox(height: h * 0.006),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                (isHindi ? method.waterEfficiencyHindi : method.waterEfficiency).split('(').first.trim(),
                style: GoogleFonts.poppins(fontSize: w * 0.026, fontWeight: FontWeight.w600, color: _blue),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
