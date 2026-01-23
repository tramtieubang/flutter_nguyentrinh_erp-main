import 'package:flutter/material.dart';

import 'registered/work_registered_screen.dart';
import 'assignment/work_assignment_screen.dart';

/// =======================================================
/// MÀN HÌNH CÔNG VIỆC
/// - Có 2 TAB trên đầu
/// - Nhận TAB mặc định từ bên ngoài (BottomNavigation)
/// - Có thể truyền status sang tab "Đã duyệt"
/// =======================================================
class WorkScreen extends StatefulWidget {
  final int? status;       // 👈 status công việc (truyền sang tab Đã duyệt)
  final int initialTab;    // 👈 tab trên đầu cần mở (0 hoặc 1)

  const WorkScreen({
    super.key,
    this.status,
    this.initialTab = 0,
  });

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>
    with SingleTickerProviderStateMixin,
         AutomaticKeepAliveClientMixin {

  late TabController _tabController;
  int? _currentStatus; // 👈 lưu status hiện tại

  /// =======================================================
  /// GIỮ STATE KHI CHUYỂN TAB / BOTTOM TAB
  /// =======================================================
  @override
  bool get wantKeepAlive => true;

  /// =======================================================
  /// KHỞI TẠO TAB CONTROLLER
  /// =======================================================
  @override
  void initState() {
    super.initState();

    _currentStatus = widget.status;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab, // 👈 LẤY TAB TỪ BÊN NGOÀI
    );
  }

  /// =======================================================
  /// LẮNG NGHE KHI initialTab / status THAY ĐỔI
  /// (BẮT BUỘC PHẢI CÓ)
  /// =======================================================
  @override
  void didUpdateWidget(covariant WorkScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 👉 Khi tab trên đầu thay đổi từ bên ngoài
    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab);
    }

    // 👉 Khi status thay đổi
    if (oldWidget.status != widget.status) {
      setState(() {
        _currentStatus = widget.status;
      });
    }
  }

  /// =======================================================
  /// GIẢI PHÓNG CONTROLLER
  /// =======================================================
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// =======================================================
  /// UI CHÍNH
  /// =======================================================
  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 BẮT BUỘC cho KeepAlive

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
          child: Column(
            children: [
              /// ================= TAB BAR (TRÊN ĐẦU) =================
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Đã đăng ký'),
                    Tab(text: 'Đã duyệt'),
                  ],
                ),
              ),

              /// ================= TAB VIEW =================
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    /// ---------- TAB 1: ĐÃ ĐĂNG KÝ ----------
                    const WorkRegisteredScreen(),

                    /// ---------- TAB 2: ĐÃ DUYỆT ----------
                    WorkAssignmentScreen(
                      status: _currentStatus, // 👈 status đã xử lý
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
