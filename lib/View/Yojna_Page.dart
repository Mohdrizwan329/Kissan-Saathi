import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class YojnaPage extends StatefulWidget {
  const YojnaPage({super.key});

  @override
  State<YojnaPage> createState() => _YojnaPageState();
}

class _YojnaPageState extends State<YojnaPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _schemes = [];
  List<Map<String, dynamic>> _announcements = [];
  bool _loadingSchemes = true;
  bool _loadingNews = true;
  String? _schemesError;
  String? _newsError;
  TabController? _tabController;

  // Same API key used in MandiBhavPage
  static const _dataGovKey = '579b464db66ec23bdd0000011e2e762459bc4bb855a866ef69f35381';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSchemes();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Parses RSS XML directly without third-party service
  List<Map<String, dynamic>> _parseRssXml(String xml) {
    final items = <Map<String, dynamic>>[];
    final itemRe = RegExp(r'<item>([\s\S]*?)</item>');
    final cdataRe = RegExp(r'<!\[CDATA\[([\s\S]*?)\]\]>');

    String extractTag(String src, String tag) {
      final m = RegExp('<$tag[^>]*?>([\\s\\S]*?)</$tag>').firstMatch(src);
      if (m == null) return '';
      final raw = m.group(1) ?? '';
      final cdata = cdataRe.firstMatch(raw);
      return (cdata?.group(1) ?? raw).replaceAll(RegExp(r'<[^>]*>'), '').trim();
    }

    for (final m in itemRe.allMatches(xml)) {
      final block = m.group(1) ?? '';
      final title = extractTag(block, 'title');
      final link  = extractTag(block, 'link');
      final desc  = extractTag(block, 'description');
      final date  = extractTag(block, 'pubDate');
      if (title.isNotEmpty) {
        items.add({'title': title, 'link': link, 'description': desc, 'pubDate': date});
      }
    }
    return items;
  }

  // Tab 1: Active Schemes via data.gov.in (Agriculture schemes dataset)
  Future<void> _loadSchemes() async {
    if (!mounted) return;
    setState(() { _loadingSchemes = true; _schemesError = null; });
    try {
      // data.gov.in — Central Sector Scheme of Agri & Allied activities
      final uri = Uri.parse(
        'https://api.data.gov.in/resource/35985678-0d79-46b4-9ed6-6f13308a1d24'
        '?api-key=$_dataGovKey&format=json&limit=20',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final records = (data['records'] as List? ?? []);
        if (records.isNotEmpty) {
          final schemes = records.map<Map<String, dynamic>>((r) => {
            'title': r['scheme_name'] ?? r['schemename'] ?? r['name'] ?? '',
            'description': r['scheme_description'] ?? r['description'] ?? r['objective'] ?? '',
            'link': r['url'] ?? r['link'] ?? '',
            'pubDate': r['year'] ?? r['launched_year'] ?? '',
            'ministry': r['ministry'] ?? r['department'] ?? '',
          }).where((s) => (s['title'] as String).isNotEmpty).toList();
          if (mounted) setState(() { _schemes = schemes; _loadingSchemes = false; });
          return;
        }
      }
      // Fallback: Google News RSS for scheme-related news
      await _loadSchemesFromNews();
    } catch (_) {
      await _loadSchemesFromNews();
    }
  }

  Future<void> _loadSchemesFromNews() async {
    try {
      final uri = Uri.parse(
        'https://news.google.com/rss/search'
        '?q=India+government+farmer+scheme+yojana+kisan+announced'
        '&hl=en-IN&gl=IN&ceid=IN:en',
      );
      final res = await http.get(uri, headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile)',
      }).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200 && res.body.contains('<item>')) {
        final items = _parseRssXml(res.body);
        if (mounted) setState(() { _schemes = items; _loadingSchemes = false; });
        return;
      }
      if (mounted) setState(() { _schemesError = 'योजनाएं लोड नहीं हुईं (${res.statusCode})'; _loadingSchemes = false; });
    } catch (e) {
      if (mounted) setState(() { _schemesError = 'Error: $e'; _loadingSchemes = false; });
    }
  }

  // Tab 2: Live announcements via Google News RSS
  Future<void> _loadAnnouncements() async {
    if (!mounted) return;
    setState(() { _loadingNews = true; _newsError = null; });
    try {
      final uri = Uri.parse(
        'https://news.google.com/rss/search'
        '?q=India+agriculture+farmer+kisan+krishi+news'
        '&hl=en-IN&gl=IN&ceid=IN:en',
      );
      final res = await http.get(uri, headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile)',
      }).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200 && res.body.contains('<item>')) {
        final items = _parseRssXml(res.body);
        if (mounted) setState(() { _announcements = items; _loadingNews = false; });
        return;
      }
      if (mounted) setState(() { _newsError = 'डेटा लोड नहीं हुआ (${res.statusCode})'; _loadingNews = false; });
    } catch (e) {
      if (mounted) setState(() { _newsError = 'Error: $e'; _loadingNews = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? 'सरकारी योजनाएं' : 'Govt Schemes',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController!,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: isHindi ? 'सक्रिय योजनाएं' : 'Active Schemes'),
            Tab(text: isHindi ? 'ताज़ा घोषणाएं' : 'Live Updates'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () { _loadSchemes(); _loadAnnouncements(); },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController!,
        children: [
          _buildTab(
            loading: _loadingSchemes,
            error: _schemesError,
            items: _schemes,
            onRetry: _loadSchemes,
            emptyMsg: isHindi ? 'कोई योजना नहीं मिली' : 'No schemes found',
            headerTitle: isHindi ? 'चालू सरकारी योजनाएं' : 'Active Govt Schemes',
            headerSubtitle: isHindi ? '${_schemes.length} योजनाएं' : '${_schemes.length} schemes',
            headerIcon: '🏛️',
            buttonLabel: isHindi ? 'पूरा पढ़ें' : 'Read More',
            isHindi: isHindi,
          ),
          _buildTab(
            loading: _loadingNews,
            error: _newsError,
            items: _announcements,
            onRetry: _loadAnnouncements,
            emptyMsg: isHindi ? 'अभी कोई घोषणा नहीं' : 'No announcements right now',
            headerTitle: isHindi ? 'नवीनतम घोषणाएं' : 'Latest Announcements',
            headerSubtitle: isHindi ? 'Google News — Live' : 'Google News — Live',
            headerIcon: '📢',
            buttonLabel: isHindi ? 'पूरा पढ़ें' : 'Read Full Article',
            isHindi: isHindi,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required bool loading,
    required String? error,
    required List<Map<String, dynamic>> items,
    required Future<void> Function() onRetry,
    required String emptyMsg,
    required String headerTitle,
    required String headerSubtitle,
    required String headerIcon,
    required String buttonLabel,
    required bool isHindi,
  }) {
    if (loading) return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
    if (error != null) return _buildErrorWidget(error, onRetry, isHindi);
    if (items.isEmpty) return _buildEmptyWidget(emptyMsg);

    return RefreshIndicator(
      onRefresh: onRetry,
      color: const Color(0xFF2E7D32),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
        itemCount: items.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) return _buildHeader(title: headerTitle, subtitle: headerSubtitle, icon: headerIcon);
          return _itemCard(items[i - 1], buttonLabel, i - 1);
        },
      ),
    );
  }

  Widget _buildHeader({required String title, required String subtitle, required String icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                const SizedBox(width: 4),
                Text('LIVE', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _cardColors = [
    Color(0xFF1B5E20), Color(0xFF1565C0), Color(0xFFE53935),
    Color(0xFFE65100), Color(0xFF6A1B9A), Color(0xFF00695C),
    Color(0xFF5D4037), Color(0xFF0288D1), Color(0xFFF9A825),
  ];

  Widget _itemCard(Map<String, dynamic> item, String buttonLabel, int index) {
    final color = _cardColors[index % _cardColors.length];
    final title = (item['title'] ?? '') as String;
    final date  = (item['pubDate'] ?? '') as String;
    final link  = (item['link'] ?? '') as String;
    final desc  = (item['description'] ?? '') as String;
    final formattedDate = date.length >= 10 ? date.substring(0, 10) : date;

    return GestureDetector(
      onTap: () async {
        if (link.isNotEmpty) {
          try { await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication); } catch (_) {}
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: color, size: 6),
                        const SizedBox(width: 4),
                        Text('GOV', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: color)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today_rounded, size: 11, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(formattedDate, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade400)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(desc,
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600, height: 1.5),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.75)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 13),
                        const SizedBox(width: 6),
                        Text(buttonLabel,
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message, Future<void> Function() onRetry, bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📡', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.red.shade400),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
