import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color? textColor;
  final Duration duration;
  final IconData icon;
  final Function? onDismissed;

  CustomSnackbar({
    required this.message,
    this.backgroundColor = Colors.blue,
    this.duration = const Duration(seconds: 2),
    this.icon = Icons.info_outline,
    this.onDismissed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white)
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: SnackBarAction(
        label: 'DISMISS',
        onPressed: () {
          if (onDismissed != null) {
            onDismissed!();
          }
        },
      ),
    );
  }
}
