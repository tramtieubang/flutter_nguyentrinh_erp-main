import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../work/work_screen.dart';
import '../profile/profile_screen.dart';

import '../../core/events/notification_event.dart';
import '../../core/services/notification_service.dart';
import 'widgets/main_app_bar.dart';
import 'widgets/main_bottom_nav.dart';

/// =======================================================
/// 🧭 MAIN SCREEN
/// - Quản lý BottomNavigation
/// - Giữ state bằng IndexedStack
/// - Nhận callback đổi tab từ Home
/// - Quản lý badge thông báo
/// =======================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// ===============================
  /// STATE
  /// ===============================

  /// 👉 Tab đang chọn (BottomNavigation)
  int _currentIndex = 0;

  /// 🔔 Số thông báo chưa đọc
  int _unreadCount = 0;

  /// 🔥 Filter trạng thái cho WorkScreen
  int? _workStatusId;

  /// 🔥 Tab TRÊN (TabBar) của WorkScreen
  int _workInitialTab = 0;

  /// ===============================
  /// INIT
  /// ===============================
  @override
  void initState() {
    super.initState();

    /// 🔔 Lắng nghe thay đổi badge thông báo toàn app
    NotificationEvent.unreadStream.listen((count) {
      if (!mounted) return;
      setState(() => _unreadCount = count);
    });

    /// 🔥 Load số thông báo khi app mở
    _loadUnreadCount();
  }

  /// ===============================
  /// LOAD BADGE THÔNG BÁO
  /// ===============================
  Future<void> _loadUnreadCount() async {
    try {
      final count = await NotificationService.fetchUnreadCount();

      /// 🔔 Update stream toàn app
      NotificationEvent.updateUnread(count);
    } catch (e) {
      debugPrint('❌ Load unread error: $e');
    }
  }

  /// ===============================
  /// 👉 ĐỔI TAB TỪ HOME / BOTTOM NAV
  /// ===============================
  void _changeTab({
    int? statusId,
    required int tabBottomIndex,
    int tabTopIndex = 0,
  }) {
    setState(() {
      /// 👉 Đổi tab dưới
      _currentIndex = tabBottomIndex;

      /// 👉 Nếu vào tab Công việc
      if (tabBottomIndex == 2) {
        _workStatusId = statusId;
        _workInitialTab = tabTopIndex;
      } else {
        _workStatusId = null;
        _workInitialTab = 0;
      }
    });

    /// 🔔 Vào tab Thông báo → reload badge
    if (tabBottomIndex == 1) {
      _loadUnreadCount();
    }
  }

  /// ===============================
  /// TITLE THEO TAB
  /// ===============================
  final List<String> _titles = const [
    'TRANG CHỦ',
    'THÔNG BÁO',
    'CÔNG VIỆC',
    'CÁ NHÂN',
  ];

  /// ===============================
  /// BUILD UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ===== APP BAR =====
      appBar: MainAppBar(
        title: _titles[_currentIndex],
      ),

      /// ===== BODY =====
      body: Container(
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
          child: IndexedStack(
            index: _currentIndex,
            children: [
              /// ===== 🏠 HOME =====
              HomeScreen(
                key: const PageStorageKey('home'),
                onChangeTab: _changeTab,
              ),

              /// ===== 🔔 NOTIFICATION =====
              const NotificationScreen(
                key: PageStorageKey('notification'),
              ),

              /// ===== 📋 WORK =====
              WorkScreen(
                key: const PageStorageKey('work'),
                status: _workStatusId,
                initialTab: _workInitialTab,
              ),

              /// ===== 👤 PROFILE =====
              const ProfileScreen(
                key: PageStorageKey('profile'),
              ),
            ],
          ),
        ),
      ),

      /// ===== BOTTOM NAV =====
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        unreadCount: _unreadCount,
        onTap: (index) {
          _changeTab(tabBottomIndex: index);
        },
      ),
    );
  }
}
