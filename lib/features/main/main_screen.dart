import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../work/work_screen.dart';
import '../profile/profile_screen.dart';

import '../../core/events/notification_event.dart'; // 🔥 THÊM
import 'widgets/main_app_bar.dart';
import 'widgets/main_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  /// 🔥 status nhận từ Home (badge / statistic)
  int? _workStatusId;

  /// 👉 Đổi tab (dùng chung cho Home + BottomNav)
  void _changeTab(int index, {int? statusId}) {
    setState(() {
      _currentIndex = index;

      // ✅ Chỉ giữ status khi vào tab Công việc
      if (index == 2) {
        _workStatusId = statusId;
      } else {
        _workStatusId = null;
      }
    });

    /// 🔔 Nếu vào tab THÔNG BÁO → reload
    if (index == 1) {
      NotificationEvent.notify();
    }
  }

  

  final List<String> _titles = const [
    'TRANG CHỦ',
    'THÔNG BÁO',
    'CÔNG VIỆC',
    'CÁ NHÂN',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== APP BAR =====
      appBar: MainAppBar(
        title: _titles[_currentIndex],
      ),

      // ===== BODY =====
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
          child: IndexedStack(
            index: _currentIndex,
            children: [
              /// 🏠 HOME
              HomeScreen(
                key: const PageStorageKey('home'),
                onChangeTab: _changeTab,
              ),

              /// 🔔 NOTIFICATION
              const NotificationScreen(
                key: PageStorageKey('notification'),
              ),

              /// 🧾 WORK
              WorkScreen(
                key: const PageStorageKey('work'),
                status: _workStatusId,
              ),

              /// 👤 PROFILE
              const ProfileScreen(
                key: PageStorageKey('profile'),
              ),
            ],
          ),
        ),
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _changeTab(index),
      ),
    );
  }
}
