import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FasalDoctorPage extends StatefulWidget {
  const FasalDoctorPage({super.key});
  @override
  State<FasalDoctorPage> createState() => _FasalDoctorPageState();
}

class _FasalDoctorPageState extends State<FasalDoctorPage>
    with SingleTickerProviderStateMixin {
  static const _red = Color(0xFFB71C1C);
  static const _cream = Color(0xFFE8F5E9);

  late TabController _tab;
  String _searchQuery = '';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _tab.dispose();
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
          setState(() => _searchQuery = result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  static const _diseases = [
    {
      'name': 'झुलसा रोग', 'nameEn': 'Blight',
      'icon': '🟤', 'color': 0xFF795548,
      'crops': 'धान, आलू, टमाटर', 'cropsEn': 'Rice, Potato, Tomato',
      'symptoms': 'पत्तियों पर भूरे/काले धब्बे, सूखना, झड़ना',
      'symptomsEn': 'Brown/black spots on leaves, drying, falling',
      'cause': 'फफूंद (Helminthosporium, Alternaria)', 'causeEn': 'Fungus (Helminthosporium, Alternaria)',
      'treatment': 'मैंकोज़ेब 2.5 ग्राम/लीटर + प्रोपिकोनाज़ोल 1 मिली/लीटर छिड़काव',
      'treatmentEn': 'Spray Mancozeb 2.5 g/L + Propiconazole 1 ml/L',
      'prevention': 'रोगरोधी किस्में, जल निकासी, बीज उपचार',
      'preventionEn': 'Resistant varieties, drainage, seed treatment',
    },
    {
      'name': 'पाउडरी मिल्ड्यू', 'nameEn': 'Powdery Mildew',
      'icon': '⬜', 'color': 0xFF546E7A,
      'crops': 'गेहूं, मटर, सरसों', 'cropsEn': 'Wheat, Pea, Mustard',
      'symptoms': 'पत्तियों पर सफेद पाउडर जैसी परत',
      'symptomsEn': 'White powder-like coating on leaves',
      'cause': 'फफूंद (Erysiphe sp.)', 'causeEn': 'Fungus (Erysiphe sp.)',
      'treatment': 'कार्बेन्डाजिम 1 ग्राम/लीटर या सल्फर 3 ग्राम/लीटर',
      'treatmentEn': 'Carbendazim 1 g/L or Sulphur 3 g/L',
      'prevention': 'हवादार खेत, पानी पत्तियों पर न डालें',
      'preventionEn': 'Airy field, avoid water on leaves',
    },
    {
      'name': 'रस्ट (गेरुआ)', 'nameEn': 'Rust',
      'icon': '🟠', 'color': 0xFFE65100,
      'crops': 'गेहूं, जौ, सरसों', 'cropsEn': 'Wheat, Barley, Mustard',
      'symptoms': 'पत्तियों पर नारंगी/भूरे जंग जैसे धब्बे',
      'symptomsEn': 'Orange/brown rust-like spots on leaves',
      'cause': 'फफूंद (Puccinia sp.)', 'causeEn': 'Fungus (Puccinia sp.)',
      'treatment': 'प्रोपिकोनाज़ोल 25 EC — 1 मिली/लीटर पानी',
      'treatmentEn': 'Propiconazole 25 EC — 1 ml/L water',
      'prevention': 'रोगरोधी किस्में, देर से न बोएं',
      'preventionEn': 'Resistant varieties, avoid late sowing',
    },
    {
      'name': 'उकठा (विल्ट)', 'nameEn': 'Wilt',
      'icon': '🥀', 'color': 0xFF880E4F,
      'crops': 'अरहर, चना, टमाटर', 'cropsEn': 'Pigeon pea, Chickpea, Tomato',
      'symptoms': 'पौधा अचानक मुरझाना, जड़ काली पड़ना',
      'symptomsEn': 'Plant suddenly wilts, roots turn black',
      'cause': 'फफूंद/जीवाणु (Fusarium, Rhizoctonia)',
      'causeEn': 'Fungus/Bacteria (Fusarium, Rhizoctonia)',
      'treatment': 'ट्राइकोडर्मा 5 ग्राम/किलो बीज उपचार + कार्बेन्डाजिम',
      'treatmentEn': 'Trichoderma 5 g/kg seed treatment + Carbendazim',
      'prevention': 'फसल चक्र, जल निकासी, रोगरोधी किस्में',
      'preventionEn': 'Crop rotation, drainage, resistant varieties',
    },
    {
      'name': 'मोज़ेक वायरस', 'nameEn': 'Mosaic Virus',
      'icon': '🟩', 'color': 0xFF2E7D32,
      'crops': 'मूंग, उड़द, गन्ना, ककड़ी', 'cropsEn': 'Moong, Urad, Sugarcane, Cucumber',
      'symptoms': 'पत्तियों पर हरे-पीले धब्बे, उपज घटना',
      'symptomsEn': 'Green-yellow mosaic on leaves, yield loss',
      'cause': 'विषाणु (Virus) — माहू द्वारा फैलता है', 'causeEn': 'Virus — spread by aphids',
      'treatment': 'रोगग्रस्त पौधे निकालें, इमिडाक्लोप्रिड 0.5 मिली/लीटर',
      'treatmentEn': 'Remove infected plants, Imidacloprid 0.5 ml/L',
      'prevention': 'माहू नियंत्रण, रोगरोधी किस्में',
      'preventionEn': 'Aphid control, resistant varieties',
    },
    {
      'name': 'आर्द्र गलन', 'nameEn': 'Damping Off',
      'icon': '🌱', 'color': 0xFF4E342E,
      'crops': 'सब्जियाँ, तंबाकू, मिर्च', 'cropsEn': 'Vegetables, Tobacco, Chilli',
      'symptoms': 'अंकुरण के बाद पौधे जमीन पर गिरना',
      'symptomsEn': 'Seedlings collapse after germination',
      'cause': 'फफूंद (Pythium, Rhizoctonia)', 'causeEn': 'Fungus (Pythium, Rhizoctonia)',
      'treatment': 'थीरम 3 ग्राम/किलो बीज उपचार, ट्राइकोडर्मा मिट्टी उपचार',
      'treatmentEn': 'Thiram 3 g/kg seed treatment, Trichoderma soil treatment',
      'prevention': 'अधिक सिंचाई न करें, अच्छी जल निकासी',
      'preventionEn': 'Avoid excess irrigation, good drainage',
    },
  ];

  static const _pests = [
    {
      'name': 'तना छेदक', 'nameEn': 'Stem Borer',
      'icon': '🐛', 'color': 0xFF795548,
      'crops': 'धान, मक्का, गन्ना', 'cropsEn': 'Rice, Maize, Sugarcane',
      'symptoms': 'तने में छेद, Dead Heart, पत्तियाँ सूखना',
      'symptomsEn': 'Holes in stem, dead heart, drying leaves',
      'treatment': 'कार्बोफ्यूरान 3G — 6 किलो/एकड़ या क्लोरपाइरीफॉस',
      'treatmentEn': 'Carbofuran 3G — 6 kg/acre or Chlorpyrifos',
      'bio': 'ट्राइकोग्रामा परजीवी + फेरोमोन ट्रैप',
      'bioEn': 'Trichogramma parasite + Pheromone trap',
    },
    {
      'name': 'माहू (एफिड)', 'nameEn': 'Aphid',
      'icon': '🦟', 'color': 0xFF1B5E20,
      'crops': 'सरसों, गेहूं, सब्जियाँ', 'cropsEn': 'Mustard, Wheat, Vegetables',
      'symptoms': 'पत्तियाँ मुड़ना, चिपचिपा रस, पीलापन',
      'symptomsEn': 'Curling leaves, sticky honeydew, yellowing',
      'treatment': 'इमिडाक्लोप्रिड 0.5 मिली/लीटर या डाइमेथोएट',
      'treatmentEn': 'Imidacloprid 0.5 ml/L or Dimethoate',
      'bio': 'नीम तेल 5 मिली/लीटर + लेडीबर्ड भृंग संरक्षण',
      'bioEn': 'Neem oil 5 ml/L + ladybird beetle conservation',
    },
    {
      'name': 'सफेद मक्खी', 'nameEn': 'Whitefly',
      'icon': '🪰', 'color': 0xFF0277BD,
      'crops': 'कपास, टमाटर, मिर्च', 'cropsEn': 'Cotton, Tomato, Chilli',
      'symptoms': 'पत्तियों के नीचे सफेद कीट, पत्तियाँ पीली',
      'symptomsEn': 'White insects below leaves, yellow leaves',
      'treatment': 'थायोमेथोक्सैम 0.2 ग्राम/लीटर या स्पाइनोसैड',
      'treatmentEn': 'Thiamethoxam 0.2 g/L or Spinosad',
      'bio': 'पीला चिपचिपा जाल, नीम तेल',
      'bioEn': 'Yellow sticky trap, neem oil',
    },
    {
      'name': 'फल छेदक', 'nameEn': 'Fruit Borer',
      'icon': '🍅', 'color': 0xFFE53935,
      'crops': 'टमाटर, मिर्च, बैंगन', 'cropsEn': 'Tomato, Chilli, Brinjal',
      'symptoms': 'फलों में छेद, अंदर से खाना, गिरना',
      'symptomsEn': 'Holes in fruit, internal feeding, fruit drop',
      'treatment': 'स्पिनोसैड 0.5 मिली/लीटर या इंडोक्साकार्ब',
      'treatmentEn': 'Spinosad 0.5 ml/L or Indoxacarb',
      'bio': 'फेरोमोन ट्रैप 4–5/एकड़ + NPV वायरस',
      'bioEn': 'Pheromone trap 4–5/acre + NPV virus',
    },
    {
      'name': 'दीमक', 'nameEn': 'Termite',
      'icon': '🐜', 'color': 0xFF6D4C41,
      'crops': 'गन्ना, मक्का, गेहूं', 'cropsEn': 'Sugarcane, Maize, Wheat',
      'symptoms': 'जड़ें खाली, पौधा अचानक मरना, मिट्टी की सुरंगें',
      'symptomsEn': 'Hollow roots, sudden plant death, mud tunnels',
      'treatment': 'क्लोरपाइरीफॉस 2.5 मिली/लीटर सिंचाई के साथ',
      'treatmentEn': 'Chlorpyrifos 2.5 ml/L with irrigation',
      'bio': 'नीम की खल 100 किलो/एकड़ मिट्टी में मिलाएं',
      'bioEn': 'Mix neem cake 100 kg/acre in soil',
    },
    {
      'name': 'टिड्डी', 'nameEn': 'Locust',
      'icon': '🦗', 'color': 0xFF827717,
      'crops': 'सभी फसलें', 'cropsEn': 'All crops',
      'symptoms': 'झुंड में हमला, पत्तियाँ चट, अचानक नुकसान',
      'symptomsEn': 'Swarm attack, leaves eaten, sudden damage',
      'treatment': 'मैलाथियान 5% धूल 10 किलो/एकड़ या क्लोरपाइरीफॉस',
      'treatmentEn': 'Malathion 5% dust 10 kg/acre or Chlorpyrifos',
      'bio': 'Locust Watch SMS अलर्ट: 1800-180-1551',
      'bioEn': 'Locust Watch SMS alert: 1800-180-1551',
    },
  ];

  static const _weeds = [
    {
      'name': 'मोथा (नटग्रास)', 'nameEn': 'Nutgrass',
      'icon': '🌾', 'color': 0xFF558B2F,
      'crops': 'धान, गन्ना, सब्जियाँ', 'cropsEn': 'Rice, Sugarcane, Vegetables',
      'control': 'मेट्रिब्यूजिन 70WP — 250 ग्राम/एकड़ (बुवाई के 2–3 दिन बाद)',
      'controlEn': 'Metribuzin 70WP — 250 g/acre (2–3 days after sowing)',
    },
    {
      'name': 'जंगली जई', 'nameEn': 'Wild Oat',
      'icon': '🌿', 'color': 0xFF33691E,
      'crops': 'गेहूं, जौ', 'cropsEn': 'Wheat, Barley',
      'control': 'क्लोडिनाफॉप 15WP — 400 ग्राम/एकड़',
      'controlEn': 'Clodinafop 15WP — 400 g/acre',
    },
    {
      'name': 'बथुआ', 'nameEn': 'Bathua (Chenopodium)',
      'icon': '🍃', 'color': 0xFF2E7D32,
      'crops': 'गेहूं, सरसों', 'cropsEn': 'Wheat, Mustard',
      'control': '2,4-D सोडियम साल्ट — 625 ग्राम/एकड़',
      'controlEn': '2,4-D Sodium Salt — 625 g/acre',
    },
    {
      'name': 'श्यामा (जंगली सोरघम)', 'nameEn': 'Johnsongrass',
      'icon': '🌱', 'color': 0xFF1B5E20,
      'crops': 'मक्का, गन्ना, सोयाबीन', 'cropsEn': 'Maize, Sugarcane, Soybean',
      'control': 'टेम्बोट्रियोन 42SC — 120 मिली/एकड़',
      'controlEn': 'Tembotrione 42SC — 120 ml/acre',
    },
  ];

  List _filteredDiseases(bool isHindi) {
    if (_searchQuery.isEmpty) return _diseases;
    return _diseases.where((d) {
      final name = (isHindi ? d['name'] : d['nameEn']) as String;
      final crops = (isHindi ? d['crops'] : d['cropsEn']) as String;
      return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          crops.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List _filteredPests(bool isHindi) {
    if (_searchQuery.isEmpty) return _pests;
    return _pests.where((p) {
      final name = (isHindi ? p['name'] : p['nameEn']) as String;
      final crops = (isHindi ? p['crops'] : p['cropsEn']) as String;
      return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          crops.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isHindi ? 'फसल डॉक्टर' : 'Crop Doctor',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF388E3C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: isHindi ? 'रोग' : 'Diseases'),
            Tab(text: isHindi ? 'कीट' : 'Pests'),
            Tab(text: isHindi ? 'खरपतवार' : 'Weeds'),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          final isHindi = Localizations.localeOf(context).languageCode == 'hi';
          return NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: _searchField(),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tab,
              children: [
                _buildDiseases(isHindi),
                _buildPests(isHindi),
                _buildWeeds(isHindi),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchField() {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Container(
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
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: isHindi ? 'फसल या बीमारी खोजें...' : 'Search crop or disease...',
          hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Colors.white70, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: _isListening ? Colors.red.shade200 : Colors.white,
                  size: 22,
                ),
                onPressed: _listen,
              ),
            ],
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDiseases(bool isHindi) {
    final list = _filteredDiseases(isHindi);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🔬', isHindi ? 'लक्षण देखकर रोग पहचानें और सही उपचार करें' : 'Identify disease by symptoms and apply correct treatment', _red),
          const SizedBox(height: 14),
          if (list.isEmpty)
            _emptyState(isHindi)
          else
            ...list.map((d) => _diseaseCard(d, isHindi)),
        ],
      ),
    );
  }

  Widget _diseaseCard(Map d, bool isHindi) {
    final color = Color(d['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(d['icon'] as String, style: const TextStyle(fontSize: 22))),
          ),
          title: Text(isHindi ? d['name'] as String : d['nameEn'] as String,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          subtitle: Text(isHindi ? d['crops'] as String : d['cropsEn'] as String,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                children: [
                  _row('⚠️', isHindi ? 'लक्षण' : 'Symptoms', isHindi ? d['symptoms'] as String : d['symptomsEn'] as String),
                  _row('🦠', isHindi ? 'कारण' : 'Cause', isHindi ? d['cause'] as String : d['causeEn'] as String),
                  _row('💊', isHindi ? 'उपचार' : 'Treatment', isHindi ? d['treatment'] as String : d['treatmentEn'] as String),
                  _row('🛡️', isHindi ? 'बचाव' : 'Prevention', isHindi ? d['prevention'] as String : d['preventionEn'] as String),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPests(bool isHindi) {
    final list = _filteredPests(isHindi);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🐛', isHindi ? 'कीटों की पहचान कर सही उपाय अपनाएं' : 'Identify pests and apply correct measures', const Color(0xFF795548)),
          const SizedBox(height: 14),
          if (list.isEmpty)
            _emptyState(isHindi)
          else
            ...list.map((p) => _pestCard(p, isHindi)),
        ],
      ),
    );
  }

  Widget _pestCard(Map p, bool isHindi) {
    final color = Color(p['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(p['icon'] as String, style: const TextStyle(fontSize: 22))),
          ),
          title: Text(isHindi ? p['name'] as String : p['nameEn'] as String,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          subtitle: Text(isHindi ? p['crops'] as String : p['cropsEn'] as String,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                children: [
                  _row('⚠️', isHindi ? 'लक्षण' : 'Symptoms', isHindi ? p['symptoms'] as String : p['symptomsEn'] as String),
                  _row('💊', isHindi ? 'रासायनिक उपचार' : 'Chemical Treatment', isHindi ? p['treatment'] as String : p['treatmentEn'] as String),
                  _row('🌿', isHindi ? 'जैव नियंत्रण' : 'Bio Control', isHindi ? p['bio'] as String : p['bioEn'] as String),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeds(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('🌱', isHindi ? 'खरपतवार फसल का 30–50% उत्पादन घटा देते हैं' : 'Weeds reduce crop yield by 30–50%', const Color(0xFF2E7D32)),
          const SizedBox(height: 14),
          ..._weeds.map((w) => _weedCard(w, isHindi)),
          const SizedBox(height: 8),
          _weedTipsCard(isHindi),
        ],
      ),
    );
  }

  Widget _weedCard(Map w, bool isHindi) {
    final color = Color(w['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(w['icon'] as String, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isHindi ? w['name'] as String : w['nameEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                    Text(isHindi ? w['crops'] as String : w['cropsEn'] as String,
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _row('🧴', isHindi ? 'नियंत्रण' : 'Control', isHindi ? w['control'] as String : w['controlEn'] as String),
        ],
      ),
    );
  }

  Widget _weedTipsCard(bool isHindi) {
    final tips = isHindi
        ? ['खरपतवारनाशक बुवाई के 0–3 दिन बाद (Pre-emergence) सबसे प्रभावी', 'हाथ से निराई — बुवाई के 20–25 दिन बाद करें', 'फसल चक्र अपनाएं — एक ही खरपतवार बार-बार न आए', 'मल्चिंग — खरपतवार को 60–70% कम करता है']
        : ['Herbicide most effective 0–3 days after sowing (pre-emergence)', 'Hand weeding — do it 20–25 days after sowing', 'Adopt crop rotation — same weed won\'t repeat', 'Mulching — reduces weeds by 60–70%'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF388E3C).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? '💡 खरपतवार प्रबंधन के सुझाव' : '💡 Weed Management Tips',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1B5E20))),
          const SizedBox(height: 8),
          ...tips.map((t) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✅ ', style: TextStyle(fontSize: 13)),
                Expanded(child: Text(t, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _emptyState(bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(isHindi ? 'कोई परिणाम नहीं मिला' : 'No results found',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _row(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text('$label: ', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _infoCard(String icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4))),
        ],
      ),
    );
  }
}
