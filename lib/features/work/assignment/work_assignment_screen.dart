import 'package:flutter/material.dart';
import '../../../core/models/work_assignment_model.dart';
import '../../../core/services/work_assignment_service.dart';
import 'widgets/work_assignment_item_card.dart';

class WorkAssignmentScreen extends StatefulWidget {
  final int? status;

  const WorkAssignmentScreen({super.key, this.status});

  @override
  State<WorkAssignmentScreen> createState() => _WorkAssignmentScreenState();
}

class _WorkAssignmentScreenState extends State<WorkAssignmentScreen>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  final List<WorkAssignmentModel> works = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadWorks(); // 🔥 load lần đầu
  }

  /// 🔥 BẮT BUỘC: reload khi status thay đổi
  @override
  void didUpdateWidget(covariant WorkAssignmentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status != widget.status) {
      _reloadWorks();
    }
  }

  void _reloadWorks() {
    setState(() {
      works.clear();
      _loading = true;
    });
    _loadWorks();
  }

  Future<void> _loadWorks() async {
    try {
      final data = await WorkAssignmentService.getWorks(
        status: widget.status, // 🔥 lọc theo trạng thái
      );

      if (!mounted) return;

      setState(() {
        works.addAll(data);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
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
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orangeAccent,
                  ),
                )
              : works.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có công việc',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: works.length,
                      separatorBuilder: (_,_) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return WorkAssignmentItemCard(item: works[index]);
                      },
                    ),
        ),
      ),
    );
  }
}
