import 'package:flutter/material.dart';

class WorkRegisteredDetailScreen extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String description;

  const WorkRegisteredDetailScreen({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient nền tổng thể
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 5, 26, 35), Color.fromARGB(255, 15, 38, 46)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar tùy chỉnh
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Chi tiết công việc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Container chi tiết công việc
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.1 * 255).round()), // nền trong suốt sáng
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.3 * 255).round()),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ngày bắt đầu
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.orangeAccent, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Bắt đầu: $startDate',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Ngày kết thúc
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.orangeAccent, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Kết thúc: $endDate',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mô tả
                      const Text(
                        'Mô tả công việc:',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
