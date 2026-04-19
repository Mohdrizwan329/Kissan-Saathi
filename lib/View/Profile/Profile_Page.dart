import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:indian_farmer/Provider/locale_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:indian_farmer/View/Alarm_Page.dart';

import 'About_Us_Page.dart';
import 'Edit_Profile_Page.dart';
import 'Help_Center_Page.dart';
import 'Logout_Handler.dart';
import 'Terms_Privacy_Page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFF6F4EE);

  void _navigate(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _shareToWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent('Hey! Check out this awesome app: https://example.com');
    final whatsappUrl = 'whatsapp://send?text=$message';
    try {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)?.whatsappNotInstalled ?? 'WhatsApp नहीं मिला')),
      );
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String currentLang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageBottomSheet(
        currentLang: currentLang,
        onSelect: (code) {
          ref.read(localeProvider.notifier).setLocale(code);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const name = 'Mohd Rizwan';
    const email = 'rizwan@mail.com';
    const avatar = 'https://i.pravatar.cc/150?img=7';
    final w = MediaQuery.of(context).size.width;
    final s = S.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentLang = currentLocale?.languageCode ?? 'hi';
    final isHindi = currentLang == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      body: Column(
        children: [
          _buildProfileHeader(context, w, name, email, avatar),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                _sectionLabel('खाता / Account'),
                const SizedBox(height: 8),
                _menuCard(context, [
                  _MenuItem(Icons.edit_rounded, s?.editProfile ?? 'प्रोफ़ाइल संपादित करें', const Color(0xFF1565C0), () => _navigate(context, const EditProfilePage())),
                  _MenuItem(Icons.alarm_rounded, s?.navAlarm ?? 'अलार्म', const Color(0xFFE65100), () => _navigate(context, const AlarmPage())),
                  _MenuItem(Icons.share_rounded, s?.shareApp ?? 'ऐप शेयर करें', const Color(0xFF2E7D32), () => _shareToWhatsApp(context)),
                ]),
                const SizedBox(height: 16),

                // ── Language Card ─────────────────────────────────────
                _sectionLabel(isHindi ? 'भाषा / Language' : 'Language'),
                const SizedBox(height: 8),
                _languageCard(context, ref, currentLang, isHindi),
                const SizedBox(height: 16),

                _sectionLabel('सहायता / Support'),
                const SizedBox(height: 8),
                _menuCard(context, [
                  _MenuItem(Icons.help_rounded, s?.helpCenter ?? 'सहायता केंद्र', const Color(0xFFF57F17), () => _navigate(context, const HelpCenterPage())),
                  _MenuItem(Icons.info_rounded, s?.aboutUs ?? 'हमारे बारे में', const Color(0xFF00695C), () => _navigate(context, const AboutUsPage())),
                  _MenuItem(Icons.privacy_tip_rounded, s?.termsPrivacy ?? 'नियम व गोपनीयता', const Color(0xFF6A1B9A), () => _navigate(context, const TermsPrivacyPage())),
                ]),
                const SizedBox(height: 16),
                _menuCard(context, [
                  _MenuItem(Icons.logout_rounded, s?.logout ?? 'लॉगआउट', Colors.red, () => handleLogout(context), isDestructive: true),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageCard(BuildContext context, WidgetRef ref, String currentLang, bool isHindi) {
    final isHindiSelected = currentLang == 'hi';
    return GestureDetector(
      onTap: () => _showLanguagePicker(context, ref, currentLang),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.language_rounded, color: Color(0xFF1565C0), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHindi ? 'भाषा बदलें' : 'Change Language',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isHindiSelected ? '🇮🇳 हिंदी (Hindi)' : '🇬🇧 English',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.2)),
              ),
              child: Text(
                isHindiSelected ? 'HI' : 'EN',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF1565C0)),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, double w, String name, String email, String avatar) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_green1, _green2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)],
                  ),
                  child: ClipOval(child: Image.network(avatar, fit: BoxFit.cover)),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(color: Color(0xFF66BB6A), shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('🌾 किसान', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
    );
  }

  Widget _menuCard(BuildContext context, List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.label,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600,
                        color: item.isDestructive ? Colors.red : Colors.black87)),
                trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                onTap: item.onTap,
              ),
              if (i < items.length - 1)
                Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.shade100),
            ],
          );
        }),
      ),
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  final String currentLang;
  final void Function(String) onSelect;

  const _LanguageBottomSheet({required this.currentLang, required this.onSelect});

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);

  static const _langs = [
    {'code': 'hi', 'label': 'हिंदी', 'sub': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'en', 'label': 'English', 'sub': 'अंग्रेज़ी', 'flag': '🇬🇧'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F4EE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_green1, _green2]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.language_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('भाषा चुनें / Select Language',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    Text('App की भाषा बदलें',
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: _langs.map((lang) {
                final isSelected = currentLang == lang['code'];
                return GestureDetector(
                  onTap: () => onSelect(lang['code']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? _green1.withValues(alpha: 0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? _green2 : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lang['label']!,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700,
                                      color: isSelected ? _green1 : Colors.black87)),
                              Text(lang['sub']!,
                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? _green2 : Colors.transparent,
                            border: Border.all(color: isSelected ? _green2 : Colors.grey.shade300, width: 2),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem(this.icon, this.label, this.color, this.onTap, {this.isDestructive = false});
}
