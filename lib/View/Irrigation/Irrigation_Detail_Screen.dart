import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/Model/Irrigation_Model.dart';
import 'package:indian_farmer/l10n/s.dart';

class IrrigationDetailScreen extends StatefulWidget {
  final IrrigationInfo method;
  const IrrigationDetailScreen({super.key, required this.method});

  @override
  State<IrrigationDetailScreen> createState() => _IrrigationDetailScreenState();
}

class _IrrigationDetailScreenState extends State<IrrigationDetailScreen> {
  static const _blue1 = Color(0xFF01579B);
  static const _blue2 = Color(0xFF29B6F6);
  static const _cream = Color(0xFFE8F5E9);

  late final FlutterTts _tts;
  String? _playingCardTitle;
  int _highlightStart = -1;
  int _highlightEnd = -1;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initTts());
  }

  Future<void> _initTts() async {
    try {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.allowBluetooth],
      );
    } catch (_) {}
    _tts.setProgressHandler((text, start, end, word) {
      if (mounted) setState(() { _highlightStart = start; _highlightEnd = end; });
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
    });
  }

  @override
  void dispose() {
    _tts.stop().catchError((_) {});
    super.dispose();
  }

  Future<void> _toggleAudio(String cardTitle, String content, bool isHindi) async {
    if (_playingCardTitle == cardTitle) {
      await _tts.stop().catchError((_) {});
      if (mounted) setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
      return;
    }
    await _tts.stop().catchError((_) {});
    try {
      await _tts.setLanguage(isHindi ? 'hi-IN' : 'en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      if (mounted) setState(() { _playingCardTitle = cardTitle; _highlightStart = -1; _highlightEnd = -1; });
      await _tts.speak(content);
    } catch (_) {
      if (mounted) setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final s = S.of(context);

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _blue1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? widget.method.nameHindi : widget.method.name,
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_blue1, _blue2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, _blue1.withValues(alpha: 0.75)],
                      ),
                    ),
                  ),
                  Center(child: Text(widget.method.image, style: TextStyle(fontSize: w * 0.28))),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Column(
                children: [
                  Row(
                    children: [
                      _chip(Icons.water_drop_rounded,
                          (isHindi ? widget.method.waterEfficiencyHindi : widget.method.waterEfficiency).split('(').first.trim(),
                          _blue1, w),
                      SizedBox(width: w * 0.02),
                      _chip(Icons.currency_rupee_rounded,
                          (isHindi ? widget.method.costHindi : widget.method.cost).split('-').first.trim(),
                          const Color(0xFF2E7D32), w),
                    ],
                  ),
                  SizedBox(height: w * 0.04),

                  _infoCard(Icons.info_outline_rounded, s?.detailAbout ?? 'About',
                      isHindi ? widget.method.descriptionHindi : widget.method.description,
                      const Color(0xFF1565C0), w, isHindi),
                  _infoCard(Icons.handyman_rounded, s?.detailHowToUse ?? 'How to Use',
                      isHindi ? widget.method.howToUseHindi : widget.method.howToUse,
                      const Color(0xFF2E7D32), w, isHindi, initiallyExpanded: true),
                  _infoCard(Icons.thumb_up_rounded, s?.detailAdvantages ?? 'Advantages',
                      isHindi ? widget.method.advantagesHindi : widget.method.advantages,
                      const Color(0xFF00695C), w, isHindi),
                  _infoCard(Icons.thumb_down_rounded, s?.detailDisadvantages ?? 'Disadvantages',
                      isHindi ? widget.method.disadvantagesHindi : widget.method.disadvantages,
                      const Color(0xFFE53935), w, isHindi),
                  _infoCard(Icons.agriculture_rounded, s?.detailSuitableCrops ?? 'Suitable Crops',
                      isHindi ? widget.method.suitableCropsHindi : widget.method.suitableCrops,
                      const Color(0xFFE65100), w, isHindi),
                  _infoCard(Icons.water_rounded, s?.detailWaterEfficiency ?? 'Water Efficiency',
                      isHindi ? widget.method.waterEfficiencyHindi : widget.method.waterEfficiency,
                      const Color(0xFF0288D1), w, isHindi),
                  _infoCard(Icons.currency_rupee_rounded, s?.detailCost ?? 'Cost',
                      isHindi ? widget.method.costHindi : widget.method.cost,
                      const Color(0xFF6A1B9A), w, isHindi),

                  SizedBox(height: w * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color, double w) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.025),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: w * 0.045),
            SizedBox(width: w * 0.015),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(fontSize: w * 0.028, fontWeight: FontWeight.w600, color: color),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String content, Color color, double w, bool isHindi,
      {bool initiallyExpanded = false}) {
    final isPlaying = _playingCardTitle == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.20), width: 1),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          leading: Container(
            width: w * 0.11, height: w * 0.11,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.28)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            ),
            child: Icon(icon, color: color, size: w * 0.055),
          ),
          title: Text(title,
              style: GoogleFonts.poppins(fontSize: w * 0.038, fontWeight: FontWeight.w600, color: Colors.black87)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: color.withValues(alpha: 0.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleAudio(title, content, isHindi),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.014),
                          decoration: BoxDecoration(
                            color: isPlaying ? color : color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                                  color: isPlaying ? Colors.white : color, size: w * 0.045),
                              SizedBox(width: w * 0.015),
                              Text(isPlaying ? 'Stop' : 'Listen',
                                  style: GoogleFonts.poppins(fontSize: w * 0.03, fontWeight: FontWeight.w600,
                                      color: isPlaying ? Colors.white : color)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.02),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.035),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.18)),
                    ),
                    child: isPlaying
                        ? _highlightedText(content, w, color)
                        : Text(content,
                            style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.black87, height: 1.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightedText(String content, double w, Color color) {
    if (_highlightStart < 0 || _highlightEnd < 0 || _highlightEnd > content.length) {
      return Text(content,
          style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.black87, height: 1.6));
    }
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: w * 0.035, color: Colors.black87, height: 1.6),
        children: [
          TextSpan(text: content.substring(0, _highlightStart)),
          TextSpan(
            text: content.substring(_highlightStart, _highlightEnd),
            style: GoogleFonts.poppins(fontSize: w * 0.035, color: color,
                fontWeight: FontWeight.bold, backgroundColor: color.withValues(alpha: 0.15), height: 1.6),
          ),
          TextSpan(text: content.substring(_highlightEnd)),
        ],
      ),
    );
  }
}
