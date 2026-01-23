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
/// - Giữ state khi đổi tab (IndexedStack)
/// - Load thống kê công việc SAU KHI đã có user
/// - KHÔNG bị treo khi mở app từ notification
/// - KHÔNG gọi API trong build()
/// =======================================================
class HomeScreen extends StatefulWidget {
  /// 🔁 Callback đổi tab từ Home → MainScreen
  /// Dùng named parameters cho rõ ràng
  final void Function({
    int? statusId,
    required int tabBottomIndex,
    int tabTopIndex,
  })? onChangeTab;

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

  /// 🔄 Loading thống kê
  bool _loadingStatistic = false;

  /// 📊 Danh sách trạng thái công việc
  List<WorkStatus> _statuses = [];

  /// 🔒 Đảm bảo chỉ load 1 lần sau khi có user
  bool _loadedOnce = false;

  /// ===============================
  /// GIỮ STATE KHI ĐỔI TAB
  /// ===============================
  @override
  bool get wantKeepAlive => true;

  /// ===============================
  /// LOAD THỐNG KÊ CÔNG VIỆC
  /// - Chỉ gọi khi đã có user
  /// ===============================
  Future<void> _loadStatistic() async {
    if (_loadingStatistic) return;

    setState(() => _loadingStatistic = true);

    try {
      final data = await WorkAssignmentService.getStatusCounts();
      if (!mounted) return;

      setState(() {
        _statuses = data;
        _loadingStatistic = false;
      });
    } catch (e) {
      debugPrint('❌ Load statistic error: $e');
      if (!mounted) return;

      setState(() {
        _statuses = [];
        _loadingStatistic = false;
      });
    }
  }

  /// ===============================
  /// BUILD UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    super.build(context); // ⚠️ bắt buộc với KeepAlive

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
              /// ⛔ CHƯA CÓ USER → HIỂN THỊ LOADING
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              /// 🔥 SAU KHI CÓ USER → LOAD THỐNG KÊ 1 LẦN
              if (!_loadedOnce) {
                _loadedOnce = true;

                /// ⚠️ Đẩy sang frame sau để tránh setState trong build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _loadStatistic();
                });
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
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ),
                          )
                        : StatisticCard(
                            statuses: _statuses,
                            onTapStatus: ({
                              int? statusId,
                              required int tabBottomIndex,
                              required int tabTopIndex,
                            }) {
                              /// 👉 Chuyển tab + filter công việc
                              widget.onChangeTab?.call(
                                statusId: statusId,
                                tabBottomIndex: tabBottomIndex,
                                tabTopIndex: tabTopIndex,
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

                    /// ================= GRID =================
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
