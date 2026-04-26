import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/Res/Const_Text_Style.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  Future<void> _launchVideo(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final localized = S.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;
    final containerPadding = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.045;
    final descFontSize = screenWidth * 0.040;

    final infoList = [
      {
        'title': localized!.irrigationTitle,
        'description1': localized.irrigationDescription1,
        'description2': localized.irrigationDescription2,
        'description3': localized.irrigationDescription3,
      },
      {
        'title': localized.irrigationTitle,
        'description1': localized.irrigationDescription1,
        'description2': localized.irrigationDescription2,
        'description3': localized.irrigationDescription3,
      },
      {
        'title': localized.irrigationTitle,
        'description1': localized.irrigationDescription1,
        'description2': localized.irrigationDescription2,
        'description3': localized.irrigationDescription3,
      },
      {
        'title': localized.irrigationTitle,
        'description1': localized.irrigationDescription1,
        'description2': localized.irrigationDescription2,
        'description3': localized.irrigationDescription3,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          localized.informationPageTitle,
          style: ConstTextStyle.appbarTitle,
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 10,
        ),
        itemCount: infoList.length,
        itemBuilder: (context, index) {
          final item = infoList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: EdgeInsets.all(containerPadding),
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
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "■ ${item['title']}",
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "• ${item['description1']}",
                    style: GoogleFonts.poppins(fontSize: descFontSize, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "• ${item['description2']}",
                    style: GoogleFonts.poppins(fontSize: descFontSize, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "• ${item['description3']}",
                    style: GoogleFonts.poppins(fontSize: descFontSize, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.play_circle, color: Colors.white),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _launchVideo(
                            "https://youtu.be/_yPp-Z_cB7g?si=u4WUEemX167Mamtq",
                          );
                        },
                        child: Text(localized.watchDemoVideo,
                          style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
