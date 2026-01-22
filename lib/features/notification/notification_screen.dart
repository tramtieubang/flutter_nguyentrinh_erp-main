import 'package:flutter/material.dart';

import '../../core/models/notification_model.dart';
import '../../core/services/notification_service.dart';
import '../../core/events/notification_event.dart';
import '../../core/routes/route_observer.dart';
import 'notification_detail_screen.dart';

/// =================================================
/// 🔔 MÀN HÌNH DANH SÁCH THÔNG BÁO
/// - Luôn load lại khi:
///   + Có FCM mới
///   + Quay lại màn hình
///   + App chạy lâu / resume
/// =================================================
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver, RouteAware {
  bool _loading = true;
  List<NotificationModel> _notifications = [];

  // ===============================
  // INIT
  // ===============================
  @override
  void initState() {
    super.initState();

    /// 👂 Lắng nghe trạng thái app (resume)
    WidgetsBinding.instance.addObserver(this);

    /// 👂 Lắng nghe event từ FCM / badge
    NotificationEvent.refresh.addListener(_handleRefresh);

    /// 🔄 Load dữ liệu lần đầu
    _loadNotifications();
  }

  // ===============================
  // ROUTE OBSERVER
  // ===============================
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 👂 Lắng nghe khi quay lại screen
    /* routeObserver.subscribe(
      this,
      ModalRoute.of(context)!,
    ); */

    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }

  }

  @override
  void didPopNext() {
    /// ⬅️ Quay lại từ screen khác
    _loadNotifications();
  }

  // ===============================
  // APP LIFECYCLE
  // ===============================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// 🔄 App từ background → foreground
    if (state == AppLifecycleState.resumed) {
      _loadNotifications();
    }
  }

  // ===============================
  // DISPOSE
  // ===============================
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationEvent.refresh.removeListener(_handleRefresh);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // ===============================
  // EVENT REFRESH TỪ FCM / BADGE
  // ===============================
  void _handleRefresh() {
    _loadNotifications();
  }

  // ===============================
  // LOAD DANH SÁCH THÔNG BÁO
  // ===============================
  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() => _loading = true);

    try {
      final data = await NotificationService.fetchNotifications();
      if (!mounted) return;

      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // ===============================
  // MỞ THÔNG BÁO + ĐÁNH DẤU ĐÃ ĐỌC
  // ===============================
  Future<void> _openNotification(NotificationModel item) async {
    if (!item.isRead) {
      final ok = await NotificationService.markAsRead(item.id);

      if (ok && mounted) {
        setState(() => item.isRead = true);

        /// 🔥 cập nhật badge toàn app
        NotificationEvent.notify();
      }
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(
          title: item.title,
          time: item.createdAt,
          content: item.body,
        ),
      ),
    );
  }

  // ===============================
  // BUILD UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 5, 26, 35),
              Color.fromARGB(255, 15, 38, 46),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  )
                : _buildNotificationList(),
          ),
        ),
      ),
    );
  }

  // ===============================
  // UI DANH SÁCH THÔNG BÁO
  // ===============================
  Widget _buildNotificationList() {
    if (_notifications.isEmpty) {
      return const Center(
        child: Text(
          'Không có thông báo',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _notifications[index];
        final isUnread = !item.isRead;

        return GestureDetector(
          onTap: () => _openNotification(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnread
                  ? Colors.orange.withAlpha(35)
                  : Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnread ? Colors.orangeAccent : Colors.white24,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.notifications,
                  color: isUnread ? Colors.orangeAccent : Colors.white70,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight:
                              isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.createdAt,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.circle,
                      color: Colors.orangeAccent,
                      size: 10,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
