import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class KisanCalculatorPage extends StatefulWidget {
  const KisanCalculatorPage({super.key});
  @override
  State<KisanCalculatorPage> createState() => _KisanCalculatorPageState();
}

class _KisanCalculatorPageState extends State<KisanCalculatorPage> with SingleTickerProviderStateMixin {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  late TabController _tab;

  // Yield calc
  final _areaCtrl = TextEditingController();
  final _yieldCtrl = TextEditingController();
  String _areaUnit = 'बीघा';
  String _yieldUnit = 'क्विंटल/बीघा';
  double? _totalYield;

  // Cost-profit calc
  final _seedCostCtrl = TextEditingController();
  final _fertCostCtrl = TextEditingController();
  final _labourCostCtrl = TextEditingController();
  final _irrigCostCtrl = TextEditingController();
  final _otherCostCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _saleQtyCtrl = TextEditingController();
  double? _totalCost, _totalRevenue, _profit;

  // Fertilizer dose calc
  final _fieldAreaCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  String _fertFieldUnit = 'एकड़';
  double? _fertQty;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    for (final c in [_areaCtrl, _yieldCtrl, _seedCostCtrl, _fertCostCtrl, _labourCostCtrl,
      _irrigCostCtrl, _otherCostCtrl, _salePriceCtrl, _saleQtyCtrl, _fieldAreaCtrl, _doseCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';
    return Scaffold(
      backgroundColor: _cream,
      appBar: AppBar(
        backgroundColor: _green1,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(isHindi ? 'किसान कैलकुलेटर' : 'Kisan Calculator',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: isHindi ? 'पैदावार' : 'Yield'),
            Tab(text: isHindi ? 'लाभ-हानि' : 'Profit'),
            Tab(text: isHindi ? 'खाद मात्रा' : 'Fertilizer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildYieldCalc(isHindi),
          _buildProfitCalc(isHindi),
          _buildFertCalc(isHindi),
        ],
      ),
    );
  }

  // ── Yield Calculator ──
  Widget _buildYieldCalc(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _calcCard(
            icon: '🌾',
            title: isHindi ? 'पैदावार गणना' : 'Yield Calculator',
            color: _green2,
            child: Column(
              children: [
                _infoBox(isHindi ? 'खेत का क्षेत्रफल और प्रति इकाई पैदावार दर्ज करें' : 'Enter field area and yield per unit', '📐'),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _inputField(_areaCtrl, isHindi ? 'क्षेत्रफल' : 'Area', isHindi)),
                  const SizedBox(width: 10),
                  _dropdown(
                    isHindi ? 'इकाई' : 'Unit',
                    _areaUnit,
                    ['बीघा', 'एकड़', 'हेक्टेयर'],
                    (v) => setState(() => _areaUnit = v!),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _inputField(_yieldCtrl, isHindi ? 'पैदावार दर' : 'Yield rate', isHindi)),
                  const SizedBox(width: 10),
                  _dropdown(
                    isHindi ? 'इकाई' : 'Unit',
                    _yieldUnit,
                    ['क्विंटल/बीघा', 'क्विंटल/एकड़', 'क्विंटल/हेक्टेयर', 'टन/हेक्टेयर'],
                    (v) => setState(() => _yieldUnit = v!),
                  ),
                ]),
                const SizedBox(height: 16),
                _calcButton(isHindi ? 'गणना करें' : 'Calculate', _green2, () {
                  final area = double.tryParse(_areaCtrl.text) ?? 0;
                  final rate = double.tryParse(_yieldCtrl.text) ?? 0;
                  setState(() => _totalYield = area * rate);
                }),
                if (_totalYield != null) ...[
                  const SizedBox(height: 16),
                  _resultBox(isHindi ? 'कुल पैदावार' : 'Total Yield', '${_totalYield!.toStringAsFixed(2)} ${_yieldUnit.split('/').first}', _green2),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _refCard(isHindi),
        ],
      ),
    );
  }

  Widget _refCard(bool isHindi) {
    final data = [
      {'crop': isHindi ? 'गेहूं' : 'Wheat', 'yield': '15–25 क्विंटल/बीघा'},
      {'crop': isHindi ? 'धान' : 'Rice', 'yield': '12–20 क्विंटल/बीघा'},
      {'crop': isHindi ? 'मक्का' : 'Maize', 'yield': '20–30 क्विंटल/बीघा'},
      {'crop': isHindi ? 'सोयाबीन' : 'Soybean', 'yield': '8–15 क्विंटल/बीघा'},
      {'crop': isHindi ? 'गन्ना' : 'Sugarcane', 'yield': '200–400 क्विंटल/बीघा'},
    ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _green2.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isHindi ? 'औसत पैदावार (संदर्भ)' : 'Average Yield (Reference)',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: _green1)),
          const SizedBox(height: 10),
          ...data.map((d) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(d['crop']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600))),
                Text(d['yield']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Profit Calculator ──
  Widget _buildProfitCalc(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _calcCard(
        icon: '💰',
        title: isHindi ? 'लाभ-हानि गणना' : 'Profit & Loss',
        color: const Color(0xFFE65100),
        child: Column(
          children: [
            _infoBox(isHindi ? 'खेती की लागत और आमदनी दर्ज करें' : 'Enter farming cost and revenue', '📊'),
            const SizedBox(height: 14),
            Text(isHindi ? 'खर्च (रुपये में)' : 'Expenses (in ₹)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 10),
            _inputField(_seedCostCtrl, isHindi ? 'बीज खर्च' : 'Seed cost', isHindi),
            const SizedBox(height: 8),
            _inputField(_fertCostCtrl, isHindi ? 'खाद/दवा खर्च' : 'Fertilizer/Pesticide cost', isHindi),
            const SizedBox(height: 8),
            _inputField(_labourCostCtrl, isHindi ? 'मजदूरी खर्च' : 'Labour cost', isHindi),
            const SizedBox(height: 8),
            _inputField(_irrigCostCtrl, isHindi ? 'सिंचाई खर्च' : 'Irrigation cost', isHindi),
            const SizedBox(height: 8),
            _inputField(_otherCostCtrl, isHindi ? 'अन्य खर्च' : 'Other expenses', isHindi),
            const Divider(height: 24),
            Text(isHindi ? 'आमदनी' : 'Revenue', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 10),
            _inputField(_salePriceCtrl, isHindi ? 'बिक्री मूल्य (₹/क्विंटल)' : 'Sale price (₹/quintal)', isHindi),
            const SizedBox(height: 8),
            _inputField(_saleQtyCtrl, isHindi ? 'कुल बिक्री (क्विंटल)' : 'Total sale (quintal)', isHindi),
            const SizedBox(height: 16),
            _calcButton(isHindi ? 'गणना करें' : 'Calculate', const Color(0xFFE65100), () {
              final costs = [_seedCostCtrl, _fertCostCtrl, _labourCostCtrl, _irrigCostCtrl, _otherCostCtrl]
                  .map((c) => double.tryParse(c.text) ?? 0).fold(0.0, (a, b) => a + b);
              final revenue = (double.tryParse(_salePriceCtrl.text) ?? 0) * (double.tryParse(_saleQtyCtrl.text) ?? 0);
              setState(() { _totalCost = costs; _totalRevenue = revenue; _profit = revenue - costs; });
            }),
            if (_profit != null) ...[
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _resultBox(isHindi ? 'कुल लागत' : 'Total Cost', '₹${_totalCost!.toStringAsFixed(0)}', Colors.red[700]!)),
                const SizedBox(width: 8),
                Expanded(child: _resultBox(isHindi ? 'कुल आमदनी' : 'Revenue', '₹${_totalRevenue!.toStringAsFixed(0)}', Colors.blue[700]!)),
              ]),
              const SizedBox(height: 8),
              _resultBox(
                _profit! >= 0 ? (isHindi ? 'शुद्ध लाभ 🎉' : 'Net Profit 🎉') : (isHindi ? 'हानि ⚠️' : 'Loss ⚠️'),
                '₹${_profit!.abs().toStringAsFixed(0)}',
                _profit! >= 0 ? _green2 : Colors.red[700]!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Fertilizer Dose Calculator ──
  Widget _buildFertCalc(bool isHindi) {
    final fertilizers = [
      {'name': isHindi ? 'यूरिया (46% N)' : 'Urea (46% N)', 'dose': isHindi ? '100–120 किग्रा/एकड़' : '100–120 kg/acre'},
      {'name': isHindi ? 'DAP (18-46-0)' : 'DAP (18-46-0)', 'dose': isHindi ? '50–75 किग्रा/एकड़' : '50–75 kg/acre'},
      {'name': isHindi ? 'MOP (60% K)' : 'MOP (60% K)', 'dose': isHindi ? '25–50 किग्रा/एकड़' : '25–50 kg/acre'},
      {'name': isHindi ? 'SSP (16% P)' : 'SSP (16% P)', 'dose': isHindi ? '100–125 किग्रा/एकड़' : '100–125 kg/acre'},
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _calcCard(
            icon: '🌿',
            title: isHindi ? 'खाद मात्रा गणना' : 'Fertilizer Dose',
            color: const Color(0xFF4E342E),
            child: Column(
              children: [
                _infoBox(isHindi ? 'क्षेत्रफल और खाद की मात्रा दर्ज करें' : 'Enter area and recommended dose', '⚖️'),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: _inputField(_fieldAreaCtrl, isHindi ? 'क्षेत्रफल' : 'Area', isHindi)),
                  const SizedBox(width: 10),
                  _dropdown(
                    isHindi ? 'इकाई' : 'Unit',
                    _fertFieldUnit,
                    ['एकड़', 'बीघा', 'हेक्टेयर'],
                    (v) => setState(() => _fertFieldUnit = v!),
                  ),
                ]),
                const SizedBox(height: 12),
                _inputField(_doseCtrl, isHindi ? 'अनुशंसित मात्रा (किग्रा/इकाई)' : 'Recommended dose (kg/unit)', isHindi),
                const SizedBox(height: 16),
                _calcButton(isHindi ? 'गणना करें' : 'Calculate', const Color(0xFF4E342E), () {
                  final area = double.tryParse(_fieldAreaCtrl.text) ?? 0;
                  final dose = double.tryParse(_doseCtrl.text) ?? 0;
                  setState(() => _fertQty = area * dose);
                }),
                if (_fertQty != null) ...[
                  const SizedBox(height: 16),
                  _resultBox(isHindi ? 'कुल खाद चाहिए' : 'Total Fertilizer', '${_fertQty!.toStringAsFixed(1)} किग्रा', const Color(0xFF4E342E)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [const Color(0xFF4E342E).withValues(alpha: 0.08), const Color(0xFF4E342E).withValues(alpha: 0.02)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF4E342E).withValues(alpha: 0.20)),
              boxShadow: [BoxShadow(color: const Color(0xFF4E342E).withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isHindi ? 'सामान्य खाद मात्रा (संदर्भ)' : 'Standard Fertilizer Dose',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 10),
                ...fertilizers.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Text('🌿', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f['name']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600))),
                      Text(f['dose']!, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared Widgets ──
  Widget _calcCard({required String icon, required String title, required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Text(icon, style: const TextStyle(fontSize: 22))),
            const SizedBox(width: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          ]),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoBox(String text, String icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, bool isHindi) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _green2, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButton<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 11)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _calcButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  Widget _resultBox(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
          Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
        ],
      ),
    );
  }
}
