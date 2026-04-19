import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class MandiBhavPage extends StatefulWidget {
  const MandiBhavPage({super.key});

  @override
  State<MandiBhavPage> createState() => _MandiBhavPageState();
}

class _MandiBhavPageState extends State<MandiBhavPage> {
  // Register free at data.gov.in to get your own API key
  static const _apiKey = '579b464db66ec23bdd0000011e2e762459bc4bb855a866ef69f35381';
  static const _resourceId = '9ef84268-d588-465a-a308-a864a43d0070';

  static const _states = [
    {'name': 'Uttar Pradesh', 'hindi': 'उत्तर प्रदेश'},
    {'name': 'Punjab', 'hindi': 'पंजाब'},
    {'name': 'Haryana', 'hindi': 'हरियाणा'},
    {'name': 'Maharashtra', 'hindi': 'महाराष्ट्र'},
    {'name': 'Madhya Pradesh', 'hindi': 'मध्य प्रदेश'},
    {'name': 'Rajasthan', 'hindi': 'राजस्थान'},
    {'name': 'Bihar', 'hindi': 'बिहार'},
    {'name': 'Gujarat', 'hindi': 'गुजरात'},
    {'name': 'Andhra Pradesh', 'hindi': 'आंध्र प्रदेश'},
    {'name': 'Karnataka', 'hindi': 'कर्नाटक'},
  ];

  static const _emojiMap = {
    'wheat': '🌾', 'paddy': '🌾', 'rice': '🍚', 'maize': '🌽',
    'onion': '🧅', 'potato': '🥔', 'tomato': '🍅', 'garlic': '🧄',
    'mustard': '🌼', 'soybean': '🫘', 'gram': '🫘', 'groundnut': '🥜',
    'cotton': '🌿', 'sugarcane': '🎋', 'mango': '🥭', 'banana': '🍌',
    'apple': '🍎', 'cauliflower': '🥦', 'cabbage': '🥬', 'carrot': '🥕',
    'brinjal': '🍆', 'chilli': '🌶️', 'ginger': '🫚', 'turmeric': '🌱',
    'arhar': '🫘', 'moong': '🫘', 'urad': '🫘', 'barley': '🌾',
    'jowar': '🌾', 'bajra': '🌾', 'peas': '🫛', 'coriander': '🌿',
    'cumin': '🌿', 'fennel': '🌿', 'lentil': '🫘',
  };

  static const _colorList = [
    Color(0xFF1565C0), Color(0xFF2E7D32), Color(0xFFE65100),
    Color(0xFF6A1B9A), Color(0xFF00695C), Color(0xFF5D4037),
    Color(0xFF0288D1), Color(0xFFF9A825), Color(0xFFE53935),
    Color(0xFF283593), Color(0xFF558B2F), Color(0xFFAD1457),
  ];

  int _selectedState = 0;
  List<Map<String, dynamic>> _prices = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  String _getEmoji(String commodity) {
    final lower = commodity.toLowerCase();
    for (final entry in _emojiMap.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return '🌱';
  }

  Color _getColor(String commodity) =>
      _colorList[commodity.length % _colorList.length];

  Future<void> _fetchPrices() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final stateName = _states[_selectedState]['name']!;
      final uri = Uri.parse(
        'https://api.data.gov.in/resource/$_resourceId'
        '?api-key=$_apiKey&format=json&limit=50'
        '&filters[state]=${Uri.encodeComponent(stateName)}',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = List<Map<String, dynamic>>.from(data['records'] ?? []);
        if (mounted) setState(() { _prices = records; _loading = false; });
      } else {
        if (mounted) setState(() { _error = 'Server error: ${response.statusCode}'; _loading = false; });
      }
    } catch (_) {
      if (mounted) setState(() { _error = 'इंटरनेट कनेक्शन जांचें'; _loading = false; });
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
        title: Text(isHindi ? 'मंडी भाव' : 'Mandi Prices',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _fetchPrices,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store_rounded, color: Color(0xFF2E7D32), size: 16),
                    const SizedBox(width: 6),
                    Text(isHindi ? 'राज्य चुनें' : 'Select State',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, color: Color(0xFF2E7D32), size: 8),
                          const SizedBox(width: 4),
                          Text(isHindi ? 'लाइव डेटा' : 'Live Data',
                              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _states.length,
                    itemBuilder: (_, i) {
                      final sel = _selectedState == i;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedState = i);
                          _fetchPrices();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: sel ? const Color(0xFF2E7D32) : const Color(0xFFF6F4EE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: sel ? const Color(0xFF2E7D32) : Colors.grey.shade300),
                          ),
                          child: Text(
                            isHindi ? _states[i]['hindi']! : _states[i]['name']!,
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : Colors.grey.shade600),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(isHindi ? 'फसल / मंडी' : 'Crop / Market',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
                Expanded(flex: 2, child: Text(isHindi ? 'न्यूनतम' : 'Min',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(isHindi ? 'मॉडल' : 'Modal',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(isHindi ? 'अधिकतम' : 'Max',
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70), textAlign: TextAlign.center)),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : _error != null
                    ? _buildError(isHindi)
                    : _prices.isEmpty
                        ? _buildEmpty(isHindi)
                        : RefreshIndicator(
                            onRefresh: _fetchPrices,
                            color: const Color(0xFF2E7D32),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                              itemCount: _prices.length,
                              itemBuilder: (_, i) => _priceRow(_prices[i], isHindi),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('❌', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(_error!,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.red.shade400)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchPrices,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: Text(isHindi ? 'पुनः प्रयास करें' : 'Retry',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(bool isHindi) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌾', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(isHindi ? 'इस राज्य का डेटा उपलब्ध नहीं' : 'No data available for this state',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _priceRow(Map<String, dynamic> item, bool isHindi) {
    final commodity = (item['commodity'] ?? '') as String;
    final market = (item['market'] ?? '') as String;
    final minPrice = item['min_price'] ?? '-';
    final maxPrice = item['max_price'] ?? '-';
    final modalPrice = item['modal_price'] ?? '-';
    final date = (item['arrival_date'] ?? '') as String;
    final emoji = _getEmoji(commodity);
    final color = _getColor(commodity);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.28)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(commodity,
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(market,
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (date.isNotEmpty)
                        Text(date, style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey.shade400)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('₹$minPrice',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade400),
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text('₹$modalPrice',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black87),
                textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text('₹$maxPrice',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32)),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
