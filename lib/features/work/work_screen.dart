import 'package:flutter/material.dart';

import 'registered/work_registered_screen.dart';
import 'assignment/work_assignment_screen.dart';

class WorkScreen extends StatefulWidget {
  final int? status;

  const WorkScreen({super.key, this.status});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  /* void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  } */

  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 1, // 🔥 MẶC ĐỊNH TAB "CÔNG VIỆC PHÂN CÔNG"
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          child: Column(
            children: [
              /// ===== TAB BAR =====
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
                    Tab(text: 'Đã duệt'),
                  ],
                ),
              ),

              /// ===== TAB VIEW =====
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    /// TAB 1
                    WorkRegisteredScreen(),

                    /// TAB 2
                    WorkAssignmentScreen(
                      status: widget.status,
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
