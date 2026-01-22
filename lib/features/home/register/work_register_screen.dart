import 'package:flutter/material.dart';
import 'widgets/register_form.dart';

class WorkRegisterScreen extends StatelessWidget {
  const WorkRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: RegisterForm(),
        ),
      ),
    );
  }
}
