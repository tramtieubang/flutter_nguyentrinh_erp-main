import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterDatePicker extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime> onPicked;

  const RegisterDatePicker({
    super.key,
    required this.label,
    required this.onPicked,
  });

  @override
  State<RegisterDatePicker> createState() => _RegisterDatePickerState();
}

class _RegisterDatePickerState extends State<RegisterDatePicker> {
  DateTime? _dateTime;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    // ===== CHỌN NGÀY =====
    final date = await showDatePicker(
      context: context,
      locale: const Locale('vi', 'VN'), // 🔥 VIỆT HOÁ
      initialDate: _dateTime ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (!mounted || date == null) return;

    // ===== CHỌN GIỜ + PHÚT =====
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime ?? now),
    );

    if (!mounted || time == null) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      0, // ⚠️ Flutter KHÔNG hỗ trợ chọn giây
    );

    setState(() => _dateTime = picked);
    widget.onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _dateTime == null
        ? widget.label
        : DateFormat('dd/MM/yyyy HH:mm:ss', 'vi').format(_dateTime!);

    return InkWell(
      onTap: _pickDateTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        child: Text(displayText),
      ),
    );
  }
}
