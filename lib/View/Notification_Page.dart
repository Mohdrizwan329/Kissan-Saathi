import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const _green1 = Color(0xFF1B5E20);
  static const _green2 = Color(0xFF388E3C);
  static const _cream = Color(0xFFE8F5E9);

  final List<_NotifItem> _notifications = [
    _NotifItem(
      icon: '🌾',
      iconBg: Color(0xFF1B5E20),
      title: 'खरीफ सीजन शुरू',
      titleEn: 'Kharif Season Begins',
      subtitle: 'धान, मक्का, सोयाबीन की बुवाई का सही समय आ गया है।',
      subtitleEn: 'The right time has come to sow paddy, maize and soybean.',
      time: 'अभी',
      timeEn: 'Now',
      isRead: false,
      tag: 'फसल',
      tagEn: 'Crop',
      tagColor: Color(0xFF1B5E20),
    ),
    _NotifItem(
      icon: '💰',
      iconBg: Color(0xFFE65100),
      title: 'MSP अपडेट 2026',
      titleEn: 'MSP Update 2026',
      subtitle: 'गेहूं का न्यूनतम समर्थन मूल्य ₹2,425 प्रति क्विंटल तय किया गया।',
      subtitleEn: 'Minimum support price of wheat fixed at ₹2,425 per quintal.',
      time: '2 घंटे पहले',
      timeEn: '2 hours ago',
      isRead: false,
      tag: 'सरकारी',
      tagEn: 'Govt',
      tagColor: Color(0xFFE65100),
    ),
    _NotifItem(
      icon: '🌧️',
      iconBg: Color(0xFF01579B),
      title: 'मौसम चेतावनी',
      titleEn: 'Weather Alert',
      subtitle: 'अगले 48 घंटों में भारी बारिश की संभावना। फसलों की सुरक्षा करें।',
      subtitleEn: 'Heavy rain expected in the next 48 hours. Protect your crops.',
      time: '5 घंटे पहले',
      timeEn: '5 hours ago',
      isRead: false,
      tag: 'मौसम',
      tagEn: 'Weather',
      tagColor: Color(0xFF01579B),
    ),
    _NotifItem(
      icon: '🛡️',
      iconBg: Color(0xFF6A1B9A),
      title: 'फसल बीमा अंतिम तिथि',
      titleEn: 'Crop Insurance Deadline',
      subtitle: 'PM फसल बीमा योजना के लिए आवेदन की अंतिम तिथि 31 जुलाई है।',
      subtitleEn: 'Last date to apply for PM Fasal Bima Yojana is July 31.',
      time: '1 दिन पहले',
      timeEn: '1 day ago',
      isRead: true,
      tag: 'योजना',
      tagEn: 'Scheme',
      tagColor: Color(0xFF6A1B9A),
    ),
    _NotifItem(
      icon: '🌱',
      iconBg: Color(0xFF2E7D32),
      title: 'नई खाद उपलब्ध',
      titleEn: 'New Fertilizer Available',
      subtitle: 'यूरिया और DAP खाद आपके नजदीकी केंद्र पर उपलब्ध है।',
      subtitleEn: 'Urea and DAP fertilizer is available at your nearest centre.',
      time: '2 दिन पहले',
      timeEn: '2 days ago',
      isRead: true,
      tag: 'खाद',
      tagEn: 'Fertilizer',
      tagColor: Color(0xFF2E7D32),
    ),
    _NotifItem(
      icon: '💧',
      iconBg: Color(0xFF00695C),
      title: 'सिंचाई सुझाव',
      titleEn: 'Irrigation Tip',
      subtitle: 'गर्मी में ड्रिप सिंचाई से 50% पानी बचाएं और फसल की पैदावार बढ़ाएं।',
      subtitleEn: 'Save 50% water with drip irrigation in summer and increase crop yield.',
      time: '3 दिन पहले',
      timeEn: '3 days ago',
      isRead: true,
      tag: 'सिंचाई',
      tagEn: 'Irrigation',
      tagColor: Color(0xFF00695C),
    ),
    _NotifItem(
      icon: '📋',
      iconBg: Color(0xFF4E342E),
      title: 'किसान क्रेडिट कार्ड',
      titleEn: 'Kisan Credit Card',
      subtitle: 'KCC के लिए आवेदन करें और 3 लाख तक का ऋण 4% ब्याज पर पाएं।',
      subtitleEn: 'Apply for KCC and get a loan up to ₹3 lakh at 4% interest.',
      time: '1 सप्ताह पहले',
      timeEn: '1 week ago',
      isRead: true,
      tag: 'वित्त',
      tagEn: 'Finance',
      tagColor: Color(0xFF4E342E),
    ),
    _NotifItem(
      icon: '🐄',
      iconBg: Color(0xFF37474F),
      title: 'पशु टीकाकरण शिविर',
      titleEn: 'Animal Vaccination Camp',
      subtitle: 'निःशुल्क पशु टीकाकरण शिविर 25 अप्रैल को आपके गांव में लगेगा।',
      subtitleEn: 'Free animal vaccination camp will be held in your village on April 25.',
      time: '1 सप्ताह पहले',
      timeEn: '1 week ago',
      isRead: true,
      tag: 'पशु पालन',
      tagEn: 'Animal Care',
      tagColor: Color(0xFF37474F),
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(int index) {
    setState(() => _notifications[index].isRead = true);
  }

  void _deleteNotification(int index) {
    setState(() => _notifications.removeAt(index));
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isHindi ? 'सूचनाएं' : 'Notifications',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('$_unreadCount',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_green1, _green2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                isHindi ? 'सब पढ़ें' : 'Mark all read',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmpty(isHindi)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _notifications.length,
              itemBuilder: (context, index) => _buildNotifTile(index, isHindi),
            ),
    );
  }

  Widget _buildNotifTile(int index, bool isHindi) {
    final n = _notifications[index];
    return Dismissible(
      key: Key('notif_$index${n.title}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteNotification(index),
      child: GestureDetector(
        onTap: () => _markRead(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: n.isRead ? Colors.white : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: n.isRead ? Colors.grey.shade200 : _green2.withValues(alpha: 0.4),
              width: n.isRead ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: n.isRead ? 0.04 : 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: n.iconBg.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Center(child: Text(n.icon, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isHindi ? n.title : n.titleEn,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!n.isRead)
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHindi ? n.subtitle : n.subtitleEn,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600], height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: n.tagColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isHindi ? n.tag : n.tagEn,
                              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: n.tagColor),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            isHindi ? n.time : n.timeEn,
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isHindi) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            isHindi ? 'कोई सूचना नहीं' : 'No Notifications',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            isHindi ? 'नई सूचनाएं यहाँ दिखेंगी' : 'New notifications will appear here',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _NotifItem {
  final String icon;
  final Color iconBg;
  final String title;
  final String titleEn;
  final String subtitle;
  final String subtitleEn;
  final String time;
  final String timeEn;
  bool isRead;
  final String tag;
  final String tagEn;
  final Color tagColor;

  _NotifItem({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.titleEn,
    required this.subtitle,
    required this.subtitleEn,
    required this.time,
    required this.timeEn,
    required this.isRead,
    required this.tag,
    required this.tagEn,
    required this.tagColor,
  });
}
