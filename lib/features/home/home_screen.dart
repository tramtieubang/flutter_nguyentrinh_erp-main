import 'package:flutter/material.dart';

import '../../core/session/user_session.dart';
import '../../core/models/user_model.dart';
import '../../core/models/work_status_model.dart';
import '../../core/services/work_assignment_service.dart';
//import '../../config/api_config.dart';

import 'widgets/home_header.dart';
import 'widgets/statistic_card.dart';
import 'widgets/feature_grid.dart';

/// =======================================================
/// 🏠 HOME SCREEN
/// - Tự động cập nhật tên + avatar khi update profile
/// - Statistic load 1 lần / user
/// - Giữ state khi đổi tab
/// =======================================================
class HomeScreen extends StatefulWidget {
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
  bool _loadingStatistic = false;
  List<WorkStatus> _statuses = [];

  /// lưu userId đã load statistic
  int? _loadedUserId;

  @override
  bool get wantKeepAlive => true;

  /// ===============================
  /// LOAD STATISTIC
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
    super.build(context);

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
              /// ⛔ CHƯA LOGIN
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              /// 🔥 LOAD STATISTIC KHI USER ĐỔI
              if (_loadedUserId != user.id) {
                _loadedUserId = user.id;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _loadStatistic();
                });
              }

              /// ================= USER INFO =================

              /// ✅ NAME (ưu tiên profile.name, fallback username)
              final String? profileName = user.profile?.name;

              final String name =
                  profileName != null && profileName.isNotEmpty
                      ? profileName
                      : user.username;

              final String? profilePhone = user.profile?.phone;

              final String phone =
                  profilePhone != null && profilePhone.isNotEmpty
                      ? profilePhone
                      : 'Chưa cập nhật';

              /// ✅ SUBTITLE
              // final String subtitle = user.email ?? 'Hệ thống quản lý nội bộ';
              final String subtitle = phone;

              /// ✅ AVATAR (chuẩn hóa URL + bust cache)                         
              final String avatar = user.profile?.avatar ?? '';
              

             /*  if (rawAvatar != null && rawAvatar.isNotEmpty) {
                /// backend đã trả URL đầy đủ (UrlHelper::avatar)
                avatar = '$rawAvatar?uid=${user.id}';
              } */

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= HEADER =================
                    HomeHeader(
                      name: name,
                      subtitle: subtitle,
                      avatar: avatar,
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
