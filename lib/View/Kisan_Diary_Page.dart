import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KisanDiaryPage extends StatefulWidget {
  const KisanDiaryPage({super.key});
  @override
  State<KisanDiaryPage> createState() => _KisanDiaryPageState();
}

class _KisanDiaryPageState extends State<KisanDiaryPage>
    with SingleTickerProviderStateMixin {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);
  static const _prefsKey = 'kisan_diary_entries';

  late TabController _tab;
  List<Map<String, dynamic>> _entries = [];

  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _selectedType = 'expense';
  String _selectedCategory = 'बीज';

  static const _expenseCategories = ['बीज', 'खाद', 'दवाई', 'सिंचाई', 'मजदूरी', 'औजार', 'ईंधन', 'अन्य'];
  static const _incomeCategories = ['फसल बिक्री', 'दूध बिक्री', 'सब्जी बिक्री', 'सरकारी अनुदान', 'अन्य'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _loadEntries();
  }

  @override
  void dispose() {
    _tab.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() => _entries = list.map((e) => Map<String, dynamic>.from(e)).toList());
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_entries));
  }

  void _addEntry() {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) return;
    final entry = {
      'type': _selectedType,
      'category': _selectedCategory,
      'amount': amount,
      'note': _noteCtrl.text.trim(),
      'date': DateTime.now().toIso8601String(),
    };
    setState(() => _entries.insert(0, entry));
    _saveEntries();
    _amountCtrl.clear();
    _noteCtrl.clear();
    Navigator.pop(context);
  }

  void _deleteEntry(int index) {
    setState(() => _entries.removeAt(index));
    _saveEntries();
  }

  double get _totalIncome => _entries
      .where((e) => e['type'] == 'income')
      .fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());

  double get _totalExpense => _entries
      .where((e) => e['type'] == 'expense')
      .fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());

  double get _netBalance => _totalIncome - _totalExpense;

  String _formatDate(String iso) {
    final d = DateTime.parse(iso);
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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
        title: Text(
          isHindi ? 'किसान डायरी' : 'Kisan Diary',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: isHindi ? 'सारांश' : 'Summary'),
            Tab(text: isHindi ? 'सभी लेन-देन' : 'All Entries'),
            Tab(text: isHindi ? 'रिपोर्ट' : 'Report'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context, isHindi),
        backgroundColor: _green2,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(isHindi ? 'लेन-देन जोड़ें' : 'Add Entry',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildSummary(isHindi),
          _buildAllEntries(isHindi),
          _buildReport(isHindi),
        ],
      ),
    );
  }

  Widget _buildSummary(bool isHindi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _balanceCard(isHindi),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statCard(
                isHindi ? 'कुल आय' : 'Total Income', '₹${_totalIncome.toStringAsFixed(0)}',
                const Color(0xFF2E7D32), Icons.trending_up_rounded,
              )),
              const SizedBox(width: 12),
              Expanded(child: _statCard(
                isHindi ? 'कुल खर्च' : 'Total Expense', '₹${_totalExpense.toStringAsFixed(0)}',
                const Color(0xFFB71C1C), Icons.trending_down_rounded,
              )),
            ],
          ),
          const SizedBox(height: 16),
          if (_entries.isEmpty)
            _emptyState(isHindi)
          else ...[
            _sectionTitle(isHindi ? 'हाल के लेन-देन' : 'Recent Entries'),
            const SizedBox(height: 8),
            ..._entries.take(5).map((e) => _entryTile(e, _entries.indexOf(e), isHindi, showDelete: false)),
          ],
        ],
      ),
    );
  }

  Widget _balanceCard(bool isHindi) {
    final isPositive = _netBalance >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [const Color(0xFF1B5E20), const Color(0xFF43A047)]
              : [const Color(0xFFB71C1C), const Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(
          color: (isPositive ? _green1 : const Color(0xFFB71C1C)).withValues(alpha: 0.35),
          blurRadius: 12, offset: const Offset(0, 4),
        )],
      ),
      child: Column(
        children: [
          Text(isHindi ? 'शुद्ध लाभ/हानि' : 'Net Profit/Loss',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            '${isPositive ? '+' : ''}₹${_netBalance.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            isPositive
                ? (isHindi ? '🎉 लाभ की स्थिति में' : '🎉 In profit')
                : (isHindi ? '⚠️ हानि की स्थिति में' : '⚠️ In loss'),
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAllEntries(bool isHindi) {
    if (_entries.isEmpty) {
      return Center(child: _emptyState(isHindi));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _entries.length,
      itemBuilder: (ctx, i) => _entryTile(_entries[i], i, isHindi, showDelete: true),
    );
  }

  Widget _entryTile(Map<String, dynamic> entry, int index, bool isHindi, {required bool showDelete}) {
    final isIncome = entry['type'] == 'income';
    final color = isIncome ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.10), color.withValues(alpha: 0.03)]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry['category'] as String,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                if ((entry['note'] as String).isNotEmpty)
                  Text(entry['note'] as String,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                Text(_formatDate(entry['date'] as String),
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}₹${(entry['amount'] as num).toStringAsFixed(0)}',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, color: color),
              ),
              if (showDelete)
                GestureDetector(
                  onTap: () => _confirmDelete(context, index, isHindi),
                  child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReport(bool isHindi) {
    final expenseByCategory = <String, double>{};
    final incomeByCategory = <String, double>{};
    for (final e in _entries) {
      final cat = e['category'] as String;
      final amt = (e['amount'] as num).toDouble();
      if (e['type'] == 'expense') {
        expenseByCategory[cat] = (expenseByCategory[cat] ?? 0) + amt;
      } else {
        incomeByCategory[cat] = (incomeByCategory[cat] ?? 0) + amt;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expenseByCategory.isNotEmpty) ...[
            _sectionTitle(isHindi ? '💸 खर्च का विवरण' : '💸 Expense Breakdown'),
            const SizedBox(height: 8),
            _categoryReport(expenseByCategory, const Color(0xFFB71C1C), _totalExpense),
            const SizedBox(height: 16),
          ],
          if (incomeByCategory.isNotEmpty) ...[
            _sectionTitle(isHindi ? '💰 आय का विवरण' : '💰 Income Breakdown'),
            const SizedBox(height: 8),
            _categoryReport(incomeByCategory, const Color(0xFF2E7D32), _totalIncome),
          ],
          if (_entries.isEmpty) _emptyState(isHindi),
        ],
      ),
    );
  }

  Widget _categoryReport(Map<String, double> data, Color color, double total) {
    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.08), color.withValues(alpha: 0.02)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.20)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: sorted.map((entry) {
          final pct = total > 0 ? entry.value / total : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                    Text('₹${entry.value.toStringAsFixed(0)} (${(pct * 100).toStringAsFixed(0)}%)',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAddDialog(BuildContext context, bool isHindi) {
    _selectedType = 'expense';
    _selectedCategory = _expenseCategories[0];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text(isHindi ? 'लेन-देन जोड़ें' : 'Add Entry',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _typeButton(isHindi ? 'खर्च' : 'Expense', 'expense', const Color(0xFFB71C1C), _selectedType, (v) => setModal(() {
                    _selectedType = v;
                    _selectedCategory = _expenseCategories[0];
                  }))),
                  const SizedBox(width: 10),
                  Expanded(child: _typeButton(isHindi ? 'आय' : 'Income', 'income', const Color(0xFF2E7D32), _selectedType, (v) => setModal(() {
                    _selectedType = v;
                    _selectedCategory = _incomeCategories[0];
                  }))),
                ],
              ),
              const SizedBox(height: 14),
              Text(isHindi ? 'श्रेणी' : 'Category',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  items: (_selectedType == 'expense' ? _expenseCategories : _incomeCategories)
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(fontSize: 13))))
                      .toList(),
                  onChanged: (v) => setModal(() => _selectedCategory = v!),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  labelText: isHindi ? 'राशि (₹)' : 'Amount (₹)',
                  labelStyle: GoogleFonts.poppins(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixText: '₹ ',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteCtrl,
                style: GoogleFonts.poppins(fontSize: 13),
                decoration: InputDecoration(
                  labelText: isHindi ? 'टिप्पणी (वैकल्पिक)' : 'Note (optional)',
                  labelStyle: GoogleFonts.poppins(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isHindi ? 'सहेजें' : 'Save',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String label, String value, Color color, String selected, Function(String) onTap) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(label,
            style: GoogleFonts.poppins(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.grey[600],
            )),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index, bool isHindi) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isHindi ? 'हटाएं?' : 'Delete?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text(isHindi ? 'यह लेन-देन हटा दिया जाएगा।' : 'This entry will be deleted.',
          style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(isHindi ? 'रद्द करें' : 'Cancel', style: GoogleFonts.poppins())),
          TextButton(
            onPressed: () { Navigator.pop(ctx); _deleteEntry(index); },
            child: Text(isHindi ? 'हटाएं' : 'Delete', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87));
  }

  Widget _emptyState(bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            const Text('📒', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(isHindi ? 'अभी कोई लेन-देन नहीं' : 'No entries yet',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
            const SizedBox(height: 6),
            Text(isHindi ? '+ बटन दबाकर जोड़ें' : 'Tap + button to add',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
