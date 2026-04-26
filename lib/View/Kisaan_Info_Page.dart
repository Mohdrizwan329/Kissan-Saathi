import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:indian_farmer/Res/Const_Text_Style.dart';
import 'package:indian_farmer/View/Information_Page.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class KisaanInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25; // Responsive image size
    final double horizontalPadding = screenWidth * 0.04;

    final List<Map<String, String>> infoList = [
      {
        'title': isHindi ? 'सिंचाई का\nसमय और\nअवधि' : 'Irrigation\nTiming &\nDuration',
        'icon':
            'https://img.freepik.com/premium-vector/indian-farmer-holding-green-crops_1308360-47.jpg',
      },
      {
        'title': isHindi ? 'कीटनाशक\nपेस्टीसाइड' : 'Insecticide\nPesticides',
        'icon':
            'https://img.freepik.com/premium-vector/indian-farmer-holding-green-crops_1308360-47.jpg',
      },
      {
        'title': isHindi ? 'खाद का समय\nऔर अवधि' : 'Fertilizer Timing &\nDuration',
        'icon':
            'https://img.freepik.com/premium-vector/indian-farmer-holding-green-crops_1308360-47.jpg',
      },
      {
        'title': isHindi ? 'जुताई' : 'Plowing',
        'icon':
            'https://img.freepik.com/premium-vector/indian-farmer-holding-green-crops_1308360-47.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(isHindi ? 'बीज जानकारी' : 'Seeds Information', style: ConstTextStyle.appbarTitle),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        itemCount: infoList.length,
        itemBuilder: (context, index) {
          final item = infoList[index];
          return InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationPage()),
                ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4C2E7D32),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image Section
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: item['icon']!,
                      placeholder:
                          (context, url) =>
                              Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 16),

                  // Text & Icon
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: ConstTextStyle.TextBlackinfo.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(thickness: 1),
      ),
    );
  }
}
