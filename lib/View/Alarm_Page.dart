import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indian_farmer/l10n/s.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Map<String, dynamic>> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms([int retries = 3]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('farmer_alarms') ?? [];
      if (!mounted) return;
      setState(() {
        _alarms = data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
        _alarms.sort((a, b) => (a['hour'] as int).compareTo(b['hour'] as int));
      });
    } catch (_) {
      if (retries > 0 && mounted) {
        await Future.delayed(const Duration(seconds: 2));
        return _loadAlarms(retries - 1);
      }
    }
  }

  Future<void> _saveAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _alarms.map((e) => jsonEncode(e)).toList();
      await prefs.setStringList('farmer_alarms', data);
      debugPrint('Alarms saved: ${data.length} items');
    } catch (e) {
      debugPrint('Failed to save alarms: $e');
    }
  }

  Future<void> _addAlarm() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    // Show task name dialog
    final taskController = TextEditingController();
    final taskName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(ctx)?.enterTaskName ?? 'काम का नाम लिखें', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: taskController,
          autofocus: true,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: S.of(ctx)?.taskHintExample ?? 'जैसे: खेत में पानी देना',
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(ctx)?.cancel ?? 'रद्द करें', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, taskController.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(S.of(ctx)?.save ?? 'सेव करें', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );

    if (taskName == null || taskName.isEmpty) return;

    final alarm = {
      'hour': picked.hour,
      'minute': picked.minute,
      'task': taskName,
      'enabled': true,
      'id': DateTime.now().millisecondsSinceEpoch,
    };

    setState(() => _alarms.add(alarm));
    await _saveAlarms();
    _setDeviceAlarm(picked.hour, picked.minute, taskName);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⏰ ${S.of(context)?.alarmSet ?? 'अलार्म सेट'}: ${_formatTime(picked.hour, picked.minute)} - $taskName',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _setDeviceAlarm(int hour, int minute, String message) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SET_ALARM',
        arguments: {
          'android.intent.extra.alarm.HOUR': hour,
          'android.intent.extra.alarm.MINUTES': minute,
          'android.intent.extra.alarm.MESSAGE': message,
          'android.intent.extra.alarm.SKIP_UI': false,
        },
      );
      await intent.launch();
    } catch (e) {
      debugPrint('Alarm intent error: $e');
    }
  }

  Future<void> _deleteAlarm(int index) async {
    setState(() => _alarms.removeAt(index));
    await _saveAlarms();
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  String _getPeriod(BuildContext context, int hour) {
    final s = S.of(context);
    if (hour < 6) return s?.periodNight ?? 'रात';
    if (hour < 12) return s?.periodMorning ?? 'सुबह';
    if (hour < 17) return s?.periodNoon ?? 'दोपहर';
    if (hour < 20) return s?.periodEvening ?? 'शाम';
    return s?.periodNight ?? 'रात';
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          S.of(context)?.alarmTitle ?? 'अलार्म / रिमाइंडर',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.alarm_add, color: Colors.white),
        label: Text(S.of(context)?.addAlarm ?? 'अलार्म जोड़ें', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _alarms.isEmpty ? _buildEmptyState(w) : _buildAlarmList(w),
    );
  }

  Widget _buildEmptyState(double w) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off, size: w * 0.2, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            s?.noAlarms ?? 'कोई अलार्म नहीं',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            s?.pressPlusToAdd ?? 'नीचे + बटन दबाकर अलार्म जोड़ें',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            s?.alarmHint ?? 'खेत में पानी देना, दवाई छिड़कना,\nबीज बोना - सब याद रहेगा!',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmList(double w) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(w * 0.04, 16, w * 0.04, 100),
      itemCount: _alarms.length,
      itemBuilder: (context, index) {
        final alarm = _alarms[index];
        final hour = alarm['hour'] as int;
        final minute = alarm['minute'] as int;
        final task = alarm['task'] as String;
        final enabled = alarm['enabled'] as bool;

        return Dismissible(
          key: Key('${alarm['id']}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _deleteAlarm(index),
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete, color: Colors.white, size: 28),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.green.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
              ],
              border: Border.all(color: enabled ? const Color(0xFFA5D6A7) : Colors.grey[300]!, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Row(
                children: [
                  // Time
                  Container(
                    width: w * 0.2,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: enabled ? const Color(0xFFE8F5E9) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _formatTime(hour, minute),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: enabled ? const Color(0xFF2E7D32) : Colors.grey,
                          ),
                        ),
                        Text(
                          _getPeriod(context, hour),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: enabled ? const Color(0xFF43A047) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  // Task name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: enabled ? Colors.black87 : Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          S.of(context)?.swipeToDelete ?? '← हटाने के लिए स्वाइप करें',
                          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  // Toggle
                  Switch(
                    value: enabled,
                    activeColor: const Color(0xFF2E7D32),
                    onChanged: (val) {
                      setState(() => _alarms[index]['enabled'] = val);
                      _saveAlarms();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
