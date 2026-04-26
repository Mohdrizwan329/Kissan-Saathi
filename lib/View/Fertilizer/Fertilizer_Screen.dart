import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:indian_farmer/Data/Fertilizer_Data.dart';
import 'package:indian_farmer/View/Fertilizer/Fertilizer_Detail_Screen.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class FertilizerScreen extends StatefulWidget {
  const FertilizerScreen({super.key});

  @override
  State<FertilizerScreen> createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  static const _cream = Color(0xFFE8F5E9);

  static List<Color> _colorsForFertilizer(String name) {
    const nitrogen = [Color(0xFF1565C0), Color(0xFF42A5F5)];
    const phosphorus = [Color(0xFF6A1B9A), Color(0xFFBA68C8)];
    const potassium = [Color(0xFF2E7D32), Color(0xFF66BB6A)];
    const organic = [Color(0xFF4E342E), Color(0xFF8D6E63)];
    const micro = [Color(0xFF00695C), Color(0xFF4DB6AC)];
    const secondary = [Color(0xFFFF8F00), Color(0xFFFFD54F)];
    const bio = [Color(0xFF1B5E20), Color(0xFF81C784)];
    const special = [Color(0xFF006064), Color(0xFF4DD0E1)];

    switch (name) {
      case 'Urea':
      case 'Calcium Ammonium Nitrate':
      case 'Ammonium Chloride':
      case 'Nano Urea':
      case 'Ammonium Nitrate':
      case 'Slow Release Urea':
        return nitrogen;
      case 'DAP':
      case 'Triple Super Phosphate':
      case 'Rock Phosphate':
      case 'Bone Meal':
      case 'Monoammonium Phosphate':
        return phosphorus;
      case 'MOP':
      case 'Sulphate of Potash':
      case 'Potassium Nitrate':
      case 'Wood Ash':
        return potassium;
      case 'Compost':
      case 'Vermicompost':
      case 'Farm Yard Manure':
      case 'Green Manure':
      case 'Neem Cake':
      case 'Blood Meal':
      case 'Fish Meal':
      case 'Fish Emulsion':
      case 'Mustard Cake':
      case 'Groundnut Cake':
      case 'Castor Cake':
      case 'Karanj Cake':
      case 'Poultry Manure':
      case 'Cotton Seed Cake':
      case 'Linseed Cake':
      case 'Sesame Cake':
      case 'Sunflower Cake':
      case 'Coconut Cake':
      case 'Soybean Cake':
      case 'Biogas Slurry':
      case 'Press Mud':
      case 'Sheep and Goat Manure':
      case 'Coir Pith':
      case 'Vermiwash':
        return organic;
      case 'Zinc Sulphate':
      case 'Ferrous Sulphate':
      case 'Manganese Sulphate':
      case 'Copper Sulphate':
      case 'Borax':
      case 'Sodium Molybdate':
      case 'Iron Chelate':
      case 'Micronutrient Mixture':
      case 'Zinc EDTA Chelate':
        return micro;
      case 'SSP':
      case 'Ammonium Sulphate':
      case 'Gypsum':
      case 'Calcium Nitrate':
      case 'Magnesium Sulphate':
      case 'Elemental Sulphur':
      case 'Dolomite':
      case 'Agricultural Lime':
      case 'Calcium Chloride':
      case 'Magnesium Nitrate':
        return secondary;
      case 'Rhizobium Biofertilizer':
      case 'PSB Biofertilizer':
      case 'Azospirillum Biofertilizer':
      case 'Azotobacter Biofertilizer':
      case 'Mycorrhiza':
      case 'Potassium Mobilizing Bacteria':
      case 'Azolla':
      case 'Blue Green Algae':
      case 'Trichoderma':
      case 'Pseudomonas fluorescens':
        return bio;
      case 'Humic Acid':
      case 'Seaweed Extract':
      case 'Fulvic Acid':
      case 'Amino Acid Fertilizer':
      case 'Potassium Humate':
      case 'Water Soluble Fertilizers':
        return special;
      case 'Nano DAP':
        return phosphorus;
      case 'Biochar':
      case 'Silica Fertilizer':
        return secondary;
      default:
        return organic;
    }
  }

  final List<FertilizerItem> _allFertilizers = FertilizerData.getAllFertilizers();
  List<FertilizerItem> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allFertilizers);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterData(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _allFertilizers.where((item) {
        return item.name.toLowerCase().contains(q) ||
            item.nameHindi.contains(q) ||
            item.description.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _listen() async {
    if (!_isListening) {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          _searchController.text = result.recognizedWords;
          _filterData(result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'खाद' : 'Fertilizers',
          style: GoogleFonts.poppins(
              fontSize: w * 0.05,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _filtered.isEmpty
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 0),
                  child: _searchField(w, h, isHindi),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🌿', style: TextStyle(fontSize: w * 0.15)),
                        const SizedBox(height: 12),
                        Text(
                          isHindi ? 'कोई खाद नहीं मिली' : 'No fertilizers found',
                          style: GoogleFonts.poppins(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.04, w * 0.04, 12),
                    child: _searchField(w, h, isHindi),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _fertCard(ctx, _filtered[i], w, h, isHindi),
                      childCount: _filtered.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _searchField(double w, double h, bool isHindi) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.30),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterData,
        style: GoogleFonts.poppins(fontSize: w * 0.042, color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: isHindi ? 'खाद खोजें...' : 'Search fertilizers...',
          hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: w * 0.038),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.white, size: w * 0.06),
          suffixIcon: IconButton(
            icon: Icon(
                _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
                color: _isListening ? Colors.red.shade200 : Colors.white,
                size: w * 0.06),
            onPressed: _listen,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.04),
        ),
      ),
    );
  }

  Widget _fertCard(BuildContext context, FertilizerItem item, double w,
      double h, bool isHindi) {
    final colors = _colorsForFertilizer(item.name);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FertilizerDetailScreen(fertilizer: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors[0], colors[1]],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: colors[0].withValues(alpha: 0.30),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.image, style: TextStyle(fontSize: w * 0.1)),
            SizedBox(height: h * 0.012),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.025),
              child: Text(
                isHindi ? item.nameHindi : item.name,
                style: GoogleFonts.poppins(
                    fontSize: w * 0.037,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
