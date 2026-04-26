import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MausamPage extends StatefulWidget {
  const MausamPage({super.key});
  @override
  State<MausamPage> createState() => _MausamPageState();
}

class _MausamPageState extends State<MausamPage> {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  Map<String, dynamic>? _weather;
  bool _loading = true;
  String _error = '';
  final _cityController = TextEditingController(text: 'Delhi');
  String _city = 'Delhi';

  final _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _initSpeech();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize();
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      _city = _cityController.text.trim();
      if (_city.isNotEmpty) _fetchWeather();
    } else if (_speechAvailable) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _cityController.text = result.recognizedWords;
            if (result.finalResult) {
              _isListening = false;
              _city = result.recognizedWords;
              if (_city.isNotEmpty) _fetchWeather();
            }
          });
        },
      );
    }
  }

  Future<void> _fetchWeather() async {
    final isH = Localizations.localeOf(context).languageCode == 'hi';
    setState(() { _loading = true; _error = ''; });
    try {
      final uri = Uri.parse('https://wttr.in/${Uri.encodeComponent(_city)}?format=j1');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        setState(() { _weather = jsonDecode(res.body); _loading = false; });
      } else {
        setState(() { _error = isH ? 'मौसम डेटा उपलब्ध नहीं' : 'Weather data unavailable'; _loading = false; });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() { _error = isH ? 'इंटरनेट कनेक्शन जांचें' : 'Check internet connection'; _loading = false; });
    }
  }

  String _weatherIcon(String code) {
    final c = int.tryParse(code) ?? 0;
    if (c == 113) return '☀️';
    if (c == 116) return '⛅';
    if (c == 119 || c == 122) return '☁️';
    if ([143, 248, 260].contains(c)) return '🌫️';
    if ([176, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 317, 320, 323, 326].contains(c)) return '🌧️';
    if ([329, 332, 335, 338, 350, 362, 365, 368, 371, 374, 377].contains(c)) return '❄️';
    if ([389, 392, 395].contains(c)) return '⛈️';
    return '🌡️';
  }

  String _windDir(String dir) {
    final map = {'N': 'उत्तर', 'NE': 'उत्तर-पूर्व', 'E': 'पूर्व', 'SE': 'दक्षिण-पूर्व',
      'S': 'दक्षिण', 'SW': 'दक्षिण-पश्चिम', 'W': 'पश्चिम', 'NW': 'उत्तर-पश्चिम'};
    return map[dir] ?? dir;
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _green1,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isHindi ? 'मौसम जानकारी' : 'Weather',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(isHindi),
          Expanded(child: _loading ? _buildLoader() : _error.isNotEmpty ? _buildError() : _buildWeather(isHindi)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isHindi) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF2E7D32).withValues(alpha: 0.30), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: TextField(
          controller: _cityController,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: isHindi ? 'शहर का नाम लिखें...' : 'Enter city name...',
            hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
            prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.white, size: 22),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: _isListening ? Colors.red.shade200 : Colors.white,
                    size: 22,
                  ),
                  onPressed: _toggleListening,
                ),
                IconButton(
                  icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                  onPressed: () { _city = _cityController.text.trim(); _fetchWeather(); },
                ),
              ],
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          ),
          onSubmitted: (v) { _city = v.trim(); _fetchWeather(); },
        ),
      ),
    );
  }

  Widget _buildLoader() => const Center(child: CircularProgressIndicator(color: _green2));

  Widget _buildError() {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(_error, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600])),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchWeather,
            style: ElevatedButton.styleFrom(backgroundColor: _green2),
            child: Text(isHindi ? 'पुनः प्रयास' : 'Retry', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildWeather(bool isHindi) {
    final current = _weather!['current_condition']?[0] as Map?;
    final nearest = _weather!['nearest_area']?[0] as Map?;
    final weather3 = _weather!['weather'] as List?;
    if (current == null) return _buildError();

    final temp = current['temp_C'] ?? '--';
    final feelsLike = current['FeelsLikeC'] ?? '--';
    final humidity = current['humidity'] ?? '--';
    final windKmph = current['windspeedKmph'] ?? '--';
    final windDir = current['winddir16Point'] ?? '';
    final desc = isHindi ? (current['lang_hi']?[0]?['value'] ?? current['weatherDesc']?[0]?['value'] ?? '') : current['weatherDesc']?[0]?['value'] ?? '';
    final code = current['weatherCode'] ?? '113';
    final visibility = current['visibility'] ?? '--';
    final pressure = current['pressure'] ?? '--';
    final areaName = nearest?['areaName']?[0]?['value'] ?? _city;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCurrentCard(temp, feelsLike, desc, code, areaName, isHindi),
          const SizedBox(height: 14),
          _buildStatsRow(humidity, windKmph, windDir, visibility, pressure, isHindi),
          const SizedBox(height: 14),
          if (weather3 != null && weather3.isNotEmpty) _buildForecast(weather3, isHindi),
          const SizedBox(height: 14),
          _buildFarmingTips(temp is String ? (int.tryParse(temp) ?? 25) : (temp as int), isHindi),
        ],
      ),
    );
  }

  Widget _buildCurrentCard(temp, feelsLike, String desc, String code, String area, bool isHindi) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0288D1), Color(0xFF4FC3F7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF0288D1).withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(area, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Text(_weatherIcon(code), style: const TextStyle(fontSize: 72)),
          Text('$temp°C', style: GoogleFonts.poppins(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
          Text(desc, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white.withValues(alpha: 0.9))),
          const SizedBox(height: 8),
          Text(isHindi ? 'महसूस होता है: $feelsLike°C' : 'Feels like $feelsLike°C',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(humidity, windKmph, String windDir, visibility, pressure, bool isHindi) {
    final stats = [
      {'icon': '💧', 'label': isHindi ? 'नमी' : 'Humidity', 'value': '$humidity%'},
      {'icon': '💨', 'label': isHindi ? 'हवा' : 'Wind', 'value': '$windKmph km/h'},
      {'icon': '🧭', 'label': isHindi ? 'दिशा' : 'Direction', 'value': isHindi ? _windDir(windDir) : windDir},
      {'icon': '👁️', 'label': isHindi ? 'दृश्यता' : 'Visibility', 'value': '$visibility km'},
    ];
    return Row(
      children: stats.map((s) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFE3F2FD), Color(0xFFF3F9FF)]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.20)),
            boxShadow: [BoxShadow(color: const Color(0xFF0288D1).withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Text(s['icon'] as String, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(s['value'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
              Text(s['label'] as String, style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey[500])),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildForecast(List weather3, bool isHindi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFF3F9FF)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.20)),
        boxShadow: [BoxShadow(color: const Color(0xFF0288D1).withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '3 दिन का पूर्वानुमान' : '3-Day Forecast',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
          const SizedBox(height: 12),
          ...weather3.take(3).toList().asMap().entries.map((entry) {
            final i = entry.key;
            final day = entry.value as Map;
            final maxT = day['maxtempC'] ?? '--';
            final minT = day['mintempC'] ?? '--';
            final code = day['hourly']?[4]?['weatherCode'] ?? '113';
            final dayNames = isHindi ? ['आज', 'कल', 'परसों'] : ['Today', 'Tomorrow', 'Day After'];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 80, child: Text(dayNames[i], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600))),
                  Text(_weatherIcon(code.toString()), style: const TextStyle(fontSize: 24)),
                  const Spacer(),
                  Text('$minT°', style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue[400])),
                  const SizedBox(width: 8),
                  Text('$maxT°', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.orange[700])),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFarmingTips(int temp, bool isHindi) {
    String tip, icon;
    if (temp < 10) {
      icon = '🥶'; tip = isHindi ? 'ठंड से फसल बचाएं — पाले से सुरक्षा के लिए खेत में हल्की सिंचाई करें।' : 'Protect crops from frost — light irrigation helps prevent frost damage.';
    } else if (temp < 20) {
      icon = '🌿'; tip = isHindi ? 'रबी फसलों के लिए अनुकूल मौसम है। गेहूं, सरसों की देखभाल करें।' : 'Ideal weather for Rabi crops. Take care of wheat and mustard.';
    } else if (temp < 30) {
      icon = '☀️'; tip = isHindi ? 'सामान्य तापमान — सभी फसलों के लिए उचित है। नियमित सिंचाई करें।' : 'Normal temperature — suitable for all crops. Irrigate regularly.';
    } else if (temp < 40) {
      icon = '🌡️'; tip = isHindi ? 'गर्मी में सुबह या शाम को सिंचाई करें। फसलों को छाया दें।' : 'Irrigate in morning or evening in heat. Provide shade to crops.';
    } else {
      icon = '🔥'; tip = isHindi ? 'बहुत अधिक गर्मी! फसलों को बचाने के लिए दिन में 2-3 बार सिंचाई करें।' : 'Extreme heat! Irrigate 2-3 times daily to protect crops.';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _green2.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'किसान सलाह' : 'Farming Advice',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
                const SizedBox(height: 4),
                Text(tip, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
