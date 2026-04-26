import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final userIdController = TextEditingController();
  final mobileController = TextEditingController();
  final imageUrlController = TextEditingController();
  final countryController = TextEditingController();

  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      nameController.text = prefs.getString('profile_name') ?? '';
      emailController.text = prefs.getString('profile_email') ?? '';
      mobileController.text = prefs.getString('profile_mobile') ?? '';
      countryController.text = prefs.getString('profile_country') ?? 'India';
      imageUrlController.text = prefs.getString('profile_image') ?? '';
      userIdController.text = prefs.getString('profile_user_id') ?? 'KIS${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    userIdController.dispose();
    mobileController.dispose();
    imageUrlController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(bool isHindi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', nameController.text.trim());
    await prefs.setString('profile_email', emailController.text.trim());
    await prefs.setString('profile_mobile', mobileController.text.trim());
    await prefs.setString('profile_country', countryController.text.trim());
    await prefs.setString('profile_image', imageUrlController.text.trim());
    await prefs.setString('profile_user_id', userIdController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi ? '✅ प्रोफ़ाइल अपडेट हो गई!' : '✅ Profile updated successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: _green2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          isHindi ? 'प्रोफ़ाइल संपादित करें' : 'Edit Profile',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _green2, width: 3),
                    ),
                    child: ClipOval(child: Image.network(imageUrlController.text, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE8F5E9), child: const Icon(Icons.person_rounded, color: _green2, size: 48)))),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(color: _green2, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _formCard([
              _field(
                nameController,
                isHindi ? 'पूरा नाम' : 'Full Name',
                Icons.person_rounded,
                colors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              _field(
                emailController,
                isHindi ? 'ईमेल' : 'Email',
                Icons.email_rounded,
                type: TextInputType.emailAddress,
                colors: const [Color(0xFF4E342E), Color(0xFF8D6E63)],
              ),
              _field(
                mobileController,
                isHindi ? 'मोबाइल नंबर' : 'Mobile Number',
                Icons.phone_rounded,
                type: TextInputType.phone,
                colors: const [Color(0xFFE65100), Color(0xFFFFA726)],
              ),
              _field(
                countryController,
                isHindi ? 'देश' : 'Country',
                Icons.flag_rounded,
                colors: const [Color(0xFF01579B), Color(0xFF29B6F6)],
              ),
            ]),
            const SizedBox(height: 12),
            _formCard([
              _field(
                userIdController,
                isHindi ? 'यूजर ID' : 'User ID',
                Icons.badge_rounded,
                readOnly: true,
                colors: const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
              ),
              _field(
                imageUrlController,
                isHindi ? 'प्रोफ़ाइल फोटो URL' : 'Profile Photo URL',
                Icons.image_rounded,
                onChanged: (_) => setState(() {}),
                colors: const [Color(0xFF00695C), Color(0xFF26A69A)],
              ),
            ]),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveProfile(isHindi),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_green1, _green2]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isHindi ? 'बदलाव सेव करें' : 'Save Changes',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x4C2E7D32), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool readOnly = false,
    TextInputType type = TextInputType.text,
    void Function(String)? onChanged,
    List<Color> colors = const [_green1, _green2],
  }) {
    final gradColors = readOnly
        ? [Colors.grey.shade400, Colors.grey.shade500]
        : colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          TextField(
            controller: ctrl,
            readOnly: readOnly,
            keyboardType: type,
            onChanged: onChanged,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gradColors[0].withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: gradColors[0], width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
