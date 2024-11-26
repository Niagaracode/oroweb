import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String message;
  final int code;

  const GlobalSnackBar({
    required this.message, required this.code
  });

  static show(BuildContext context, String message, int code) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: code == 200 ? null : Colors.redAccent,
      ),
    );
  }
}