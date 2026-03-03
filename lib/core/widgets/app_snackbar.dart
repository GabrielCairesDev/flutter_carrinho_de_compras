import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String message) {
  _show(context, message, Colors.green.shade700, Icons.check_circle_outline);
}

void showErrorSnackbar(BuildContext context, String message) {
  _show(context, message, Colors.red.shade700, Icons.error_outline);
}

void _show(
  BuildContext context,
  String message,
  Color color,
  IconData icon,
) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
}
