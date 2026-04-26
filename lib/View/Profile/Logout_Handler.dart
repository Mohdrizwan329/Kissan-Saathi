import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/View/Auth/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleLogout(BuildContext context) {
  final isHindi = Localizations.localeOf(context).languageCode == 'hi';
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🚪', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              isHindi ? 'लॉगआउट करें?' : 'Logout?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isHindi ? 'क्या आप वाकई लॉगआउट करना चाहते हैं?' : 'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(isHindi ? 'रद्द करें' : 'Cancel',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      // Keep device preferences, clear only user account data
                      for (final key in [
                        'is_logged_in', 'user_email', 'user_password',
                        'user_name', 'user_mobile', 'profile_name',
                        'profile_email', 'profile_mobile', 'profile_country',
                        'profile_image', 'profile_user_id',
                        'farmer_alarms', 'kisan_diary_entries',
                      ]) {
                        await prefs.remove(key);
                      }
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginScreen(),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(isHindi ? 'लॉगआउट' : 'Logout',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
