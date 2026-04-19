import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'Product_Detail_Page.dart' show ProductDetailPage;
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final List<Map<String, dynamic>> data = [
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Dhan',
      'subtitle': 'Rice',
      'color': Colors.amber[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Gehu',
      'subtitle': 'Wheat',
      'color': Colors.green[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/3049/3049827.png',
      'title': 'Muli',
      'subtitle': 'Radish',
      'color': Colors.grey[300],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10497/10497524.png',
      'title': 'Matar',
      'subtitle': 'Peas',
      'color': Colors.green[200],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10497/10497526.png',
      'title': 'Tamater',
      'subtitle': 'Tomato',
      'color': Colors.red[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10497/10497498.png',
      'title': 'Mirch',
      'subtitle': 'Chilli',
      'color': Colors.green[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/415/415733.png',
      'title': 'Baingan',
      'subtitle': 'Eggplant',
      'color': Colors.deepPurple[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1117/1117470.png',
      'title': 'Dhaniya',
      'subtitle': 'Coriander',
      'color': Colors.green[50],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/685/685352.png',
      'title': 'Sarson',
      'subtitle': 'Mustard',
      'color': Colors.yellow[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1145/1145811.png',
      'title': 'Ganna',
      'subtitle': 'Sugarcane',
      'color': Colors.brown[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/135/135620.png',
      'title': 'Gajar',
      'subtitle': 'Carrot',
      'color': Colors.orange[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/848/848001.png',
      'title': 'Adrak',
      'subtitle': 'Ginger',
      'color': Colors.brown[50],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10497/10497517.png',
      'title': 'Haldi',
      'subtitle': 'Turmeric',
      'color': Colors.yellow[200],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/9908/9908361.png',
      'title': 'Soyabeen',
      'subtitle': 'Soybean',
      'color': Colors.green[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Dhan',
      'subtitle': 'Basmoti',
      'color': Colors.blue[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Makka',
      'subtitle': 'Hybrid',
      'color': Colors.orange[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Chana',
      'subtitle': 'Desi',
      'color': Colors.brown[100],
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/10912/10912889.png',
      'title': 'Arhar',
      'subtitle': 'Organic',
      'color': Colors.red[100],
    },

    {
      'image': 'https://cdn-icons-png.flaticon.com/512/1691/1691522.png',
      'title': 'Masroom',
      'subtitle': 'Mushroom',
      'color': Colors.grey[200],
    },
  ];

  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    filteredData = List.from(data);
    _speech = stt.SpeechToText();
  }

  void _filterData(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredData =
          data.where((item) {
            final title = item['title']?.toLowerCase() ?? '';
            final subtitle = item['subtitle']?.toLowerCase() ?? '';
            return title.contains(lowerQuery) || subtitle.contains(lowerQuery);
          }).toList();
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            String spokenText = result.recognizedWords;
            searchController.text = spokenText;
            _filterData(spokenText);
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          'Product Page',
          style: GoogleFonts.poppins(
            fontSize: w * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(w * 0.04),
              child: TextField(
                controller: searchController,
                onChanged: _filterData,
                style: GoogleFonts.poppins(
                  fontSize: w * 0.042,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search crops...",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: w * 0.038,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.green,
                    size: w * 0.06,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: _isListening ? Colors.red : Colors.green,
                      size: w * 0.06,
                    ),
                    onPressed: _listen,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w * 0.04),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: h * 0.02,
                    horizontal: w * 0.04,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredData.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: w * 0.18,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            "No crops found",
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.045,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Try a different search term",
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.035,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: h * 0.02,
                        crossAxisSpacing: w * 0.04,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return _buildProductCard(item, w, h);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item, double w, double h) {
    return GestureDetector(
      onTap: () {
        if (item['title'] == 'Dhan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductDetailPage()),
          );
        }
      },
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(w * 0.04),
        child: Container(
          padding: EdgeInsets.all(w * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(w * 0.04),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w * 0.22,
                height: w * 0.22,
                decoration: BoxDecoration(
                  color: item['color'],
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(w * 0.03),
                  child: CachedNetworkImage(
                    imageUrl: item['image'].toString(),
                    placeholder:
                        (context, url) => CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.error, color: Colors.red),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: h * 0.015),
              Text(
                item['title'],
                style: GoogleFonts.poppins(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item['subtitle'],
                style: GoogleFonts.poppins(
                  fontSize: w * 0.035,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
