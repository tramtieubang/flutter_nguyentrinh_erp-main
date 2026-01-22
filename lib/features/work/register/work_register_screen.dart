import 'package:flutter/material.dart';
import 'widgets/register_form.dart';

class WorkRegisterScreen extends StatelessWidget {
  const WorkRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký công việc'),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,

        // ✅ GRADIENT ĐÚNG CÁCH
        flexibleSpace: Container(
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: RegisterForm(),
        ),
      ),
    );
  }
}
