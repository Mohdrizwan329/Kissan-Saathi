import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:indian_farmer/Model/Seed_Model.dart';
import 'package:indian_farmer/l10n/s.dart';

class SeedDetailScreen extends StatefulWidget {
  final SeedInfo seed;
  const SeedDetailScreen({super.key, required this.seed});

  @override
  State<SeedDetailScreen> createState() => _SeedDetailScreenState();
}

class _SeedDetailScreenState extends State<SeedDetailScreen> {
  static const _green1 = Color(0xFF2E7D32);
  static const _green2 = Color(0xFF66BB6A);
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
    final s = S.of(context);

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: _green1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isHindi ? widget.seed.nameHindi : widget.seed.name,
                style: GoogleFonts.poppins(fontSize: w * 0.042, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_green1, _green2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(right: -30, top: -30,
                    child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.07), shape: BoxShape.circle))),
                  Positioned(left: -20, bottom: 30,
                    child: Container(width: 110, height: 110,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle))),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.26, height: w * 0.26,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 2),
                          ),
                          child: widget.seed.image.startsWith('http')
                              ? Padding(
                                  padding: EdgeInsets.all(w * 0.04),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.seed.image,
                                    placeholder: (_, __) => const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    errorWidget: (_, __, ___) => const Icon(Icons.grass_rounded, color: Colors.white, size: 48),
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Center(child: Text(widget.seed.image, style: TextStyle(fontSize: w * 0.12))),
                        ),
                        const SizedBox(height: 8),
                        if (isHindi)
                          Text(widget.seed.name,
                              style: GoogleFonts.poppins(fontSize: w * 0.033, color: Colors.white70)),
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
                      _chip(Icons.wb_sunny_rounded,
                          isHindi ? widget.seed.seasonHindi : widget.seed.season,
                          _green1, w),
                      SizedBox(width: w * 0.02),
                      _chip(Icons.access_time_rounded,
                          isHindi ? widget.seed.sowingTimeHindi : widget.seed.sowingTime,
                          const Color(0xFFFF8F00), w),
                    ],
                  ),
                  SizedBox(height: w * 0.04),

                  _infoCard(context, Icons.info_outline_rounded, s?.detailAbout ?? 'About',
                      isHindi ? widget.seed.descriptionHindi : widget.seed.description,
                      const Color(0xFF1565C0), w, isHindi),
                  _infoCard(context, Icons.landscape_rounded, s?.detailFieldPreparation ?? 'Field Preparation',
                      isHindi ? widget.seed.fieldPreparationHindi : widget.seed.fieldPreparation,
                      const Color(0xFF5D4037), w, isHindi),
                  _infoCard(context, Icons.terrain_rounded, s?.detailSoilType ?? 'Soil Type',
                      isHindi ? widget.seed.soilTypeHindi : widget.seed.soilType,
                      const Color(0xFFE65100), w, isHindi),
                  _infoCard(context, Icons.scale_rounded, s?.detailSeedRate ?? 'Seed Rate',
                      isHindi ? widget.seed.seedRateHindi : widget.seed.seedRate,
                      const Color(0xFF00695C), w, isHindi),
                  _infoCard(context, Icons.agriculture_rounded, s?.detailSowingMethod ?? 'Sowing Method',
                      isHindi ? widget.seed.sowingMethodHindi : widget.seed.sowingMethod,
                      const Color(0xFF2E7D32), w, isHindi),
                  _infoCard(context, Icons.water_drop_rounded, s?.detailIrrigation ?? 'Irrigation',
                      isHindi ? widget.seed.irrigationHindi : widget.seed.irrigation,
                      const Color(0xFF0288D1), w, isHindi),
                  _infoCard(context, Icons.eco_rounded, s?.detailFertilizer ?? 'Fertilizer',
                      isHindi ? widget.seed.fertilizerHindi : widget.seed.fertilizer,
                      const Color(0xFF388E3C), w, isHindi),
                  _infoCard(context, Icons.bug_report_rounded, s?.detailPestControl ?? 'Pest Control',
                      isHindi ? widget.seed.pestControlHindi : widget.seed.pestControl,
                      const Color(0xFFE53935), w, isHindi),
                  _infoCard(context, Icons.medical_services_rounded, s?.detailDiseaseControl ?? 'Disease Control',
                      isHindi ? widget.seed.diseaseControlHindi : widget.seed.diseaseControl,
                      const Color(0xFF6A1B9A), w, isHindi),
                  _infoCard(context, Icons.content_cut_rounded, s?.detailHarvesting ?? 'Harvesting',
                      isHindi ? widget.seed.harvestingHindi : widget.seed.harvesting,
                      const Color(0xFFF9A825), w, isHindi),
                  _infoCard(context, Icons.bar_chart_rounded, s?.detailYield ?? 'Yield',
                      isHindi ? widget.seed.yieldHindi : widget.seed.yield,
                      const Color(0xFF283593), w, isHindi),

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
