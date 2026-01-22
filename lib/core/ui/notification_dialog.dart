import 'package:flutter/material.dart';

class NotificationDialog {
  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    required String title,
    required String body,
    VoidCallback? onViewDetail,
  }) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (onViewDetail != null)
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _isShowing = false;
                            onViewDetail();
                          },
                          child: const Text('Xem chi tiết'),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _isShowing = false;
                        },
                        child: const Text('Đóng'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// LOGO
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/icons/logo.png',
                width: 56,
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      _isShowing = false;
    });
  }
}
