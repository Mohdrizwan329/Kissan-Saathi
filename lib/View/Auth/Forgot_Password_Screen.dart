import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/View/Auth/Create_New_Password_Screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

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
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi
              ? 'OTP भेजा गया: ${_emailController.text.trim()}'
              : 'OTP sent to: ${_emailController.text.trim()}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isHindi ? '6 अंकों का OTP दर्ज करें' : 'Enter a 6-digit OTP',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateNewPasswordScreen(email: _emailController.text.trim()),
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

                  // Header row with back button
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
                                    color: Colors.white.withValues(alpha: 0.2)),
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
                                isHindi ? 'पासवर्ड भूल गए?' : 'Forgot Password?',
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
                                isHindi ? 'OTP से पहचान सत्यापित करें' : 'Verify identity via OTP',
                                style: GoogleFonts.poppins(
                                  fontSize: w * 0.032,
                                  color: Colors.white.withValues(alpha: 0.65),
                                ),
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
                      child: Icon(
                        _otpSent
                            ? Icons.verified_outlined
                            : Icons.lock_reset_rounded,
                        size: w * 0.1,
                        color: _gold,
                      ),
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
                                if (!_otpSent) ...[
                                  _buildLabel(isHindi ? 'ईमेल / मोबाइल नंबर' : 'Email / Mobile Number', w),
                                  SizedBox(height: w * 0.02),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return isHindi ? 'ईमेल या मोबाइल दर्ज करें' : 'Enter email or mobile';
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.poppins(
                                        fontSize: w * 0.038,
                                        color: Colors.white),
                                    decoration: _inputDecoration(
                                      hint: 'example@email.com',
                                      icon: Icons.email_outlined,
                                      w: w,
                                    ),
                                  ),
                                  SizedBox(height: w * 0.06),
                                  _buildGradientButton(
                                    label: isHindi ? 'OTP भेजें' : 'Send OTP',
                                    icon: Icons.send_rounded,
                                    isLoading: _isLoading,
                                    onPressed: _sendOtp,
                                    w: w,
                                  ),
                                ] else ...[
                                  // OTP sent info banner
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _gold.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: _gold.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.mark_email_read_outlined,
                                            color: _gold, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            isHindi
                                                ? '${_emailController.text.trim()} पर OTP भेजा गया'
                                                : 'OTP sent to ${_emailController.text.trim()}',
                                            style: GoogleFonts.poppins(
                                              fontSize: w * 0.031,
                                              color: Colors.white
                                                  .withValues(alpha: 0.8),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: w * 0.05),

                                  _buildLabel(isHindi ? 'OTP कोड' : 'OTP Code', w),
                                  SizedBox(height: w * 0.02),
                                  TextFormField(
                                    controller: _otpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    style: GoogleFonts.poppins(
                                      fontSize: w * 0.055,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 10,
                                    ),
                                    decoration: _inputDecoration(
                                      hint: '• • • • • •',
                                      icon: Icons.pin_outlined,
                                      w: w,
                                    ).copyWith(counterText: ''),
                                  ),
                                  SizedBox(height: w * 0.02),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          setState(() => _otpSent = false),
                                      icon: Icon(Icons.refresh_rounded,
                                          size: 16, color: _amber),
                                      label: Text(
                                        isHindi ? 'OTP दोबारा भेजें' : 'Resend OTP',
                                        style: GoogleFonts.poppins(
                                          fontSize: w * 0.033,
                                          color: _amber,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: w * 0.04),
                                  _buildGradientButton(
                                    label: isHindi ? 'OTP सत्यापित करें' : 'Verify OTP',
                                    icon: Icons.verified_rounded,
                                    isLoading: _isLoading,
                                    onPressed: _verifyOtp,
                                    w: w,
                                  ),
                                ],
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required double w,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
          color: Colors.white.withValues(alpha: 0.4), fontSize: w * 0.036),
      prefixIcon:
          Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 20),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.25),
      errorStyle:
          GoogleFonts.poppins(color: Colors.red.shade300, fontSize: w * 0.031),
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
