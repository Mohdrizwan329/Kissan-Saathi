import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:indian_farmer/View/Auth/Signup_Screen.dart';
import 'package:indian_farmer/View/Auth/Forgot_Password_Screen.dart';
import 'package:indian_farmer/View/Bottom_NavigationBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email') ?? '';
    final savedPassword = prefs.getString('user_password') ?? '';

    final isValid = _emailController.text.trim() == savedEmail &&
        _passwordController.text == savedPassword;

    if (isValid) await prefs.setBool('is_logged_in', true);

    if (!mounted) return;

    if (isValid) {
      setState(() => _isLoading = false);
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => MyHomePage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (route) => false,
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isHindi ? 'गलत ईमेल या पासवर्ड!' : 'Invalid email or password!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
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

          // Wheat field silhouette at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(w, h * 0.28),
              painter: _FieldSilhouettePainter(),
            ),
          ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: h * 0.055),

                  // Logo & branding
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Container(
                          width: w * 0.25,
                          height: w * 0.25,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/app logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: w * 0.04),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: _gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isHindi ? 'आपकी खेती, हमारी जिम्मेदारी' : 'Your farming, our responsibility',
                            style: GoogleFonts.poppins(
                              fontSize: w * 0.033,
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.04),

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
                                _buildLabel(isHindi ? 'ईमेल / मोबाइल नंबर' : 'Email / Mobile Number', w),
                                SizedBox(height: w * 0.02),
                                _buildTextField(
                                  controller: _emailController,
                                  hint: 'example@email.com',
                                  icon: Icons.person_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return isHindi ? 'ईमेल दर्ज करें' : 'Enter email';
                                    }
                                    return null;
                                  },
                                  w: w,
                                ),
                                SizedBox(height: w * 0.04),

                                _buildLabel(isHindi ? 'पासवर्ड' : 'Password', w),
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
                                      return isHindi ? 'पासवर्ड दर्ज करें' : 'Enter password';
                                    }
                                    if (v.length < 6) {
                                      return isHindi ? 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए' : 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  w: w,
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen()),
                                    ),
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    child: Text(
                                      isHindi ? 'पासवर्ड भूल गए?' : 'Forgot Password?',
                                      style: GoogleFonts.poppins(
                                        fontSize: w * 0.033,
                                        color: _amber,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: w * 0.02),

                                _buildGradientButton(
                                  label: isHindi ? 'लॉगिन करें' : 'Login',
                                  icon: Icons.login_rounded,
                                  isLoading: _isLoading,
                                  onPressed: _login,
                                  w: w,
                                ),

                                SizedBox(height: w * 0.05),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                          color: Colors.white
                                              .withValues(alpha: 0.2)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text(
                                        isHindi ? 'या' : 'or',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          fontSize: w * 0.035,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                          color: Colors.white
                                              .withValues(alpha: 0.2)),
                                    ),
                                  ],
                                ),

                                SizedBox(height: w * 0.05),

                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isHindi ? 'खाता नहीं है? ' : "Don't have an account? ",
                                        style: GoogleFonts.poppins(
                                          color:
                                              Colors.white.withValues(alpha: 0.7),
                                          fontSize: w * 0.038,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SignupScreen()),
                                        ),
                                        child: Text(
                                          isHindi ? 'अभी बनाएं' : 'Create Now',
                                          style: GoogleFonts.poppins(
                                            color: _amber,
                                            fontSize: w * 0.038,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.underline,
                                            decorationColor: _amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    required double w,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
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
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.32,
          size.width * 0.45, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.68, size.width,
          size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    final grassPaint = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    final grassPath = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.65,
          size.width * 0.6, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.88, size.width,
          size.height * 0.72)
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
      52.0, 44.0, 58.0, 46.0, 54.0, 42.0,
      56.0, 48.0, 52.0, 44.0, 58.0, 46.0
    ];

    for (int i = 0; i < positions.length; i++) {
      final x = size.width * positions[i];
      final stalkH = heights[i];
      final baseY = size.height * 0.72;

      canvas.drawLine(Offset(x, baseY), Offset(x, baseY - stalkH), stalkPaint);
      canvas.drawLine(Offset(x, baseY - stalkH * 0.4),
          Offset(x + 10, baseY - stalkH * 0.52), stalkPaint);
      canvas.drawLine(Offset(x, baseY - stalkH * 0.6),
          Offset(x - 10, baseY - stalkH * 0.72), stalkPaint);

      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, baseY - stalkH - 10), width: 7, height: 18),
        headFill,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(x, baseY - stalkH - 10), width: 7, height: 18),
        stalkPaint..strokeWidth = 1.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
