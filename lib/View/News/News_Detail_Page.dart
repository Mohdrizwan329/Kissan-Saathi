import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;
  const NewsDetailPage({super.key, required this.article});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.length > 10 ? raw.substring(0, 10) : raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final w = MediaQuery.of(context).size.width;
    final hasImage = (article['image'] ?? '').toString().isNotEmpty;

    return Scaffold(
      backgroundColor: _cream,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: hasImage ? 260 : 160,
            pinned: true,
            backgroundColor: _green1,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasImage)
                    Image.network(
                      article['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _gradientBg(),
                    )
                  else
                    _gradientBg(),
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  // Source + title overlay
                  Positioned(
                    left: 16, right: 16, bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((article['source'] ?? '').toString().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _green2,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              article['source'],
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          article['title'] ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta row
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 16, color: _green2),
                        const SizedBox(width: 6),
                        Text(
                          _formatDate(article['published_at'] ?? ''),
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(isHindi ? '🌾 कृषि समाचार' : '🌾 Agriculture News',
                              style: GoogleFonts.poppins(fontSize: 11, color: _green1, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title (full)
                  Text(
                    article['title'] ?? '',
                    style: GoogleFonts.poppins(fontSize: w * 0.047, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.35),
                  ),
                  const SizedBox(height: 14),

                  // Description
                  if ((article['description'] ?? '').toString().isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4, height: 18,
                                decoration: BoxDecoration(color: _green2, borderRadius: BorderRadius.circular(2)),
                              ),
                              const SizedBox(width: 8),
                              Text(isHindi ? 'सारांश' : 'Summary', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article['description'],
                            style: GoogleFonts.poppins(fontSize: w * 0.038, color: Colors.black87, height: 1.7),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Read full article button
                  if ((article['url'] ?? '').toString().isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _launchUrl(article['url']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [_green1, _green2]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(isHindi ? 'पूरी खबर पढ़ें' : 'Read Full Article',
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientBg() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [_green1, _green2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Center(child: Text('📰', style: TextStyle(fontSize: 64))),
  );
}
