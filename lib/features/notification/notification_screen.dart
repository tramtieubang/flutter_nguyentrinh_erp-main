import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/models/notification_model.dart';
import '../../core/services/notification_service.dart';
import '../../core/events/notification_event.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  bool _loading = true;
  List<NotificationModel> _notifications = [];
  StreamSubscription? _reloadSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _reloadSub = NotificationEvent.reloadStream.listen((_) {
      _loadNotifications();
    });

    _loadNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reloadSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() => _loading = true);

    final list = await NotificationService.fetchNotifications();
    final unread = list.where((e) => !e.isRead).length;

    if (!mounted) return;

    setState(() {
      _notifications = list;
      _loading = false;
    });

    NotificationEvent.updateUnread(unread);
  }

  Future<void> _openNotification(NotificationModel item) async {
    if (!item.isRead) {
      final ok = await NotificationService.markAsRead(item.id);
      if (ok && mounted) {
        setState(() => item.isRead = true);

        final unread =
            _notifications.where((e) => !e.isRead).length;
        NotificationEvent.updateUnread(unread);
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
    ).then((_) => NotificationEvent.notify());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Text('Không có thông báo', style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = _notifications[i];
        final unread = !item.isRead;

        return GestureDetector(
          onTap: () => _openNotification(item),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: unread
                  ? Colors.orange.withAlpha(30)
                  : Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: unread ? Colors.orange : Colors.white24,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications,
                    color: unread ? Colors.orange : Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                unread ? FontWeight.bold : FontWeight.normal,
                          )),
                      const SizedBox(height: 6),
                      Text(item.createdAt,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                if (unread)
                  const Icon(Icons.circle,
                      size: 10, color: Colors.orange),
              ],
            ),
          ),
        );
      },
    );
  }
}
