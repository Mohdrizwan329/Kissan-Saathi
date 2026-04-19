import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:indian_farmer/View/Home_Page.dart' show HomeScreen;
import 'package:indian_farmer/View/Krishi_Tips_Page.dart';
import 'package:indian_farmer/View/Mandi_Bhav_Page.dart';
import 'package:indian_farmer/View/Yojna_Page.dart';
import 'package:indian_farmer/View/Profile/Profile_Page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const _pages = [
    HomeScreen(),
    KrishiTipsPage(),
    MandiBhavPage(),
    YojnaPage(),
    ProfilePage(),
  ];

  static const _appGreen = Color(0xFF1B5E20);
  static const _appGreenBg = Color(0xFFE8F5E9);

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'होम',
      labelEn: 'Home',
      color: _appGreen,
      activeColor: _appGreenBg,
    ),
    _NavItem(
      icon: Icons.eco_outlined,
      activeIcon: Icons.eco_rounded,
      label: 'कृषि टिप्स',
      labelEn: 'Krishi Tips',
      color: _appGreen,
      activeColor: _appGreenBg,
    ),
    _NavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront_rounded,
      label: 'मंडी भाव',
      labelEn: 'Mandi',
      color: _appGreen,
      activeColor: _appGreenBg,
    ),
    _NavItem(
      icon: Icons.account_balance_outlined,
      activeIcon: Icons.account_balance_rounded,
      label: 'योजनाएं',
      labelEn: 'Schemes',
      color: _appGreen,
      activeColor: _appGreenBg,
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'प्रोफ़ाइल',
      labelEn: 'Profile',
      color: _appGreen,
      activeColor: _appGreenBg,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildNavBar(isHindi),
      ),
    );
  }

  Widget _buildNavBar(bool isHindi) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = _selectedIndex == i;
              final item = _items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          selected ? item.activeIcon : item.icon,
                          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.55),
                          size: selected ? 24 : 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isHindi ? item.label : item.labelEn,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.55),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String labelEn;
  final Color color;
  final Color activeColor;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.labelEn,
    required this.color,
    required this.activeColor,
  });
}
