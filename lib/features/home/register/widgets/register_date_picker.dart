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
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    final text = _date == null
        ? widget.label
        : DateFormat('dd/MM/yyyy').format(_date!);

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() => _date = picked);
          widget.onPicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        child: Text(text),
      ),
    );
  }
}
