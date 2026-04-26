import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _bg = Color(0xFF0E2A10);
  static const _gold = Color(0xFFF9A825);
  static const _amber = Color(0xFFFFB300);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_password', _passwordController.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0E2A10), Color(0xFF1B5E20), Color(0xFF0E2A10)],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color: const Color(0xFFF9A825).withValues(alpha: 0.45),
                width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                      color: _gold.withValues(alpha: 0.55), width: 2),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFFF9A825), size: 40),
              ),
              const SizedBox(height: 18),
              Text(
                isHindi ? 'पासवर्ड बदल गया!' : 'Password Changed!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'आपका पासवर्ड सफलतापूर्वक अपडेट हो गया। अब लॉगिन करें।'
                    : 'Your password has been updated successfully. Please login now.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB300), Color(0xFFF9A825)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        isHindi ? 'लॉगिन पेज पर जाएं' : 'Go to Login',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Single deep green background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_bg, Color(0xFF1B5E20), _bg],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Wheat field silhouette
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(w, h * 0.25),
              painter: _FieldSilhouettePainter(),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: h * 0.035),

                  // Header
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 18),
                            ),
                          ),
                          SizedBox(width: w * 0.04),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHindi ? 'नया पासवर्ड बनाएं' : 'Create New Password',
                                style: GoogleFonts.poppins(
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8),
                                  ],
                                ),
                              ),
                              Text(
                                widget.email,
                                style: GoogleFonts.poppins(
                                  fontSize: w * 0.03,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.04),

                  // Icon illustration
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      width: w * 0.22,
                      height: w * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                            color: _gold.withValues(alpha: 0.5), width: 2),
                      ),
                      child: Icon(Icons.lock_open_rounded,
                          size: w * 0.1, color: _gold),
                    ),
                  ),

                  SizedBox(height: h * 0.035),

                  // Form card (glass style)
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              w * 0.06, w * 0.06, w * 0.06, w * 0.06),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel(isHindi ? 'नया पासवर्ड' : 'New Password', w),
                                SizedBox(height: w * 0.02),
                                _buildTextField(
                                  controller: _passwordController,
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscurePassword = !_obscurePassword),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return isHindi ? 'नया पासवर्ड दर्ज करें' : 'Enter new password';
                                    }
                                    if (v.length < 6) {
                                      return isHindi ? 'कम से कम 6 अक्षर का पासवर्ड' : 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  w: w,
                                ),
                                SizedBox(height: w * 0.04),

                                _buildLabel(isHindi ? 'पासवर्ड दोबारा डालें' : 'Confirm Password', w),
                                SizedBox(height: w * 0.02),
                                _buildTextField(
                                  controller: _confirmController,
                                  hint: '••••••••',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscureConfirm,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _obscureConfirm = !_obscureConfirm),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return isHindi ? 'पासवर्ड दोबारा डालें' : 'Re-enter password';
                                    }
                                    if (v != _passwordController.text) {
                                      return isHindi ? 'पासवर्ड मेल नहीं खाते' : 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  w: w,
                                ),

                                SizedBox(height: w * 0.04),

                                // Password tip box (glass style)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _amber.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _gold.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.tips_and_updates_outlined,
                                          color: _gold, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          isHindi ? 'मजबूत पासवर्ड: अक्षर + अंक + चिह्न (@#\$%)' : 'Strong password: letters + numbers + symbols (@#\$%)',
                                          style: GoogleFonts.poppins(
                                            fontSize: w * 0.031,
                                            color: Colors.white
                                                .withValues(alpha: 0.75),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: w * 0.06),

                                _buildGradientButton(
                                  label: isHindi ? 'पासवर्ड सेव करें' : 'Save Password',
                                  icon: Icons.save_rounded,
                                  isLoading: _isLoading,
                                  onPressed: _savePassword,
                                  w: w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onPressed,
    required double w,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isLoading
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFF9A825)],
                  ),
            color: isLoading ? Colors.white.withValues(alpha: 0.15) : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isLoading
                ? null
                : [
                    BoxShadow(
                      color: _gold.withValues(alpha: 0.45),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.046,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, double w) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: w * 0.036,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.85),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required double w,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: w * 0.038, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.4), fontSize: w * 0.036),
        prefixIcon:
            Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.25),
        errorStyle: GoogleFonts.poppins(
            color: Colors.red.shade300, fontSize: w * 0.031),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.2), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF9A825), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _FieldSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final hillPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final hillPath = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.28,
          size.width * 0.45, size.height * 0.48)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.68, size.width,
          size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    final grassPaint = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    final grassPath = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.62,
          size.width * 0.6, size.height * 0.76)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.86, size.width,
          size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(grassPath, grassPaint);

    final stalkPaint = Paint()
      ..color = const Color(0xFFFFB300).withValues(alpha: 0.75)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final headFill = Paint()
      ..color = const Color(0xFFFFCA28).withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final positions = [
      0.04, 0.1, 0.17, 0.25, 0.33, 0.42,
      0.52, 0.61, 0.70, 0.79, 0.87, 0.94
    ];
    final heights = [
      44.0, 36.0, 50.0, 38.0, 46.0, 34.0,
      48.0, 40.0, 44.0, 36.0, 50.0, 38.0
    ];

    for (int i = 0; i < positions.length; i++) {
      final x = size.width * positions[i];
      final stalkH = heights[i];
      final baseY = size.height * 0.7;

      canvas.drawLine(
          Offset(x, baseY), Offset(x, baseY - stalkH), stalkPaint);
      canvas.drawLine(Offset(x, baseY - stalkH * 0.4),
          Offset(x + 9, baseY - stalkH * 0.52), stalkPaint);
      canvas.drawLine(Offset(x, baseY - stalkH * 0.6),
          Offset(x - 9, baseY - stalkH * 0.72), stalkPaint);

      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, baseY - stalkH - 9), width: 7, height: 17),
        headFill,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, baseY - stalkH - 9), width: 7, height: 17),
        stalkPaint..strokeWidth = 1.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
