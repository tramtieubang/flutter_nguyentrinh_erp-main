import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Gradient? backgroundGradient;
  const MainAppBar({super.key, required this.title, this.backgroundGradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient ??
            const LinearGradient(
              colors: [Color.fromARGB(255, 5, 21, 28), Color.fromARGB(255, 11, 33, 41)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
