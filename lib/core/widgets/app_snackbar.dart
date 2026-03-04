import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String message) {
  _show(
    context,
    message: message,
    icon: Icons.check_circle_rounded,
    backgroundColor: const Color(0xFF16A34A),
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  _show(
    context,
    message: message,
    icon: Icons.error_rounded,
    backgroundColor: const Color(0xFFDC2626),
  );
}

void _show(
  BuildContext context, {
  required String message,
  required IconData icon,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        elevation: 8,
      ),
    );
}
