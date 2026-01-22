import 'package:flutter/material.dart';
import 'register_submit_button.dart';
import 'register_date_picker.dart';
import '../../../../core/services/work_registered_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      _showError('Vui lòng chọn ngày bắt đầu');
      return;
    }

    setState(() => _loading = true);

    final result = await WorkRegisteredService.submit(
      title: _titleController.text,
      description: _descController.text,
      startDate: _startDate!,
      endDate: _endDate,
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký công việc thành công'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      _showError('Không thể đăng ký. Vui lòng thử lại');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Tên công việc',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Không được để trống' : null,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _descController,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Mô tả',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          RegisterDatePicker(
            label: 'Ngày bắt đầu',
            onPicked: (d) => _startDate = d,
          ),
          const SizedBox(height: 20),
          RegisterDatePicker(
            label: 'Ngày kết thúc (nếu có)',
            onPicked: (d) => _endDate = d,
          ),
          const SizedBox(height: 24),

          RegisterSubmitButton(
            loading: _loading,
            onPressed: _loading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
