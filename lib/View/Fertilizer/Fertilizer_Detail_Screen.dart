import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/Data/Fertilizer_Data.dart';
import 'package:indian_farmer/l10n/s.dart';

class FertilizerDetailScreen extends StatefulWidget {
  final FertilizerItem fertilizer;
  const FertilizerDetailScreen({super.key, required this.fertilizer});

  @override
  State<FertilizerDetailScreen> createState() => _FertilizerDetailScreenState();
}

class _FertilizerDetailScreenState extends State<FertilizerDetailScreen> {
  static const _brown1 = Color(0xFF4E342E);
  static const _brown2 = Color(0xFF8D6E63);
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

  Future<void> _toggleAudio(BuildContext context, String cardTitle, String content, bool isHindi) async {
    final messenger = ScaffoldMessenger.of(context);
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
    } catch (e) {
      if (mounted) {
        setState(() { _playingCardTitle = null; _highlightStart = -1; _highlightEnd = -1; });
        messenger.showSnackBar(SnackBar(content: Text('Audio unavailable: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final f = widget.fertilizer;

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _brown1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? f.nameHindi : f.name,
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_brown1, _brown2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -30, top: -30,
                    child: Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle),
                    ),
                  ),
                  Positioned(
                    left: -20, bottom: 20,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(f.image, style: TextStyle(fontSize: w * 0.28)),
                      ],
                    ),
                  ),
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
                      _chip(Icons.science_rounded,
                          isHindi ? f.nutrientContentHindi : f.nutrientContent,
                          _brown1, w),
                    ],
                  ),
                  SizedBox(height: w * 0.04),

                  _infoCard(context, Icons.info_outline_rounded,
                      S.of(context)?.detailAbout ?? 'About',
                      isHindi ? f.descriptionHindi : f.description,
                      const Color(0xFF1565C0), w, isHindi),

                  _infoCard(context, Icons.science_rounded,
                      isHindi ? 'पोषक तत्व' : 'Nutrient Content',
                      isHindi ? f.nutrientContentHindi : f.nutrientContent,
                      const Color(0xFF4E342E), w, isHindi),

                  _infoCard(context, Icons.handyman_rounded,
                      isHindi ? 'कैसे इस्तेमाल करें' : 'How to Use',
                      isHindi ? f.howToUseHindi : f.howToUse,
                      const Color(0xFF2E7D32), w, isHindi),

                  _infoCard(context, Icons.access_time_rounded,
                      isHindi ? 'कब डालें' : 'When to Apply',
                      isHindi ? f.whenToApplyHindi : f.whenToApply,
                      const Color(0xFFFF8F00), w, isHindi),

                  _infoCard(context, Icons.scale_rounded,
                      isHindi ? 'मात्रा / खुराक' : 'Dosage',
                      isHindi ? f.dosageHindi : f.dosage,
                      const Color(0xFF0288D1), w, isHindi),

                  _infoCard(context, Icons.eco_rounded,
                      isHindi ? 'फ़ायदे' : 'Benefits',
                      isHindi ? f.benefitsHindi : f.benefits,
                      const Color(0xFF388E3C), w, isHindi),

                  _infoCard(context, Icons.warning_amber_rounded,
                      isHindi ? 'सावधानियां' : 'Precautions',
                      isHindi ? f.precautionsHindi : f.precautions,
                      const Color(0xFFE53935), w, isHindi),

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
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: w * 0.028, fontWeight: FontWeight.w600, color: color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, IconData icon, String title, String content,
      Color color, double w, bool isHindi) {
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
                        onTap: () => _toggleAudio(context, title, content, isHindi),
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
