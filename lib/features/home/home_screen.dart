import 'package:flutter/material.dart';

import '../../core/session/user_session.dart';
import '../../core/models/user_model.dart';
import '../../core/models/work_status_model.dart';
import '../../core/services/work_assignment_service.dart';

import 'widgets/home_header.dart';
import 'widgets/statistic_card.dart';
import 'widgets/feature_grid.dart';

/// =======================================================
/// 🏠 HOME SCREEN
/// - Giữ state khi đổi tab
/// - Load thống kê công việc
/// - KHÔNG xử lý badge thông báo
/// =======================================================
class HomeScreen extends StatefulWidget {
  /// callback đổi tab từ Home → MainScreen
  final void Function(int index, {int? statusId})? onChangeTab;

  const HomeScreen({
    super.key,
    this.onChangeTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  /// ===============================
  /// STATE
  /// ===============================
  bool _loadingStatistic = true;
  List<WorkStatus> _statuses = [];

  /// Giữ state khi đổi tab BottomNavigationBar
  @override
  bool get wantKeepAlive => true;

  /// ===============================
  /// INIT
  /// ===============================
  @override
  void initState() {
    super.initState();
    _loadStatistic();
  }

  /// ===============================
  /// LOAD: thống kê công việc
  /// ===============================
  Future<void> _loadStatistic() async {
    try {
      final data = await WorkAssignmentService.getStatusCounts();
      if (!mounted) return;

      setState(() {
        _statuses = data;
        _loadingStatistic = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _statuses = [];
        _loadingStatistic = false;
      });
    }
  }

  /// ===============================
  /// BUILD
  /// ===============================
  @override
  Widget build(BuildContext context) {
    super.build(context); // ⚠️ bắt buộc khi dùng KeepAlive

    return Scaffold(
      backgroundColor: Colors.transparent,
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
          child: ValueListenableBuilder<UserModel?>(
            valueListenable: UserSession.currentUser,
            builder: (context, user, _) {
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              /// ================= USER INFO =================
              final profileName = user.profile?.name;
              final String name =
                  (profileName != null && profileName.isNotEmpty)
                      ? profileName
                      : user.username;

              final String avatar = user.profile?.avatar ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= HEADER =================
                    HomeHeader(
                      name: name,
                      avatar: avatar,
                      subtitle: 'Hệ thống quản lý nội bộ',
                    ),

                    const SizedBox(height: 20),

                    /// ================= STATISTIC =================
                    _loadingStatistic
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : StatisticCard(
                            statuses: _statuses,
                            onTapStatus: (statusId) {
                              widget.onChangeTab?.call(
                                2,
                                statusId: statusId,
                              );
                            },
                          ),

                    const SizedBox(height: 28),

                    /// ================= FEATURE =================
                    const Text(
                      'Chức năng',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    FeatureGrid(
                      onChangeTab: widget.onChangeTab,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
