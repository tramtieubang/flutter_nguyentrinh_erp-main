import 'package:flutter/material.dart';
import '../../../core/models/work_registered_model.dart';
import '../../../core/services/work_registered_service.dart';
import 'widgets/work_registered_item_card.dart';

class WorkRegisteredScreen extends StatefulWidget {
  final int? status;

  const WorkRegisteredScreen({super.key, this.status});

  @override
  State<WorkRegisteredScreen> createState() => _WorkRegisteredScreenState();
}

class _WorkRegisteredScreenState extends State<WorkRegisteredScreen>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  final List<WorkRegisteredModel> works = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadWorks(); // 🔥 load lần đầu
  }

  /// 🔥 BẮT BUỘC: reload khi status thay đổi
  @override
  void didUpdateWidget(covariant WorkRegisteredScreen oldWidget) {
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
      final data = await WorkRegisteredService.getWorks(
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
                        return WorkRegisteredItemCard(item: works[index]);
                      },
                    ),
        ),
      ),
    );
  }
}
