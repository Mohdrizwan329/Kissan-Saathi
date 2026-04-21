import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/Data/Pesticide_Data.dart';
import 'package:indian_farmer/l10n/s.dart';

class PesticideDetailScreen extends StatefulWidget {
  final PesticideItem pesticide;
  const PesticideDetailScreen({super.key, required this.pesticide});

  @override
  State<PesticideDetailScreen> createState() => _PesticideDetailScreenState();
}

class _PesticideDetailScreenState extends State<PesticideDetailScreen> {
  static const _purple1 = Color(0xFF6A1B9A);
  static const _purple2 = Color(0xFFAB47BC);
  static const _cream = Color(0xFFF6F4EE);

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
    final p = widget.pesticide;

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _purple1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? p.nameHindi : p.name,
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_purple1, _purple2],
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
                        Text(p.image, style: TextStyle(fontSize: w * 0.28)),
                        const SizedBox(height: 8),
                        Text(
                          '${p.name} · ${p.nameHindi}',
                          style: GoogleFonts.poppins(fontSize: w * 0.03, color: Colors.white70),
                        ),
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
                  _infoCard(context, Icons.info_outline_rounded,
                      S.of(context)?.detailAbout ?? 'About',
                      isHindi ? p.descriptionHindi : p.description,
                      const Color(0xFF1565C0), w, isHindi),

                  _infoCard(context, Icons.bug_report_rounded,
                      isHindi ? 'लक्षित कीट/रोग' : 'Target Pests & Diseases',
                      isHindi ? p.targetPestsHindi : p.targetPests,
                      const Color(0xFF6A1B9A), w, isHindi),

                  _infoCard(context, Icons.handyman_rounded,
                      isHindi ? 'कैसे इस्तेमाल करें' : 'How to Use',
                      isHindi ? p.howToUseHindi : p.howToUse,
                      const Color(0xFF2E7D32), w, isHindi),

                  _infoCard(context, Icons.scale_rounded,
                      isHindi ? 'मात्रा / खुराक' : 'Dosage',
                      isHindi ? p.dosageHindi : p.dosage,
                      const Color(0xFF0288D1), w, isHindi),

                  _infoCard(context, Icons.timer_rounded,
                      isHindi ? 'सुरक्षा अंतराल (PHI)' : 'Safety Interval (PHI)',
                      isHindi ? p.safetyIntervalHindi : p.safetyInterval,
                      const Color(0xFFFF8F00), w, isHindi),

                  _infoCard(context, Icons.warning_amber_rounded,
                      isHindi ? 'सावधानियां' : 'Precautions',
                      isHindi ? p.precautionsHindi : p.precautions,
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

  Widget _infoCard(BuildContext context, IconData icon, String title, String content,
      Color color, double w, bool isHindi) {
    final isPlaying = _playingCardTitle == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
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
